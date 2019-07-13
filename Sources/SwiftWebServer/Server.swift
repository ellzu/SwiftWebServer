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

@_silgen_name("swsForwardRequestToHost") func swsForwardRequestToHost(path: UnsafePointer<Int8>!, request: UnsafeMutablePointer<HTTPRequest>!, response: UnsafeMutablePointer<HTTPResponse>!) -> Int

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
        config.loadHostConfig()
        self.config = config
    }
    
    func staticFileHandler(_ host: HostConfig, _ request: HTTPRequest, _ response: HTTPResponse) {
        let staticFileHandler: StaticFileHandler! = StaticFileHandler(documentRoot: host.docPath, allowResponseFilters: true)
        if request.path.endsWithFilePathSeparator {
            request.path = request.path + (host.welcomeFile ?? config.welcomeFile ?? "")
        }
        if FileManager.default.fileExists(atPath:(host.docPath + request.path)) {
            staticFileHandler.handleRequest(request: request, response: response)
        } else {
            pageNotFoundHandler(host, request, response)
        }
    }
    
    
    func hostRequestHandler(_ host: HostConfig, _ request: HTTPRequest, _ response: HTTPResponse) {
        var dynamicCode:Int! = 0
        if host.libraryPath != nil {
            let requestPoint = UnsafeMutablePointer<HTTPRequest>.allocate(capacity: 1)
            requestPoint.pointee = request
            let responsePoint = UnsafeMutablePointer<HTTPResponse>.allocate(capacity: 1)
            responsePoint.pointee = response
            dynamicCode = swsForwardRequestToHost(path:host.libraryPath!.cString(using: .utf8), request: requestPoint, response: responsePoint)
        } else {
             dynamicCode = -1
        }
        
        if dynamicCode != 0 {
            staticFileHandler(host, request, response)
        }
        
    }
    func pageNotFoundHandler(_ host: HostConfig, _ request: HTTPRequest, _ response: HTTPResponse) {
        let notFoundPagePath = host.docPath + "/" + (host.notFoundPage ?? config.notFoundPage ?? "404.html")
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
        for host in config.hostConfigs ?? [] {
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
        if config.port == 0 || config.hostConfigs!.count == 0 {
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
