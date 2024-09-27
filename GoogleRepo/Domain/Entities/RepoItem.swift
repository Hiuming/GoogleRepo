//
//  RepoItem.swift
//  GoogleRepo
//
//  Created by Huynh Minh Hieu on 27/09/2024.
//

import Foundation
import ObjectMapper

class RepoItem: Mappable {
    
    var description: String?
    var language: String?
    var visibility: String?
    var name: String?
    var forks: Int?
    var stargazersCount: Int?
    
    
    required init?(map: ObjectMapper.Map) {
        
    }
    
    func mapping(map: ObjectMapper.Map) {
        description <- map["description"]
        language <- map["language"]
        visibility <- map["visibility"]
        name <- map["name"]
        forks <- map["forks"]
        stargazersCount <- map["stargazers_count"]
    }
    
    
}
