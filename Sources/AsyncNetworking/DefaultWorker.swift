//
//  DecodeWorker.swift
//  AsyncNetworking
//
//  Created by shutut on 2024/8/27.
//

import Foundation

struct DecodeWorker: ResponseWorker {
    func process(_ response: Response, request: Request, networking: Networking) async throws -> Response {
        // 解析Model
        if response.succeed, let _ = request.decodeConfig {
            try await response.decodeModel()
        }
        return response
    }
}

struct LogWorker: ResponseWorker {
    func process(_ response: Response, request: Request, networking: Networking) async throws -> Response {
        if let p = request.printLog, p {
            response.log()
        }
        return response
    }
    
    func process(_ error: any Error, request: Request, networking: Networking) async throws -> any Error {
        let message = request.log
        let start = request.start
        if let p = request.printLog, p {
            Task {
                var message = message
                var duration = -1.0
                if let start {
                    duration = Date().timeIntervalSince1970 * 1000.0 - start
                }
                message.append("\n------Error:\(duration)ms\n")
                message.append("\(error)\n")
                message.append("End<<<<<<<<<<")
                print("\(message)")
            }
        }
        return error
    }
}
