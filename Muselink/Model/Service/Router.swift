//
//  Router.swift
//  OMDA(Driver app)
//
//  Created by MAC on 17/06/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()
public typealias DownloadRouterCompletion = (_ LoaclURL: URL?,_ response: URLResponse?,_ error: Error?)->()
protocol NetworkRouter  {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func request(_ route: EndPoint,delegate:URLSessionDelegate?, completion: @escaping NetworkRouterCompletion)
    func cancel()
}
class Router<EndPoint: EndPointType>: NetworkRouter {
    private var task: URLSessionTask?
    private var observation: NSKeyValueObservation?
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            NetworkLogger.log(request: request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        }catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    func download(_ link: URL, completion: @escaping DownloadRouterCompletion)  {
        let session = URLSession.shared
        task = session.downloadTask(with: link, completionHandler: { (localURL, response, error) in
            completion(localURL, response, error)
        })
        self.task?.resume()
    }
    func observeProgress(completion:@escaping (Double)->()) {
        observation = task?.progress.observe(\.fractionCompleted) { (progress, _) in
            print("Upload progress : --------------- \(progress.fractionCompleted)")
            completion(progress.fractionCompleted)
        }
    }
    func request(_ route: EndPoint,delegate:URLSessionDelegate?, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession(configuration: .default, delegate: delegate, delegateQueue: nil)
        do {
            let request = try self.buildRequest(from: route)
            NetworkLogger.log(request: request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        }catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
          
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 30)
        
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            case .requestMultipart(let data, let additionHeaders):
                request = URLRequest.init(url: URL.init(string: route.baseURL.absoluteString+route.path)!)
                
                request.httpMethod = route.httpMethod.rawValue
                self.addAdditionalHeaders(additionHeaders, request: &request)
                request.httpBody = data
            case .requestJonParameters(let bodyParameters, let bodyEncoding, let urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters,
                bodyEncoding: bodyEncoding,
                urlParameters: urlParameters,
                request: &request)
            case .requestJonArray(let bodyParameters, let bodyEncoding, let urlParameters):
                try self.configureParameters(bodyParameters: bodyParameters,
                bodyEncoding: bodyEncoding,
                urlParameters: urlParameters,
                request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    fileprivate func configureParameters(bodyParameters: [Parameters]?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    fileprivate func configureParameters(bodyParameters: [Any]?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
