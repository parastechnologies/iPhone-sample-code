//
//  NetworkManager.swift
//  OMDA(Driver app)
//
//  Created by MAC on 17/06/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit

protocol APIModel : Codable {
    var status: String? { get }
    var message: String? { get }
}
enum NetworkResponse :String {
    case success
    case authenticationError = "You need to authenticate first."
    case badRequest          = "Bad Request"
    case outdated            = "The url you requested is outdated."
    case failed              = "Network request failed."
    case noData              = "Response returned with no data to decode."
    case unableToDecode      = "we couldn't decode the response"
}
enum APIResult<String>{
    case success
    case failure(String)
}
enum APIError :Error{
    case errorReport(desc:String)
}
struct NetworkManager {
    static let sharedInstance = NetworkManager()
    private init() {}
    static let environment :NetworkEnvironment = .development
    static let contentType         = "application/x-www-form-urlencoded"
    static let fullAudioBaseURL    = BaseURLs.FullAudio.rawValue
    static let trimAudioBaseURL    = BaseURLs.TrimAudio.rawValue
    static let recordVideoBaseURL  = BaseURLs.RecordVideo.rawValue
    static let profileImageBaseURL = BaseURLs.ProfileImage.rawValue
    static let chatImageBaseURL    = BaseURLs.ChatImages.rawValue
    static let termOfUserURL       = BaseURLs.TermOfUse.rawValue
    static let privacyURL          = BaseURLs.Privacy.rawValue
    let router = Router<APIEndPoint>()
    
    fileprivate func handleNetworkResponse(_ response : HTTPURLResponse, forData data : Data = Data())->
        APIResult<String>{
            switch response.statusCode{
            case 200...299 : return.success
            case 401...500 : return.failure(NetworkResponse.authenticationError.rawValue)
            case 501...599 : return.failure(NetworkResponse.badRequest.rawValue)
            case 600       : return.failure(NetworkResponse.outdated.rawValue)
            default        : return.failure(NetworkResponse.failed.rawValue)
            }
    }
    func handleAPICalling<T:APIModel>(request:APIEndPoint,completion: @escaping ((Result<T,APIError>) -> Void)){
        router.request(request) { (data, response, error) in
            if error != nil {
                completion(.failure(.errorReport(desc: "Please check your network connection.")))
            }
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response,forData:data ?? Data())
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(.failure(.errorReport(desc: NetworkResponse.noData.rawValue)))
                        return
                    }
                    do {
                        let result = try JSONDecoder().decode(T.self, from: responseData)
                        if result.status ?? "" == "200" {
                            completion(.success(result))
                        }
                        else {
                            completion(.failure(.errorReport(desc: result.message ?? "")))
                        }
                    }
                    catch {
                        print(error.localizedDescription)
                        completion(.failure(.errorReport(desc: "Data Not Found")))
                    }
                case .failure(let networkFailureError):
                    completion(.failure(.errorReport(desc: networkFailureError)))
                }
            }
        }
    }
    func downloadAudio(link:URL,completion:@escaping((Result<URL,APIError>)-> Void)) {
        guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            completion(.failure(.errorReport(desc: "Document file error")))
            return
        }
        // check if the file already exist at the destination folder if you don't want to download it twice
        if AppSettings.downloadedSongURL == link.absoluteString {
            let destinationURL = documentsDirectoryURL.appendingPathComponent("downloaded")
            completion(.success(destinationURL))
        }
        else {
            if FileManager.default.fileExists(atPath: documentsDirectoryURL.appendingPathComponent("downloaded").path) {
                do {
                    try FileManager.default.removeItem(at: documentsDirectoryURL.appendingPathComponent("downloaded"))
                } catch let error as NSError {
                    print(error.debugDescription)
                }
            }
            router.download(link) { (localURL, response, error) in
                if error != nil {
                    completion(.failure(.errorReport(desc: "Please check your network connection.")))
                }
                if let response = response as? HTTPURLResponse {
                    let result = self.handleNetworkResponse(response)
                    switch result{
                    case .success:
                        guard let location = localURL else {
                            completion(.failure(.errorReport(desc: NetworkResponse.noData.rawValue)))
                            return
                        }
                        AppSettings.downloadedSongURL = link.absoluteString
                        // create a deatination url with the server response suggested file name
                        let destinationURL = documentsDirectoryURL.appendingPathComponent("downloaded")
                        do {
                            try FileManager.default.moveItem(at: location, to: destinationURL)
                            completion(.success(destinationURL))
                            
                        } catch {
                            completion(.failure(.errorReport(desc: error.localizedDescription)))
                            
                        }
                        
                    case .failure(let failureError):
                        completion(.failure(.errorReport(desc: failureError)))
                    }
                }
            }
        }
        
    }
    func handleMultipartProgress(completion: @escaping ((Double) -> Void)){
        router.observeProgress(completion: completion)
    }
}
