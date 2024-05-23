// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct NetworkConfig {
    public var timeOut = 10
    public var baseURL: String = ""
    public var printLog: Bool = false
}

/// 网络请求的管理器
public struct NetworkManager {
    
    public var config: NetworkConfig
    
    public init(config: NetworkConfig) {
        self.config = config
    }
    
    public func send(_ req: Request) async throws -> Response {
        let urlReq = try await 
    }
}
