//
//  UserRC.swift
//  COpenSSL
//
//  Created by ellzu on 2019/7/13.
//
import Foundation
import SwiftWebServerFoundation
import PerfectHTTPServer
import PerfectHTTP

@dynamicCallable
open class UserRC: BaseRequestController {
    
    open override subscript(dynamicMember member: String) -> (HTTPRequest,HTTPResponse) ->Void  {
        return defaultURC(_:_:)
    }
    public var testVar: Int! = 9
    public var testS: String! = ""
    
//    public static func newInstance() -> RequestControllerProtocol? {
//        let u:UserRC = UserRC.init()
//        u.testVar = 9;
//        u.testS = "123"
//        return u
//    }
    
    public required init() {
        print("UserRC init")
    }
    public func defaultURC(_ request: HTTPRequest, _ response: HTTPResponse) {
        response.appendBody(string: "onRequest:defaultURC-defaultEx" )
        response.completed()
    }
    public var vx2: (HTTPRequest,HTTPResponse) ->Void {
        get {
            return xxx(_:_:)
        }
    }
    public func xxx(_ request: HTTPRequest, _ response: HTTPResponse)  {
        response.appendBody(string: "onRequest:UserRC-xxx" )
        response.completed()
    }
    
}

extension SwiftWebServerFoundation.BaseRequestController {
    public var vx3: (HTTPRequest,HTTPResponse) ->Void {
        get {
            return xxx3(_:_:)
        }
    }
    public func xxx3(_ request: HTTPRequest, _ response: HTTPResponse)  {
        response.appendBody(string: "onRequest:BaseRequestController - AdminRC-xxx" )
        response.completed()
    }
}
