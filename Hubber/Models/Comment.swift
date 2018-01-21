//
//	Comment.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/18/18.
//  Copyright © 2018 Stamax. All rights reserved.
//


import Foundation
import ObjectMapper


public struct Comment : Mappable{
    
    var href : String?
    
    
    public init?(map: Map){}
    public mutating func mapping(map: Map)
    {
        href <- map["href"]
        
    }
}
