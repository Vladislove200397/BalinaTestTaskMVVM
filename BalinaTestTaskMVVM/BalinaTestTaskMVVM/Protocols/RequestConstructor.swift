//
//  RequestConstructor.swift
//  BalinaTestTaskMVVM
//
//  Created by Vlad Kulakovsky  on 18.04.23.
//

import Foundation

protocol RequestConstructor {
    var baseURL: String { get }
    var path: String { get }
    var params: [String: String]? { get }
    var method: RequestType { get }
    
    static func createURL(request: Self) -> URLComponents
}
