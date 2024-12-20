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
    
    public var pipelining = Pipelining(resWorkers: [LogWorker(), DecodeWorker()])
    
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
        var request = request
        let urlRequest: URLRequest
        
        do {
            // 先经过流水线，由工人处理下请求，按照数组顺序进行处理
            for worker in pipelining.reqWorkers {
                request = try await worker.process(request, networking: self)
            }
            
            request.manager = self
            urlRequest = try request.createURLRequest(config.baseURL)
            request.urlRequest = urlRequest
        } catch  {
            
            var error = error
            
            // 收到错误，不管是request worker的错误，还是接口的错误
            for worker in pipelining.resWorkers {
                error = try await worker.process(error, request: request, networking: self)
            }
            
            throw error
        }
        
        // 处理Response
        var responseIndex: Int = 0
        
        do {
            
            request.start = Date().timeIntervalSince1970 * 1000.0
            let (data, urlResponse) = try await send(request: urlRequest)
            request.end = Date().timeIntervalSince1970 * 1000.0
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                throw NetworkError.responseNotHttp
            }
            var response = Response(request: request,
                                    body: data,
                                    httpResponse: httpResponse)
            
            // 收到数据，再次经过流水线，由工人处理下返回
            for i in 0..<pipelining.resWorkers.count {
                let worker = pipelining.resWorkers[i]
                responseIndex = i
                response = try await worker.process(response, request: request, networking: self)
            }
            
            return response
        } catch {
            
            var error = error
            
            // 发生错误时，把错误往下发送，上面处理的，就不再给他发送了
            for i in responseIndex..<pipelining.resWorkers.count {
                let worker = pipelining.resWorkers[i]
                error = try await worker.process(error, request: request, networking: self)
            }
            
            throw error
        }
    }
}
