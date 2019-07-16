//
//  Server.swift
//  COpenSSL
//
//  Created by ellzu on 2019/7/15.
//

import Foundation

public class HTTPServer {
    
    var delegate:ServerDelegate?
    
    static private var _instance: HTTPServer = HTTPServer()
    static public var instance: HTTPServer! {
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
    
    private var _contextsSemaphore:DispatchSemaphore! = DispatchSemaphore(value: 1)
    private var _contexts:[Thread:ServerContext]! = [:]
    public var currentContext:ServerContext? {
        get{
            _contextsSemaphore.wait()
            let context:ServerContext? = _contexts[Thread.current]
            _contextsSemaphore.signal()
            return context
        }
    }
    

    func serverDidLaunched() -> Void {
        
        delegate?.serverDidLaunched()
        
    }
    
    func onRequestEvent(_ request: HTTPRequest, _ response: HTTPResponse) -> Void {
        //让所有请求暂存在 dispatchRequestQueue
        self.dispatchRequestQueue.async {
            self.semaphore.wait()
            func finishHandle() -> Void {
                self.semaphore.signal()
            }
            //使用全局线程并行同时处理有限的请求量
            DispatchQueue.global().async {
                
                let context:ServerContext! = ServerContext()
                context._request = request
                context._response = response
                self._contextsSemaphore.wait()
                self._contexts[Thread.current] = context
                self._contextsSemaphore.signal()
                
                
                self.delegate?.willHandleRequest()
                //TODO:
                self.delegate?.handleRequest()
                //TODO:
                self.delegate?.didHandleRequest()
                //TODO:
                finishHandle()
                
                self._contextsSemaphore.wait()
                self._contexts.removeValue(forKey: Thread.current)
                self._contextsSemaphore.signal()
            }
        }
    }
    
    
}

@_silgen_name("SWSServerLoaded_C")
public func SWSServerLoaded() -> Void {
    HTTPServer.instance.serverDidLaunched()
}

@_silgen_name("SWSOnRequestEvent_C")
public func SWSOnRequestEvent(_ request: HTTPRequest, _ response: HTTPResponse) -> Void {
    HTTPServer.instance.onRequestEvent(request, response)
}

