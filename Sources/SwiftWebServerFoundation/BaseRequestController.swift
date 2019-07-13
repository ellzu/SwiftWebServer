//
//  BaseRequestController.swift
//  COpenSSL
//
//  Created by ellzu on 2019/7/14.
//

import Foundation
import PerfectHTTPServer
import PerfectHTTP


//@dynamicCallable
open class BaseRequestController: RequestControllerProtocol {
    
    public required init() {
        
    }
    
    public static func newInstance() -> RequestControllerProtocol? {
        return self.init()
    }
    
    public func dynamicallyCall(withKeywordArguments pairs: KeyValuePairs<String,Any>) -> Void {
        
    }
    
    public func dynamicallyCall(withArguments rr: [Any]) -> Void {
        let request:HTTPRequest? = rr[0] as? HTTPRequest
        let response:HTTPResponse? = rr[1] as? HTTPResponse
        if rr.count != 2 || request == nil || response == nil {
            return
        }
        response?.appendBody(string: "onRequest:RequestControllerProtocol-dynamicallyCall")
        response?.completed()
    }
    open subscript(dynamicMember member: String) -> (HTTPRequest,HTTPResponse) -> Void {
        return defaultEx(_:_:)
    }
    public func defaultEx(_ request: HTTPRequest, _ response: HTTPResponse) {
        response.appendBody(string: "onRequest:RequestControllerProtocol-defaultEx" )
        response.completed()
    }
    
    public var vx1: (HTTPRequest,HTTPResponse) -> Void {
        get {
//            func a(_ request: HTTPRequest, _ response: HTTPResponse) -> Void {
//                response.appendBody(string: "onRequest:BaseRequestController-xxx1" )
//                response.completed()
//            }
//            return a
            return xxx1(_:_:)
        }
    }
    
    public func xxx1(_ request: HTTPRequest, _ response: HTTPResponse)  {
        response.appendBody(string: "onRequest:BaseRequestController-xxx1" )
        response.completed()
    }
    
}
