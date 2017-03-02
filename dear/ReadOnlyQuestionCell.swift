//
// Created by kyungtaek on 2017. 2. 23..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit

class ReadOnlyQuestionCell: UITableViewCell {
    
    var label1 = UILabel()
    var type = 0
    
    var willItem:WillItem? {
        didSet {
            guard let currentWillItem = willItem else {
                return
            }
            
            label1.text = currentWillItem.text
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    private func initView() {
        backgroundColor = UIColor.white
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowColor = UIColor.black.cgColor
        
        label1.uni(frame: [55, 0, 265, 0], pad: [])
        label1.textColor = UIColor(hexString: "666666")
        label1.textAlignment = .center
        label1.font = UIFont.drNM20Font()
        label1.numberOfLines = 0
        addSubview(label1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label1.frame.size.height = bounds.height
    }
    
}
