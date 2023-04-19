//
//  RequestConstructor.swift
//  BalinaTestTaskMVVM
//
//  Created by Vlad Kulakovsky  on 18.04.23.
//

import Foundation

enum RequestPathType {
    case query
    case body(bodyPath: String)
    
    var requestPathType: String {
        switch self {
            case .query:
                return "?"
            case .body(bodyPath: let bodyPath):
                return bodyPath
        }
    }
}

enum RequestType {
    case post
    case get
    
    var requestType: String {
        switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
        }
    }
}

protocol RequestConstructor {
    var baseURL: String { get }
    var path: String { get }
    var params: [String: String]? { get }
    var method: RequestPathType { get }
    var requestType: RequestType { get }
    
    static func createURL(request: Self) -> URLComponents
}
