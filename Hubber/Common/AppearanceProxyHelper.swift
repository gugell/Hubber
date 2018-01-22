//
//  AppearanceProxyHelper.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/18/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import UIKit

struct ApperanceProxyHelper {

    static func customizeSearchBar() {
        UIBarButtonItem.appearance(whenContainedInInstancesOf:
            [UISearchBar.self]).tintColor = .white
    }

    static func drawBorderForView(view: UIView, color: UIColor, width: CGFloat) {
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = width
        view.clipsToBounds = true
    }
}

enum NavigationItems {
    case logout(Any, Selector)

    func button() -> UIBarButtonItem {
        switch self {
        case .logout(let target, let selector):
            let image = UIImage(assetIdentifier: .logout)
            return UIBarButtonItem(image: image, style: .plain, target: target, action: selector)
        }

    }
}

extension UIImage {

    enum AssetIdentifier: String {
        // Image Names
        case menu = "unselectedBurgerMenu"
        case logout = "logout-icon"
        case logo = "github-mark"
        case more = "icon-more"
    }

    convenience init?(assetIdentifier: AssetIdentifier) {
        self.init(named: assetIdentifier.rawValue)
    }

}
