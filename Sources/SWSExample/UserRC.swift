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

public class UserRC :NSObject, RequestControllerProtocol{
    
    public static func newInstance() -> RequestControllerProtocol {
        return UserRC.init()
    }
    
    public override init(){
        print("UserRC init")
    }
    func xxx(_ request: HTTPRequest, _ response: HTTPResponse)  {
        response.appendBody(string: "onRequest:UserRC-xxx" )
        response.completed()
    }
}

public var rc:UserRC = UserRC()
//rc.xxx()
