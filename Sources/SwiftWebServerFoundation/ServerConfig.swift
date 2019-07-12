//
//  SWSServerConfig.swift
//  COpenSSL
//
//  Created by ellzu on 2019/7/12.
//

import Foundation

public class ServerConfig: Codable {
    public var port: Int! = 0
    public var welcomeFile: String?
    public var notFoundPage: String?
    public var hostConfigs: [HostConfig]?
    public var hostConfigPaths : [String]?
    
    public func loadHostConfig() {
        if self.hostConfigs == nil {
            self.hostConfigs = []
        }
        for path in self.hostConfigPaths ?? [] {
            let hostConfig: HostConfig? = readHostConfig(path)
            if hostConfig != nil {
                self.hostConfigs!.append(hostConfig!)
            }
        }
    }
    
    public func readHostConfig(_ path: String) -> HostConfig? {
        let decoder : JSONDecoder! = JSONDecoder()
        var hostConfig: HostConfig?
        do {
            let configUrl : URL! = URL(fileURLWithPath: path)
            let data : Data! = try Data(contentsOf: configUrl)
            hostConfig = try decoder.decode(HostConfig.self, from: data)
        } catch {
            print("unable read:" + path)
            hostConfig = nil
        }
        return hostConfig
    }
    
    
    
}
