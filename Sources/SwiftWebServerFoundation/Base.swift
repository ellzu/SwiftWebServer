//
//  Base.swift
//  SwiftWebServerFoundation
//
//  Created by ellzu on 2019/7/13.
//

import Foundation
import PerfectHTTP

var a:Int! = 0
@_silgen_name("swsOnHostRequest_C")
public func swsOnHostRequest(_ requestPointer: UnsafeMutablePointer<HTTPRequest>!, _ responsePointer: UnsafeMutablePointer<HTTPResponse>!) -> Int {
    let request = requestPointer.pointee
    let response = responsePointer.pointee
    let cls:AnyClass? = NSClassFromString("UserRC")
    let obj = (cls as! RequestControllerProtocol.Type).newInstance()
    let mirror = Mirror(reflecting: obj)
    for p in mirror.children {
        print("\(p.label) : \(p.value)")
        response.appendBody(string: "<div>\(p.label) : \(p.value)</div>")
    }
    
    response.completed();
    return 0
}
