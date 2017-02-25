//
//  NotificationManager.swift
//  dear
//
//  Created by kyungtaek on 2017. 2. 19..
//  Copyright © 2017년 sicamp. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let instance = NotificationManager()
    private override init() {}

    func setup() {
        UNUserNotificationCenter.current().delegate = self
    }

    func requestAuthorization() {
        self.setup()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {(granted, _) in
            if granted {
                print("Auth success")
                UIApplication.shared.registerForRemoteNotifications()
            } else {
                print("Auth fail!")
            }
        }
    }

    func getNotificationStatus(completion:@escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (setting: UNNotificationSettings) in
            completion(setting.authorizationStatus)
        }
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        print("alert: willPresentNotification \(notification.request.content.userInfo)")
        Alert.showMessage(message: "copied \(notification.request.content.userInfo)")
#if DEBUG
        UIPasteboard.general.string = "\(notification.request.content.userInfo)"
#endif
    }
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        print("APPDELEGATE: didReceiveResponseWithCompletionHandler \(response.notification.request.content.userInfo)")
        completionHandler()
    }
}
