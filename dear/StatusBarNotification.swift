//
// Created by kyungtaek on 2017. 2. 22..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import Foundation
import BPStatusBarAlert

class StatusBarNotification {
    static func showError(_ error:Error) {

        BPStatusBarAlert()
                .message(message: "\(error)")
                .bgColor(color: .red)
                .show()

    }
}