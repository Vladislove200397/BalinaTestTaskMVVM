//
//  RequestType.swift
//  BalinaTestTaskMVVM
//
//  Created by Vlad Kulakovsky  on 18.04.23.
//

import Foundation

enum RequestType {
    case query
    case body(bodyPath: String)
    
    var requestType: String {
        switch self {
            case .query:
                return "?"
            case .body(bodyPath: let bodyPath):
                return bodyPath
        }
    }
}
