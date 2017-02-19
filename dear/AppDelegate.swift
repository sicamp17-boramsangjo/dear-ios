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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

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

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("did receive remote notification \(userInfo)")
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("did receive remote notification completionHandler \(userInfo)")
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        var token: String = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
#if DEBUG
        UIPasteboard.general.string = token
        Alert.showAlert(message: "copied device token: \(token)")
        print("device token: \(token)")
#endif
    }

    func setupWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.black

        if DataSource.instance.isLogin() {
            window.rootViewController = self.setupContentViewGroup()
        } else {
            window.rootViewController = self.setupIntroViewGroup()
        }

        window.makeKeyAndVisible()

        self.window = window
    }

    func setupContentViewGroup() -> UIViewController {
        let contentViewController = ContentBaseViewController(nibName: nil, bundle: nil)
        let navigationController = UINavigationController(rootViewController: contentViewController)

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

        let signInViewController = SignInViewController { [unowned self] user, _ in
            guard user != nil else { return }
            self.window?.rootViewController = self.setupContentViewGroup()
        }
        let navigationController = UINavigationController(rootViewController:signInViewController)

        return navigationController
    }

    func setupPasswordViewGroup() -> UIViewController? {
        return nil
    }

    func setupApplication() {
        Fabric.with([Digits.self, Crashlytics.self])
        NotificationManager.instance.requestAuthorization()

    }

}
