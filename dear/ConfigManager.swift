//
// Created by kyungtaek on 2017. 2. 15..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import Foundation

class ConfigManager {

    static let instance = ConfigManager()
    private init() {}

    var pinCode: Int {
        get {
            let userDefaults = UserDefaults.standard
            return userDefaults.integer(forKey: "pinCode")
        }
        set {
            let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: "pinCode")
            userDefaults.synchronize()
        }
    }

}
