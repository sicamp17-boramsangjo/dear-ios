//
//  AppDelegate.swift
//  dear
//
//  Created by kyungtaek on 2017. 2. 10..
//  Copyright © 2017년 sicamp. All rights reserved.
//

import UIKit
import Fabric
import DigitsKit
import Crashlytics
import AKSideMenu
import ChameleonFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        setupWindow()
        setupApplication()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    func setupWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.black

        if ConfigManager.instance.isLogin {
            window.rootViewController = self.setupContentViewGroup()
        } else {
            window.rootViewController = self.setupIntroViewGroup()
        }

        window.makeKeyAndVisible()

        self.window = window
    }

    func setupContentViewGroup() -> UIViewController {
        let messageListViewController = MessageListViewController(nibName: nil, bundle: nil)
        let navigationController = UINavigationController(rootViewController:messageListViewController)
        navigationController.setThemeUsingPrimaryColor(UIColor.flatWhite(), with: .contrast)

        let leftMenuViewController = SideMenuViewController(nibName: nil, bundle: nil)
        let sideMenuViewController = AKSideMenu(contentViewController: navigationController,
                leftMenuViewController:leftMenuViewController,
                rightMenuViewController:nil)
        sideMenuViewController.scaleContentView = false
        sideMenuViewController.scaleMenuView = false

        return sideMenuViewController
    }

    func setupIntroViewGroup() -> UIViewController {
        return IntroViewController(completion: { [unowned self] in
            self.window?.rootViewController = self.setupSignInViewGroup()
        })
    }

    func setupSignInViewGroup() -> UIViewController? {
        return SignInViewController { [unowned self] phoneNumber, _ in
            guard let loginedPhoneNumber = phoneNumber else { return }
            ConfigManager.instance.phoneNumber = loginedPhoneNumber
            self.window?.rootViewController = self.setupContentViewGroup()
        }
    }

    func setupPasswordViewGroup() -> UIViewController? {
        return nil
    }

    func setupApplication() {
        Fabric.with([Digits.self, Crashlytics.self])
    }

}
