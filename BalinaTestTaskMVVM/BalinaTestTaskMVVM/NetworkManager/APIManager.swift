//
//  APIManager.swift
//  BalinaTestTaskMVVM
//
//  Created by Vlad Kulakovsky  on 18.04.23.
//

import Foundation

enum APIManager: RequestConstructor {
    case getData
    case getDataPagination(page: String)
    case postData
    
    var baseURL: String {
        return "https://junior.balinasoft.com"
    }
    
    var path: String {
        switch self {
            case .getData, .getDataPagination:
                return "/api/v2/photo/type"
            case .postData:
                return "/api/v2/photo"
        }
    }
    
    var params: [String : String]? {
        var params = [String: String]()
        switch self {
            case .getDataPagination(page: let page):
                params["page"] = page
            case .postData, .getData:
                return nil
        }
        return params
    }
    
    var method: RequestPathType {
        return .query
    }
    
    var requestType: RequestType {
        switch self {
            case .getDataPagination, .getData:
                return .get
            case .postData:
                return .post
        }
    }
    
    static func createURL(request: APIManager) -> URLComponents {
        var components = URLComponents(string: "\(request.baseURL)\(request.path)\(request.method.requestPathType)")!
        
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
