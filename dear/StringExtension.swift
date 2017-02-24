//
// Created by kyungtaek on 2017. 2. 25..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit

extension String {

    func attrString(font:UIFont?, color:UIColor? = UIColor.drBK, lineSpacing:CGFloat = 1.08, alignment:NSTextAlignment = .left) -> NSAttributedString? {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment

        var attrString = NSMutableAttributedString(string: self)
        attrString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSFontAttributeName, value:font , range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSMakeRange(0, attrString.length))

        return attrString
    }
}