//
//  File.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/18/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import Foundation
import ObjectMapper

public struct Plan: Mappable {

    var collaborators: Int?
    var name: String?
    var privateRepos: Int?
    var space: Int?

    public init?(map: Map) {}
    public mutating func mapping(map: Map) {
        collaborators <- map["collaborators"]
        name <- map["name"]
        privateRepos <- map["private_repos"]
        space <- map["space"]

    }
}
