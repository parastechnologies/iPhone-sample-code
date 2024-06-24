//
//  NetworkManager.swift
//  GunInstructor
//
//  Created by MAC on 17/06/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit

protocol APIModel : Codable {
//    var response: Int? { get }
    var success: Bool? { get}
    var message: String? { get }
    var errorMessage: String? { get }
    var code        : Int? { get }
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
    case errorReport(desc:String, response: Bool = false)
}
struct NetworkManager {
    static let sharedInstance = NetworkManager()
    private init() {}
    static let environment :NetworkEnvironment = .development
    static let ProfileImg  :OtherURLs = .profileURL
    static let contentType         = "application/json" //"application/x-www-form-urlencoded   multipart/form-data"
    let router = Router<APIEndPoint>()
    
    fileprivate func handleNetworkResponse(_ response : HTTPURLResponse, forData data : Data)->
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
               // print(String(bytes: data!, encoding: .utf8))
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(.failure(.errorReport(desc: NetworkResponse.noData.rawValue)))
                        return
                    }
                    do {
                        //print(String(bytes: responseData, encoding: .utf8))
                        //                        let json = try JSONSerialization.jsonObject(with: responseData, options: []) as! [String:Any]
                        let result = try JSONDecoder().decode(T.self, from: responseData)
                        if (result.success ?? false) == true{
                            completion(.success(result))
                        }
                        else {
                            completion(.failure(.errorReport(desc: result.message ?? "", response: result.success ?? false)))
                        }
                    }
                    catch {
                        print(error.localizedDescription)
                        print(error)
                        completion(.failure(.errorReport(desc: "Data Not Found")))
                    }
                case .failure(let networkFailureError):

                    
                    guard let responseData = data else {
                        completion(.failure(.errorReport(desc: NetworkResponse.noData.rawValue)))
                        return
                    }
                    do {
                        let result = try JSONDecoder().decode(T.self, from: responseData)
                        if result.success == false {
                            
                            if result.message == "Token is Invalid" || result.message == "Token is Expired" || result.code == 401 {
                                DispatchQueue.main.async {
                                    isSuspended = true
                                }
                            } else {
                                completion(.failure(.errorReport(desc: result.message ?? "")))
                            }
                        }
                        else{
                            completion(.failure(.errorReport(desc: NetworkResponse.noData.rawValue)))
                        }
                    }
                    catch {
                        print(error.localizedDescription)
                        print(error)
                        completion(.failure(.errorReport(desc: networkFailureError)))
                    }
                }
            }
        }
    }

    func handleMultipartProgress(completion: @escaping ((Double) -> Void)){
        router.observeProgress(completion: completion)
    }
}
