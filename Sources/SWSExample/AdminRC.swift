//
//  AdminRC.swift
//  COpenSSL
//
//  Created by ellzu on 2019/7/14.
//

import Foundation
import SwiftWebServerFoundation
import PerfectHTTPServer
import PerfectHTTP

open class AdminRC: RequestControllerProtocol {
    dynamic subscript(dynamicMember member: String) -> (HTTPRequest,HTTPResponse) ->Void  {
        return defaultEX(_:_:)
    }
    
    public static func newInstance() -> RequestControllerProtocol? {
        return self.init()
    }
    public required init() {
        print("AdminRC init")
    }
    public func defaultEX(_ request: HTTPRequest, _ response: HTTPResponse) {
        response.appendBody(string: "onRequest:AdminRC-defaultEx" )
        response.completed()
    }
    public var vx2: (HTTPRequest,HTTPResponse) ->Void {
        get {
            return xxx(_:_:)
        }
    }
    public func xxx(_ request: HTTPRequest, _ response: HTTPResponse)  {
        response.appendBody(string: "onRequest:AdminRC-xxx" )
        response.completed()
    }
}

extension RequestControllerProtocol {
    public var vx3: (HTTPRequest,HTTPResponse) ->Void {
        get {
            return xxx3(_:_:)
        }
    }
    public func xxx3(_ request: HTTPRequest, _ response: HTTPResponse)  {
        response.appendBody(string: "onRequest:RequestControllerProtocol - AdminRC-xxx" )
        response.completed()
    }
}
