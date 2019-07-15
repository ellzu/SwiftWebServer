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
    
    private var dispatchRequestQueue:DispatchQueue!
    private var semaphore:DispatchSemaphore!
    
    required init() {
        self.semaphore = DispatchSemaphore(value: 4)
        self.dispatchRequestQueue = DispatchQueue(label: "Server.dispatchRequestQueue");
    }

    func serverDidLaunched() -> Void {
        
        delegate?.serverDidLaunched()
        
    }
    
    func onRequestEvent() -> Void {
        //让所有请求暂存在 dispatchRequestQueue
        self.dispatchRequestQueue.async {
            self.semaphore.wait()
            //使用全局线程并行同时处理有限的请求量
            DispatchQueue.global().async {
                self.delegate?.willHandleRequest()
                //TODO:
                self.delegate?.handleRequest()
                //TODO:
                self.delegate?.didHandleRequest()
                //TODO:
                self.semaphore.signal()
            }
        }
    }
    
    
}

@_silgen_name("SWSServerLoaded_C")
public func SWSServerLoaded() -> Void {
    Server.instance.serverDidLaunched()
}

@_silgen_name("SWSOnRequestEvent_C")
func SWSOnRequestEvent() -> Void {
    Server.instance.onRequestEvent()
}

