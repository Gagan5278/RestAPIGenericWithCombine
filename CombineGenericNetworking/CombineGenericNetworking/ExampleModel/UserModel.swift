//
//  UserModel.swift
//  CombineGenericNetworking
//
//  Created by Gagan  Vishal on 9/27/20.
//

import Foundation

struct UserModel: Decodable {
    
    let page: Int
    let dataEmployee: [EmplyeeData]
    
    enum CodingKeys: String, CodingKey {
        case empData = "data"
        case page = "page"
    }
    
    init(from decoder: Decoder) throws {
        let encode = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try encode.decode(Int.self, forKey: .page)
        self.dataEmployee = try encode.decode([EmplyeeData].self, forKey: .empData)
    }
}


struct EmplyeeData: Decodable  {
    let id: Int
//    let email: String
   // let first_name: String
}
