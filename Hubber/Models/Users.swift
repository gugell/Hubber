//
//  Users.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/20/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import Foundation
import ObjectMapper


public struct Users :Mappable{
    
    var incompleteResults : Bool?
    var items : [User]?
    var totalCount : Int?
    
    public init?(map: Map){}
    
    mutating public func mapping(map: Map)
    {
        incompleteResults <- map["incomplete_results"]
        items <- map["items"]
        totalCount <- map["total_count"]
    }
    
}
