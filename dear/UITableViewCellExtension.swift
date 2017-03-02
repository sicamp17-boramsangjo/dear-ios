//
// Created by kyungtaek on 2017. 2. 20..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static func identifier() -> String {
        return NSStringFromClass(self)
    }
}