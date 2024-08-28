//
//  Untitled.swift
//  AsyncNetworking
//
//  Created by shutut on 2024/8/27.
//

import Foundation

@preconcurrency
public protocol Worker: Sendable {
    func process(_ request: Request, networking: Networking) async throws -> Request
    func process(_ response: Response, request: Request, networking: Networking) async throws -> Response
    func process(_ error: Error, request: Request, networking: Networking) async throws -> Error
}

public extension Worker {
    func process(_ request: Request, networking: Networking) async throws -> Request {
        return request
    }
    
    func process(_ response: Response, request: Request, networking: Networking) async throws -> Response {
        return response
    }
    
    func process(_ error: Error, request: Request, networking: Networking) async throws -> Error {
        return error
    }
}

public struct Pipelining: Sendable {
    public var workers: [Worker]
}
