//
// Created by kyungtaek on 2017. 2. 23..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit

class ReadOnlyAnswerCell: UITableViewCell {
    
    var label1 = UILabel()
    var imageVIew1 = UIImageView()
    var label2 = UILabel()
    var view1 = UIView()
    
    var type = 0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    private func initView() {
        backgroundColor = UIColor(hexString: "ebeef1")
        
        label1.uni(frame: [55, 0, 265, 0], pad: [])
        label1.textAlignment = .center
        label1.font = UIFont.drNM17Font()
        label1.textColor = UIColor(hexString: "55555")
        label1.numberOfLines = 0
        addSubview(label1)
        
        imageVIew1.uni(frame: [55, 0, 265, 200], pad: [])
        addSubview(imageVIew1)
        
        label2.uni(frame: [55, 0, 265, 15], pad: [])
        label2.font = UIFont.drSDMedium12Font()
        label2.textColor = UIColor(hexString: "999999")
        label2.textAlignment = .center
        addSubview(label2)
        
        view1.uni(frame: [45, 0, 330, 1], pad: [])
        view1.backgroundColor = UIColor(hexString: "cccccc")
        addSubview(view1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if type == 0 {
            label1.sizeToFit()
            label1.frame.origin.y = bounds.height / 2 - label1.bounds.height / 2
            label2.frame.origin.y = label1.frame.origin.y + label1.bounds.height + uni(height: [6])
        } else if type == 1 {
            label2.frame.origin.y = imageVIew1.frame.maxX + uni(height: [6])
        } else {
            //video
        }
        view1.frame.origin.y = bounds.height - 1
    }
    
}
