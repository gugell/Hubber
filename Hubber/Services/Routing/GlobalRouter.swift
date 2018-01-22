//
//  GlobalRouter.swift
//  Hubber
//
//  Created by Ilia Gutu on 1/18/18.
//  Copyright © 2018 Stamax. All rights reserved.
//

import UIKit

class GlobalRouter: NSObject {

    var window: UIWindow!

    required init(window: UIWindow) {
        self.window = window
    }

    var rootVC = UIViewController() {
        didSet {
            self.changeRootVC(to: rootVC)
        }
    }

    private var checkIfUserLogIn: Bool {
        return AuthManager.shared.isUserLogged()
    }

    func inspectAppState() {
        let isLoggedIn = self.checkIfUserLogIn

            self.rootVC = ViewsCoordinator.controller(of:
                 isLoggedIn ?
                .main :
                .authorization )

    }

    func changeRootVC<T: UIViewController>(to: T) {
       // let nc = UINavigationController(rootViewController: to)
        self.window.set(rootViewController: to, withTransition: self.transition())
    }

    private func transition() -> CATransition {
        let transition = CATransition()
        transition.type = kCATruncationMiddle
        transition.duration = 1

        return transition
    }

}

extension UIView {
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
}

extension UIWindow {

    func set(rootViewController newRootViewController: UIViewController, withTransition transition: CATransition? = nil) {

        let previousViewController = rootViewController

        if let transition = transition {
            layer.add(transition, forKey: kCATransition)
        }

        self.rootViewController = newRootViewController

        if UIView.areAnimationsEnabled {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                newRootViewController.setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            newRootViewController.setNeedsStatusBarAppearanceUpdate()
        }

        if let transitionViewClass = NSClassFromString("UITransitionView") {
            for subview in subviews where subview.isKind(of: transitionViewClass) {
                subview.removeFromSuperview()
            }
        }
        if let previousViewController = previousViewController {

            previousViewController.dismiss(animated: false) {

                previousViewController.view.removeFromSuperview()
            }
        }
    }
}
