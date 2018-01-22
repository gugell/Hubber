//
//  ViewsCoordinator.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/18/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import UIKit

class ViewsCoordinator: NSObject {

    enum ControllerType: String {
        case authorization = "login"
        case search = "search"
        case profile = "profile"
        case reposList = "repos"
        case main = "main"
    }

    static func getController(of Type: ControllerType) -> UIViewController {
        let story = UIStoryboard(name: Type.rawValue, bundle: nil)
        return story.instantiateInitialViewController() ?? UIViewController()
    }

    static func controller(of Type: ControllerType) -> UIViewController {
        var controller: UIViewController
        switch Type {
        case .authorization:
            controller = UINavigationController(rootViewController: LoginViewController())
        case .reposList:
            let segmentedViewController = SegmentedViewController()
            return segmentedViewController
        case .profile:
            let profileController = ProfileViewController()
            return profileController
        case .search:
            let searchController = SearchReposViewController()
            return searchController
        case .main:
            let tabBarController = UITabBarController()
            let searchReposViewController = SearchReposViewController()
            let searchUsersViewController = SearchUsersViewController()
            let segmentedViewController = SegmentedViewController()
            let profileViewController = ProfileViewController()

            let trendingTabbaritem = UITabBarItem()
            trendingTabbaritem.icon(from: .Ionicon, code: "arrow-graph-up-right", imageSize: CGSize.init(width: 25, height: 25), ofSize: 25)
            trendingTabbaritem.title = NSLocalizedString("List", comment: "")

            let searchTabbaritem = UITabBarItem()
            searchTabbaritem.icon(from: .Ionicon, code: "ios-search-strong", imageSize: CGSize.init(width: 25, height: 25), ofSize: 25)
            searchTabbaritem.title = NSLocalizedString("Repositories", comment: "")

            let searchUsersTabbaritem = UITabBarItem()
            searchUsersTabbaritem.icon(from: .Ionicon, code: "ios-search-strong", imageSize: CGSize.init(width: 25, height: 25), ofSize: 25)
            searchUsersTabbaritem.title = NSLocalizedString("Users", comment: "")

            let profileTabbaritem = UITabBarItem()
            profileTabbaritem.icon(from: .Ionicon, code: "person", imageSize: CGSize.init(width: 25, height: 25), ofSize: 25)
            profileTabbaritem.title = NSLocalizedString("Profile", comment: "")

            segmentedViewController.tabBarItem = trendingTabbaritem
            searchReposViewController.tabBarItem = searchTabbaritem
            searchUsersViewController.tabBarItem = searchUsersTabbaritem
            profileViewController.tabBarItem = profileTabbaritem
            //
            tabBarController.viewControllers = [
                UINavigationController(rootViewController: segmentedViewController),
                UINavigationController(rootViewController: searchReposViewController),
                UINavigationController(rootViewController: searchUsersViewController),
                UINavigationController(rootViewController: profileViewController)
            ]
            return tabBarController
        }
        return controller
    }

    static var storyboard: ((ControllerType) -> (UIStoryboard)) = { state in
        return UIStoryboard(name: state.rawValue, bundle: nil)
    }

}
