//
// Created by kyungtaek on 2017. 2. 23..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit

class ReadOnlyDeceasedProfileHeaderView: UIView {
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    private func initView() {
        uni(frame: [0, 0, 375, 328], pad: [])
        backgroundColor = UIColor.white
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.black.cgColor
    }
    
}
