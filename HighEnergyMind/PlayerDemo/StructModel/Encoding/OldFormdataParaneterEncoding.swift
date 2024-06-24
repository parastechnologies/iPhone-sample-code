//
//  FormdataParaneterEncoding.swift
//  Taqp
//
//  Created by appsDev on 02/04/20.
//  Copyright © 2020 appsdeveloper Developer. All rights reserved.
//
import Foundation
public struct OldFormdataParameterEncoder: ParameterEncoder {
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
