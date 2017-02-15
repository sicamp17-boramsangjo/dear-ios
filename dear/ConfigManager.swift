//
// Created by kyungtaek on 2017. 2. 15..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import Foundation

class ConfigManager {

    static let instance = ConfigManager()
    private init() {}

    var isLogin: Bool {
        get {
            let userDefaults = UserDefaults.standard
            return userDefaults.bool(forKey: "isLogin")
        }
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: "isLogin")
            userDefaults.synchronize()
        }
    }

    var phoneNumber: String? {
        get {
            let userDefaults = UserDefaults.standard
            return userDefaults.string(forKey: "phoneNumber")
        }
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: "phoneNumber")
            userDefaults.set(newValue != nil ? true: false, forKey: "isLogin")
            userDefaults.synchronize()
        }
    }

}
