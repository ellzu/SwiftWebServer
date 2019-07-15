//
//  Server.swift
//  COpenSSL
//
//  Created by ellzu on 2019/7/15.
//

import Foundation

public class Server {
    
    var delegate:ServerDelegate?
    
    static private var _instance: Server = Server()
    static public var instance: Server! {
        get {
            return _instance
        }
    }
    
    required init() {
        
    }
    
    func serverDidLaunched() -> Void {
        
        delegate?.serverDidLaunched()
        
    }
    
    
    
}

@_silgen_name("SWSServerLoaded_C")
public func SWSServerLoaded() -> Void {
    Server.instance.serverDidLaunched()
}

func SWSOnRequest() -> Void {
    
}

