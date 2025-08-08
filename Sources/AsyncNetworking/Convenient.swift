//
//  File.swift
//
//
//  Created by shutut on 2024/5/23.
//

import Foundation

public extension Networking {
    
    /// 默认的实例
    static let shared = Networking()
    
    static func send(request: Request) async throws -> Response {
        try await Networking.shared.send(request: request)
    }
}

public extension Networking {
    
    func get(path: String,
             params: Any? = nil,
             header: [String : String]? = nil,
             timeOut: TimeInterval? = nil,
             decodeConfig: DecodeConfig? = nil,
             printLog: Bool? = nil) async throws -> Response {
        try await send(request: .init(path: path,
                                      method: .GET,
                                      params: params,
                                      header: header,
                                      timeOut: timeOut,
                                      decodeConfig: decodeConfig,
                                      printLog: printLog))
    }
    
    func delete(path: String,
                params: Any? = nil,
                header: [String : String]? = nil,
                timeOut: TimeInterval? = nil,
                decodeConfig: DecodeConfig? = nil,
                printLog: Bool? = nil) async throws -> Response {
        try await send(request: .init(path: path,
                                      method: .GET,
                                      params: params,
                                      header: header,
                                      timeOut: timeOut,
                                      decodeConfig: decodeConfig,
                                      printLog: printLog))
    }
    
    func post(path: String,
              params: Any? = nil,
              header: [String : String]? = nil,
              timeOut: TimeInterval? = nil,
              decodeConfig: DecodeConfig? = nil,
              formDatas: [FormData]? = nil,
              printLog: Bool? = nil) async throws -> Response {
        try await send(request: .init(path: path,
                                      method: .POST,
                                      params: params,
                                      header: header,
                                      timeOut: timeOut,
                                      decodeConfig: decodeConfig,
                                      datas: formDatas,
                                      printLog: printLog))
    }
    
    func put(path: String,
             params: Any? = nil,
             header: [String : String]? = nil,
             timeOut: TimeInterval? = nil,
             decodeConfig: DecodeConfig? = nil,
             formDatas: [FormData]? = nil,
             printLog: Bool? = nil) async throws -> Response {
        try await send(request: .init(path: path,
                                      method: .PUT,
                                      params: params,
                                      header: header,
                                      timeOut: timeOut,
                                      decodeConfig: decodeConfig,
                                      datas: formDatas,
                                      printLog: printLog))
    }
    
    func patch(path: String,
               params: Any? = nil,
               header: [String : String]? = nil,
               timeOut: TimeInterval? = nil,
               decodeConfig: DecodeConfig? = nil,
               formDatas: [FormData]? = nil,
               printLog: Bool? = nil) async throws -> Response {
        try await send(request: .init(path: path,
                                      method: .PATCH,
                                      params: params,
                                      header: header,
                                      timeOut: timeOut,
                                      decodeConfig: decodeConfig,
                                      datas: formDatas,
                                      printLog: printLog))
    }
}

public extension Networking {
    
    static func get(path: String,
                    params: Any? = nil,
                    header: [String : String]? = nil,
                    timeOut: TimeInterval? = nil,
                    decodeConfig: DecodeConfig? = nil,
                    printLog: Bool? = nil) async throws -> Response {
        try await shared.get(path: path,
                             params: params,
                             header: header,
                             timeOut: timeOut,
                             decodeConfig: decodeConfig,
                             printLog: printLog)
    }
    
    static func delete(path: String,
                       params: Any? = nil,
                       header: [String : String]? = nil,
                       timeOut: TimeInterval? = nil,
                       decodeConfig: DecodeConfig? = nil,
                       printLog: Bool? = nil) async throws -> Response {
        try await shared.delete(path: path,
                                params: params,
                                header: header,
                                timeOut: timeOut,
                                decodeConfig: decodeConfig,
                                printLog: printLog)
    }
    
    static func post(path: String,
                     params: Any? = nil,
                     header: [String : String]? = nil,
                     timeOut: TimeInterval? = nil,
                     decodeConfig: DecodeConfig? = nil,
                     formDatas: [FormData]? = nil,
                     printLog: Bool? = nil) async throws -> Response {
        try await shared.post(path: path,
                              params: params,
                              header: header,
                              timeOut: timeOut,
                              decodeConfig: decodeConfig,
                              formDatas: formDatas,
                              printLog: printLog)
    }
    
    static func put(path: String,
                    params: Any? = nil,
                    header: [String : String]? = nil,
                    timeOut: TimeInterval? = nil,
                    decodeConfig: DecodeConfig? = nil,
                    formDatas: [FormData]? = nil,
                    printLog: Bool? = nil) async throws -> Response {
        try await shared.put(path: path,
                             params: params,
                             header: header,
                             timeOut: timeOut,
                             decodeConfig: decodeConfig,
                             formDatas: formDatas,
                             printLog: printLog)
    }
    
    static func patch(path: String,
                      params: Any? = nil,
                      header: [String : String]? = nil,
                      timeOut: TimeInterval? = nil,
                      decodeConfig: DecodeConfig? = nil,
                      formDatas: [FormData]? = nil,
                      printLog: Bool? = nil) async throws -> Response {
        try await shared.patch(path: path,
                               params: params,
                               header: header,
                               timeOut: timeOut,
                               decodeConfig: decodeConfig,
                               formDatas: formDatas,
                               printLog: printLog)
    }
}
