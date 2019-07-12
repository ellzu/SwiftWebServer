//
//  HostConfig.swift
//  SwiftWebServerFoundation
//
//  Created by ellzu on 2019/7/13.
//

import Foundation

public class HostConfig: Codable {
    public var domain: String! = ""
    public var docPath: String! = ""
    public var libraryPath: String?
    public var welcomeFile: String?
    public var notFoundPage: String?
}
