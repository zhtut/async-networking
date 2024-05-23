//
//  File.swift
//  
//
//  Created by shutut on 2024/5/23.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// 请求方法
public enum HTTPMethod: String {
    case GET
    case POST
    case DELETE
    case PUT
    case PATCH
}

/// 请求
public struct Request {
    
    /// 请求的path，url的path，/开头
    public var path: String
    public var method: HTTPMethod
    public var params: Any?
    public var header: [String: String]?
    public var timeOut: TimeInterval?
    public var printLog: Bool?
}
