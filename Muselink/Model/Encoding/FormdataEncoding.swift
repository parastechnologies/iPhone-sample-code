//
//  FormdataEncoding.swift
//  OMDA(Driver app)
//
//  Created by MAC on 17/06/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import Foundation

public struct FormdataParameterEncoder: ParameterEncoder {
    public func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        var paramResultStr = ""
        for (key,value) in parameters {
            paramResultStr += "\(key)=\(value)&"
        }
        if paramResultStr.hasSuffix("&") {
            paramResultStr.removeLast()
        }
        let postData =  paramResultStr.data(using: .utf8)
        urlRequest.httpBody = postData
    }
}
