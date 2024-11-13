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

open class FormData {
    
    open var name: String
    open var data: Data
    open var contentType: String?
    open var filename: String?
    
    public init(name: String, data: Data, contentType: String? = nil, filename: String? = nil) {
        self.name = name
        self.data = data
        self.contentType = contentType
        self.filename = filename
    }
}

public struct DecodeConfig {
    
    public var dataKey: String?
    public var modelType: Decodable.Type?
    
    public init(dataKey: String? = nil, modelType: Decodable.Type?) {
        self.dataKey = dataKey
        self.modelType = modelType
    }
}

/// 请求
public class Request {
    
    /// 请求的path，url的path，/开头
    public var path: String
    public var method: HTTPMethod = .GET
    public var params: Any?
    public var header: [String: String]?
    public var timeOut: TimeInterval?
    public var decodeConfig: DecodeConfig?
    public var datas: [FormData]?
    public var printLog: Bool?
    
    public init(path: String,
                method: HTTPMethod = .GET,
                params: Any? = nil,
                header: [String : String]? = nil,
                timeOut: TimeInterval? = nil,
                decodeConfig: DecodeConfig? = nil,
                datas: [FormData]? = nil,
                printLog: Bool? = nil) {
        self.path = path
        self.method = method
        self.params = params
        self.header = header
        self.timeOut = timeOut
        self.decodeConfig = decodeConfig
        self.printLog = printLog
    }
    
    public var resourceTimeOut: TimeInterval?
    
    public var start: TimeInterval?
    public var end: TimeInterval?
    
    public var urlRequest: URLRequest?
    
    public weak var manager: Networking?
}

public extension Request {
    
    var finalTimeOut: TimeInterval {
        var final: TimeInterval?
        if let timeOut {
            final = timeOut
        }
        if let timeOut = manager?.config.timeOut {
            final = timeOut
        }
        if let final {
            return final
        }
        return kNetworkDefaultTimeOut
    }
    
    func urlString(_ baseURL: String) -> String {
        var string: String
        if path.hasPrefix("http") {
            string = path
        } else {
            let newPath: String
            if path.hasPrefix("/") {
                newPath = path
            } else {
                newPath = "/\(path)"
            }
            let newBaseURL: String
            if baseURL.hasSuffix("/") {
                newBaseURL = "\(baseURL.dropLast())"
            } else {
                newBaseURL = baseURL
            }
            string = newBaseURL + newPath
        }
        return string
    }
}

public extension Request {
    
    /// 请求体描述
    var paramsString: String {
        if let params {
            if let str = params as? String {
                return str
            } else if let data = params as? Data, let str = String(data: data, encoding: .utf8) {
                return str
            } else if JSONSerialization.isValidJSONObject(params),
                      let data = try? JSONSerialization.data(withJSONObject: params),
                      let str = String(data: data, encoding: .utf8) {
                return str
            }
        }
        return ""
    }
    
    var log: String {
        let urlStr = urlRequest?.url?.absoluteString ?? ""
        let headerFields = urlRequest?.allHTTPHeaderFields ?? header
        let method = urlRequest?.httpMethod ?? method.rawValue
        var message = ">>>>>>>>>>Start:\(start?.dateDesc ?? "")"
        message.append("\ncurl -X \(method) '\(urlStr)' \\")
        if let headerFields {
            for (key, value) in headerFields {
                message.append("\n -H '\(key): \(value)' \\")
            }
        }
        if method != "GET" {
            var httpBodyStr = ""
            if let body = urlRequest?.httpBody,
               let str = String(data: body, encoding: .utf8) {
                httpBodyStr = str
            } else if let _ = params {
                httpBodyStr = paramsString
            }
            message.append("\n -d '\(httpBodyStr)' \\")
        }
        if message.hasSuffix("\\") {
            message = "\(message.prefix(message.count - 2))"
        }
        return message
    }
}


extension Request: Identifiable, Equatable {
    
    public static func == (lhs: Request, rhs: Request) -> Bool {
        return lhs.id == rhs.id
    }
    
    public var id: String {
        var idStr = ""
        idStr += urlRequest?.url?.absoluteString ?? path
        idStr += method.rawValue
        idStr += header?.jsonString ?? ""
        idStr += paramsString
        return idStr
    }
}
