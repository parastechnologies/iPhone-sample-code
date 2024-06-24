//
//  HTTPTask.swift
//  OMDA(Driver app)
//
//  Created by MAC on 17/06/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String:String]

public enum HTTPTask {
    case request
    
    case requestParameters(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    case requestJonParameters(bodyParameters: [Parameters]?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    case requestJonArray(bodyParameters: [Any]?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?)
    case requestJsnArray(bodyParameters: [Any]?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
    case requestParametersAndHeaders(bodyParameters: Parameters?,
        bodyEncoding: ParameterEncoding,
        urlParameters: Parameters?,
        additionHeaders: HTTPHeaders?)
    case requestMultipart(data: Data?,additionHeaders: HTTPHeaders?)
    // case download, upload...etc
}
