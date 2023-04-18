//
//  APIManager.swift
//  BalinaTestTaskMVVM
//
//  Created by Vlad Kulakovsky  on 18.04.23.
//

import Foundation

enum APIManager: RequestConstructor {
    
    
    var baseURL: String
    
    var path: String
    
    var params: [String : String]?
    
    var method: RequestType
    
    static func createURL(request: OpenLibraryAPIManager) -> URLComponents {
        var components = URLComponents(string: "\(request.baseURL)\(request.path)\(request.method.requestType)")!
        
        guard let  parameters = request.params else {
            print(components.url!)
            return components
        }

        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        print(components.url!)
        return components
    }
}
