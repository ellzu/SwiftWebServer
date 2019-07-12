//
//  SWSServerConfig.swift
//  COpenSSL
//
//  Created by ellzu on 2019/7/12.
//

public class ServerConfig: Codable {
    
    public class Host: Codable {
        public var domain: String! = ""
        public var path: String!
        public var welcomeFile: String?
        public var notFoundPage: String?
    }
    
    public var port: Int! = 0
    public var welcomeFile: String?
    public var notFoundPage: String?
    public var hosts: [Host]?
    
}
