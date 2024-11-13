//
//  Untitled.swift
//  AsyncNetworking
//
//  Created by shutut on 2024/8/27.
//

import Foundation

@preconcurrency
public protocol RequestWorker: Sendable {
    func process(_ request: Request, networking: Networking) async throws -> Request
}

@preconcurrency
public protocol ResponseWorker: Sendable {
    func process(_ response: Response, request: Request, networking: Networking) async throws -> Response
    func process(_ error: Error, request: Request, networking: Networking) async throws -> Error
}

public extension RequestWorker {
    func process(_ request: Request, networking: Networking) async throws -> Request {
        return request
    }
}

public extension ResponseWorker {
    func process(_ response: Response, request: Request, networking: Networking) async throws -> Response {
        return response
    }
    
    func process(_ error: Error, request: Request, networking: Networking) async throws -> Error {
        return error
    }
}

public struct Pipelining: Sendable {
    
    public var reqWorkers: [RequestWorker]
    public var resWorkers: [ResponseWorker]
    
    public init(reqWorkers: [RequestWorker] = [], resWorkers: [ResponseWorker] = []) {
        self.reqWorkers = reqWorkers
        self.resWorkers = resWorkers
    }
}
