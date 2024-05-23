//
//  File.swift
//  
//
//  Created by shutut on 2024/5/23.
//

import Foundation

public extension NetworkManager {
    
    /// 默认的实例
    static let shared = NetworkManager(config: NetworkConfig())
    
    static func send(_ req: Request) async throws -> Response {
        try await shared.send(req)
    }
    
    static func get(_ path: String,
params: [String: Any]? = nil,
header: [String: String]? = nil,
    ) async throws -> Response {
        try await send(.init(path: path,
                             method: .GET,
                             params: <#T##Any?#>,
                             header: <#T##[String : String]?#>,
                             timeOut: <#T##TimeInterval?#>,
                             printLog: <#T##Bool?#>))
    }
}

public extension NetworkManager {
    
    func get(_ path: String,
params: [String: Any]? = nil,
header: [String: String]? = nil,
    ) async throws -> Response {
        try await send(.init(path: path,
                             method: .GET,
                             params: <#T##Any?#>,
                             header: <#T##[String : String]?#>,
                             timeOut: <#T##TimeInterval?#>,
                             printLog: <#T##Bool?#>))
    }
}
