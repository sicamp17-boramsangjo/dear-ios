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
    var apiManager: APIManager = APIManager()
    var deviceToken: String?

    weak var sideMenu: AKSideMenu?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        self.setupWindowWithLoginStatus()
        self.setupApplication()

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

        self.deviceToken = token

        self.updateDeviceToken()
    }

    func setupWindowWithLoginStatus() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = UIColor.black

        defer {
            window.makeKeyAndVisible()
            self.window = window
        }

        guard let user = DataSource.instance.fetchLoginUser() else {
            window.rootViewController = self.setupIntroViewGroup()
            return
        }

        window.rootViewController = self.setupContentViewGroup()

        self.apiManager.login(phoneNumber: user.phoneNumber, password: user.password) {[unowned self] loginResult, error in
            if error != nil {
                window.rootViewController = self.setupIntroViewGroup()
            }

            self.updateDeviceToken()
        }
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

        self.sideMenu = sideMenuViewController

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

    private func updateDeviceToken() {

        guard APIManager.sessionToken != nil, let deviceToken = self.deviceToken else {
            print("not prepared")
            return
        }

        self.apiManager.updateUserInfo(deviceToken: deviceToken) { _, _ in }
    }

}
