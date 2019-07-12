//
//  SWSError.swift
//  COpenSSL
//
//  Created by ellzu on 2019/7/12.
//

public class SWSError: Error {
    public var domain : String!
    public var code : Int!
    public var message : String?
    public var subError : SWSError?
    
    public init() {
        
    }
    public init(_ domain: String, _ code : Int, message: String? = nil, subError: SWSError? = nil) {
        self.domain = domain
        self.code = code
        self.message = message
        self.subError = subError
    }
}
