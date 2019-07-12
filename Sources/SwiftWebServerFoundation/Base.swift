//
//  Base.swift
//  SwiftWebServerFoundation
//
//  Created by ellzu on 2019/7/13.
//

import Foundation
import PerfectHTTP

var a:Int! = 0
@_silgen_name("onRequest_C")
public func onRequest(_ requestPointer: UnsafeMutablePointer<HTTPRequest>!, _ responsePointer: UnsafeMutablePointer<HTTPResponse>!) -> Int {
    let request = requestPointer.pointee
    let response = responsePointer.pointee
    a = a + 1
    if a % 2 == 0 {
        response.appendBody(string: "onRequest:" + String(a))
        response.completed()
        return 0
    }
    return 3
}
