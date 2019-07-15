//
//  ServerDelegate.swift
//  COpenSSL
//
//  Created by ellzu on 2019/7/15.
//

import Foundation

public protocol ServerDelegate {
    static func delegateInstance() -> ServerDelegate
    func serverDidLaunched() -> Void
}
