//
//  RequestProtocol.swift
//  COpenSSL
//
//  Created by ellzu on 2019/7/13.
//

//import SwiftWebServerFoundation
import PerfectHTTPServer
import PerfectHTTP

@dynamicMemberLookup
public protocol RequestControllerProtocol {
//    subscript(dynamicMember member: String) -> (HTTPRequest,HTTPResponse) ->Void
    static func newInstance() -> RequestControllerProtocol?
    
}

extension RequestControllerProtocol {
    
//    public init(){
//        
//    }
    dynamic subscript(dynamicMember member: String) -> (HTTPRequest,HTTPResponse) -> Void {
        return defaultEx(_:_:)
    }
    dynamic public func defaultEx(_ request: HTTPRequest, _ response: HTTPResponse) {
        response.appendBody(string: "onRequest:RequestControllerProtocol-defaultEx" )
        response.completed()
    }
    
//    public var vx2: (HTTPRequest,HTTPResponse) ->Void {
//        get {
//            return xxx(_:_:)
//        }
//    }
//    public func xxx(_ request: HTTPRequest, _ response: HTTPResponse)  {
//        response.appendBody(string: "onRequest:RequestControllerProtocol - AdminRC-xxx" )
//        response.completed()
//    }
}


