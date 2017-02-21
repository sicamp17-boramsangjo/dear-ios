//
// Created by kyungtaek on 2017. 2. 21..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import AKSideMenu

public extension UIWindow {

    public static func visibleViewController() -> UIViewController? {
        let viewController: UIViewController? = UIWindow.getVisibleViewControllerFrom(UIApplication.shared.keyWindow?.rootViewController)
        return viewController
    }

    private static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let mc = vc as? AKSideMenu {
            return UIWindow.getVisibleViewControllerFrom(mc.contentViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}
