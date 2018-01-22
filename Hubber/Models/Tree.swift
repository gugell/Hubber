//
//	Tree.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/18/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import Foundation
import ObjectMapper

public struct Tree: Mappable {

    var sha: String?
    var url: String?

    public init?(map: Map) {}
    public mutating func mapping(map: Map) {
        sha <- map["sha"]
        url <- map["url"]

    }

}
