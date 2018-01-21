//
//	PullRequest.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/18/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import Foundation
import ObjectMapper

public struct PullRequest : Mappable{
    
    var diffUrl : String?
    var htmlUrl : String?
    var patchUrl : String?
    var url : String?
    
    
    public init?(map: Map){}
    public mutating func mapping(map: Map)
    {
        diffUrl <- map["diff_url"]
        htmlUrl <- map["html_url"]
        patchUrl <- map["patch_url"]
        url <- map["url"]
        
    }
    
}
