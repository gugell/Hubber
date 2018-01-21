//
//	Commit.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/18/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import Foundation
import ObjectMapper


public struct Commit : Mappable{
    
    var author : Author?
    var commentCount : Int?
    var committer : Committer?
    var message : String = ""
    var tree : Tree?
    var url : String?
    
    
    public init?(map: Map){}
    public mutating func mapping(map: Map)
    {
        author <- map["author"]
        commentCount <- map["comment_count"]
        committer <- map["committer"]
        message <- map["message"]
        tree <- map["tree"]
        url <- map["url"]
        
    }
    
}
