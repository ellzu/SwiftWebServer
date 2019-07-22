//
//  ServerContext.swift
//  SwiftWebServerFoundation
//
//  Created by ellzu on 2019/7/16.
//


open class ServerContext {
    
    internal var _request: HTTPRequest!
    public var request: HTTPRequest! {
        get {
            return _request;
        }
    }
    internal var _response: HTTPResponse!
    public var response: HTTPResponse! {
        get {
            return _response;
        }
    }
    
}
