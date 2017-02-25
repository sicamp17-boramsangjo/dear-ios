//
// Created by kyungtaek on 2017. 2. 20..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit

extension UIColor {
    static func random() -> UIColor {
        let randomRed: CGFloat = CGFloat(drand48())
        let randomGreen: CGFloat = CGFloat(drand48())
        let randomBlue: CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }

    static func rgb256(_ red:Int, _ green:Int, _ blue:Int, _ alpha:CGFloat = 1.0) -> UIColor {
        return UIColor(red: CGFloat(red) / CGFloat(255) , green: CGFloat(green) / CGFloat(255) , blue: CGFloat(blue) / CGFloat(255), alpha: alpha)
    }

}
