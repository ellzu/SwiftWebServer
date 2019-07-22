//
//  Base.swift
//  SwiftWebServerFoundation
//
//  Created by ellzu on 2019/7/13.
//

import Foundation
import PerfectHTTP
//import SWSExample

var a:Int! = 0
@_silgen_name("swsOnHostRequest_C")
public func swsOnHostRequest(_ requestPointer: UnsafeMutablePointer<HTTPRequest>!, _ responsePointer: UnsafeMutablePointer<HTTPResponse>!) -> Int {
//    let request = requestPointer.pointee
//    let response = responsePointer.pointee
//    let cls:AnyClass? = NSClassFromString("SWSExample.UserRC")
//    let sel = NSSelectorFromString("xxx")
//    let obj:BaseRequestController? = (cls as! RequestControllerProtocol.Type).newInstance() as! BaseRequestController
//    (obj.xxx(_:_:) as! (HTTPRequest,HTTPResponse) ->Void)(request,response)
//    let mirror = Mirror(reflecting: obj)
//    print("\(mirror.children)")
//    for p in mirror.children {
//        print("\(p.label) : \(p.value)")
//        response.appendBody(string: "<div>\(p.label) : \(p.value)</div>")
//    }
//    let fxx:((HTTPRequest,HTTPResponse) -> Void)! = obj!.vx3
//    fxx(request,response)
//    response.completed();
    return 0
}
