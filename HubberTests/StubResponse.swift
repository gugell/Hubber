//
//  StubResponse.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/22/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import Foundation

class StubResponse {
    static func fromJSONFile(filePath:String) -> Data {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            fatalError("Invalid data from json file")
        }
        return data
    }
}
