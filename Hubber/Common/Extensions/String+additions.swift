//
//  String+additions.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/18/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import Foundation

 extension String {
    var urlEscaped: String {
        guard let escapedString = self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return self }
        return escapedString
    }
}
