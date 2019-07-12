//
//  Server.swift
//  COpenSSL
//
//  Created by ellzu on 2019/7/12.
//
import SwiftWebServerFoundation
import Foundation
import PerfectHTTPServer
import PerfectHTTP

@_silgen_name("daynmicCall") func DaynmicCall(path: UnsafePointer<Int8>!, request: UnsafeMutablePointer<HTTPRequest>!, response: UnsafeMutablePointer<HTTPResponse>!) -> Void

class Server {
    var config : ServerConfig!
    
    public init (_ config : ServerConfig) {
        self.config = config
    }
    public init (_ filePath: String) throws {
        let configUrl : URL! = URL(fileURLWithPath: filePath)
        let decoder : JSONDecoder! = JSONDecoder()
        let data : Data! = try Data(contentsOf: configUrl)
        let config : ServerConfig! = try decoder.decode(ServerConfig.self, from: data)
        self.config = config
    }
    
    func staticFileHandler(_ host: ServerConfig.Host, _ request: HTTPRequest, _ response: HTTPResponse) {
        let staticFileHandler: StaticFileHandler! = StaticFileHandler(documentRoot: host.path, allowResponseFilters: true)
        if request.path.endsWithFilePathSeparator {
            request.path = request.path + (host.welcomeFile ?? config.welcomeFile ?? "")
        }
        if FileManager.default.fileExists(atPath:(host.path + request.path)) {
            staticFileHandler.handleRequest(request: request, response: response)
        } else {
            pageNotFoundHandler(host, request, response)
        }
    }
    
    
    func hostRequestHandler(_ host: ServerConfig.Host, _ request: HTTPRequest, _ response: HTTPResponse) {
        //TODO: dynamic page forward
        
        //        let imagePath: String = host.path + "/libWSPExample.dylib"
        let imagePath: String = host.path + "/WSPExample.framework/WSPExample"
        
        //C call
        let requestPoint = UnsafeMutablePointer<HTTPRequest>.allocate(capacity: 1)
        requestPoint.pointee = request
        let responsePoint = UnsafeMutablePointer<HTTPResponse>.allocate(capacity: 1)
        responsePoint.pointee = response
        DaynmicCall(path:imagePath.cString(using: .utf8), request: requestPoint, response: responsePoint)
        
        //        let handler: UnsafeMutableRawPointer! = dlopen(imagePath.cString(using: .utf8), RTLD_NOW)
        //        let sym: UnsafeMutableRawPointer! = dlsym(handler, "WSPExample_requestHandler_C".cString(using: .utf8))
        //        if sym != nil {
        //            typealias ECC = @convention(c) (Any, Any)->(Void)
        //            let xxx: ECC = unsafeBitCast(sym, to: ECC.self)
        //            xxx(requestPoint, responsePoint)
        //        } else {
        //            staticFileHandler(host, request, response);
        //        }
        //        dlclose(handler)
        
    }
    func pageNotFoundHandler(_ host: ServerConfig.Host, _ request: HTTPRequest, _ response: HTTPResponse) {
        let notFoundPagePath = host.path + "/" + (host.notFoundPage ?? config.notFoundPage ?? "404.html")
        do {
            let fileUrl: URL! = URL(fileURLWithPath: notFoundPagePath, isDirectory: false)
            let body : String = try String(contentsOf: fileUrl)
            response.appendBody(string: body);
        } catch {
            response.appendBody(string: "<html><title>404</title><body>404</html>")
        }
        response.status = .notFound
        response.completed()
    }
    
    func domainNotFoundHandler(_ request: HTTPRequest, _ response: HTTPResponse) {
        response.appendBody(string: "<html><title>domain error</title><body>domain error</body></html>")
        response.status = .badRequest
        response.completed();
    }
    
    func requestHandler(_ request: HTTPRequest, _ response: HTTPResponse) {
        let domain: String! = requestDomain(request)
        var success: Bool! = false
        for host in config.hosts ?? [] {
            if domain != host.domain /*domain.compare(host.domain) != ComparisonResult.orderedSame*/ {
                continue
            }
            success = true
            hostRequestHandler(host,request, response)
            break
        }
        if !success {
            domainNotFoundHandler(request, response)
        }
    }
    
    func requestDomain(_ request: HTTPRequest) -> String! {
        let host: String = request.header(HTTPRequestHeader.Name.host) ?? ""
        let portIndex : String.Index! = host.lastIndex(of: ":") ?? host.endIndex
        let domain : String! = String(host[host.startIndex ..< portIndex])
        return domain
    }
    
    public func run() throws {
        if config.port == 0 || config.hosts!.count == 0 {
            throw SWSError("WebServer", -1, message: "config error")
        }
        
        var routes = Routes()
        routes.add(uri: "/**", handler: self.requestHandler)
        
        try HTTPServer.launch(name: "localhost",
                              port: self.config.port,
                              routes: routes,
                              responseFilters: [
                                (PerfectHTTPServer.HTTPFilter.contentCompression(data: [:]), HTTPFilterPriority.high)])
    }
}
