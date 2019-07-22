//
//  Route.swift
//  COpenSSL
//
//  Created by ellzu on 2019/7/22.
//

import Foundation



open class Route {
    public typealias Handler = () -> Void
    
    var pathRegular: String!
    var handler: Handler!
    
    public init(_ pathRegular: String!, handler: Handler!) {
        self.pathRegular = pathRegular
        self.handler = handler
    }
    
}
