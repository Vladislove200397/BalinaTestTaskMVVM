//
//  DataModel.swift
//  BalinaTestTaskMVVM
//
//  Created by Vlad Kulakovsky  on 18.04.23.
//

import Foundation

struct DataModel: Decodable {
    var content: [Content]
    var page: Int
    var totalPages: Int
}

struct Content: Decodable {
    var id: Int
    var name: String
    var image: String?
}
