// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// 网络错误
public enum NetworkError: Error {
    /// 返回时出现参数错误
    case wrongResponse
    /// 返回时resonse不是http的
    case responseNotHttp
}

public let kNetworkDefaultTimeOut: TimeInterval = 10.0
public let kNetworkDefaultResourceTimeOut: TimeInterval = 60.0

public struct NetworkConfig {
    
    public var willSendRequestHandler: ((Request) throws -> Request)?
    public var didReceiveResponseHandler: ((Response) throws -> Response)?
    
    /// 接口请求超时时间
    public var timeOut = kNetworkDefaultTimeOut
    
    /// 资源超时时间
    public var resourceTimeOut = kNetworkDefaultResourceTimeOut
    
    public var printLog = false
    
    /// 基础url
    public var baseURL = ""
}

/// 网络请求的管理器
public class Networking {
    
    public var config: NetworkConfig
    
    public var session = URLSession.shared
    
    public init(config: NetworkConfig) {
        self.config = config
    }
    
    func send(request: URLRequest) async throws -> (Data, URLResponse) {
#if os(macOS) || os(iOS)
        return try await session.data(for: request)
#else
        return try await withCheckedThrowingContinuation { continuation in
            let task = session.dataTask(with: request) { data, response, error in
                if let data, let response {
                    continuation.resume(returning: (data, response))
                } else if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: NetworkError.wrongResponse)
                }
            }
            task.resume()
        }
#endif
    }
    
    /// 发送请求
    /// - Parameter request: 请求对象
    /// - Returns: 返回请求响应对象
    public func send(request: Request) async throws -> Response {
        let sendRequest: Request
        if let willHandler = config.willSendRequestHandler {
            // 如果有加密，先调用加密
            sendRequest = try willHandler(request)
        } else {
            sendRequest = request
        }
        sendRequest.manager = self
        let urlRequest = try sendRequest.createURLRequest(config.baseURL)
        sendRequest.urlRequest = urlRequest
        do {
            sendRequest.start = Date().timeIntervalSince1970 * 1000.0
            let (data, response) = try await send(request: urlRequest)
            sendRequest.end = Date().timeIntervalSince1970 * 1000.0
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.responseNotHttp
            }
            var res = Response(request: sendRequest,
                               body: data,
                               urlResponse: response)
            
            // 如果配置有解密方法，则优先用解密方法解密一下
            if res.succeed, let didHandler = config.didReceiveResponseHandler {
                res = try didHandler(res)
            }
            
            // 解析Model
            if res.succeed, let _ = sendRequest.decodeConfig {
                try await res.decodeModel()
            }
            
            if let print = sendRequest.printLog, print {
                res.log()
            }
            
            return res
        } catch {
            if let p = sendRequest.printLog, p {
                Task {
                    var message = sendRequest.log
                    var duration = -1.0
                    if let start = sendRequest.start {
                        duration = Date().timeIntervalSince1970 * 1000.0 - start
                    }
                    message.append("\n------Error:\(duration)ms\n")
                    message.append("\(error)\n")
                    message.append("End<<<<<<<<<<")
                    print("\(message)")
                }
            }
            throw error
        }
    }
}
