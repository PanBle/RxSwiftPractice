//
//  Repository.swift
//  RxSwiftPractice
//
//  Created by KM_TM on 23/09/2019.
//  Copyright © 2019 KM_TM. All rights reserved.
//

import Foundation
import ObjectMapper

class SRepository: Mappable {
    var identifier : Int!
    var language : String!
    var url : String!
    var name: String!
    
    required init?(map: Map) {  }
    
    func mapping(map: Map) {
        identifier <- map["id"]
        language <- map["lauguage"]
        url <- map["url"]
        name <- map["name"]
    }
}
