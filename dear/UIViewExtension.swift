//
// Created by kyungtaek on 2017. 2. 25..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit

extension UIView {

    func applyCommonShadow() {
        self.backgroundColor = UIColor.white
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.1
        self.layer.shadowColor = UIColor.black.cgColor
    }
}