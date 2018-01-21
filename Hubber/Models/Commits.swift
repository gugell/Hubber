//
//	Commits.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/18/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import Foundation
import ObjectMapper


public struct Commits :  Mappable{
    
    var author : Author?
    var commentsUrl : String?
    var commit : Commit?
    var committer : Committer?
    var htmlUrl : String?
    var parents : [Parent]?
    var sha : String?
    var url : String?
    
    
    public init?(map: Map){}
    public mutating func mapping(map: Map)
    {
        author <- map["author"]
        commentsUrl <- map["comments_url"]
        commit <- map["commit"]
        committer <- map["committer"]
        htmlUrl <- map["html_url"]
        parents <- map["parents"]
        sha <- map["sha"]
        url <- map["url"]
        
    }
    
}
