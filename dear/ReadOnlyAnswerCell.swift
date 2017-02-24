//
// Created by kyungtaek on 2017. 2. 23..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit

class ReadOnlyAnswerCell: UITableViewCell {
    
    var label1 = UILabel()
    var imageVIew1 = UIImageView()
    var label2 = UILabel()
    var uiView1 = UIView()
    
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
        
        label1.uni(frame: [55, 0, 265, 0], pad: [])
        label1.textAlignment = .center
        label1.font = UIFont.drNM17Font()
        label1.numberOfLines = 0
        addSubview(label1)
        
        imageVIew1.uni(frame: [55, 0, 265, 200], pad: [])
        addSubview(imageVIew1)
        
        label2.uni(frame: [55, 0, 265, 0], pad: [])
        label2.font = UIFont.drSDMedium12Font()
        label2.textColor = UIColor(hexString: "aaaaaa")
        addSubview(label2)
        
        uiView1.uni(frame: [35, 0, 305, 0], pad: [])
        uiView1.backgroundColor = UIColor(hexString: "e5e5e5")
        uiView1.frame.size.height = 0.5
        addSubview(uiView1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label1.frame.size.height = bounds.height
        label2.frame.origin.y = label1.frame.maxX + uni(height: [6])
        
        uiView1.frame.origin.y = bounds.height - 0.5
    }
    
}
