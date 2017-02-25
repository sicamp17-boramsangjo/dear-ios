//
// Created by kyungtaek on 2017. 2. 23..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit

class ReadOnlyDeceasedProfileHeaderView: UIView {
    
    var imageView1 = UIImageView()
    var label1 = UILabel()
    var imageView2 = UIImageView()
    var label2 = UILabel()
    
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
        
        imageView1.uni(frame: [140, 26, 50, 34], pad: [])
        imageView1.image = UIImage(named: "dearCalliSmall")
        addSubview(imageView1)
        
        label1.uni(frame: [190, 32, 100, 34], pad: [])
        label1.font = UIFont.drNM20Font()
        label1.textColor = UIColor(hexString:"555555")
        label1.text = "엄마"
        addSubview(label1)
        
        imageView2.uni(frame: [117.5, 81, 140, 140], pad: [])
        imageView2.backgroundColor = UIColor.blue
        addSubview(imageView2)
        
        label2.uni(frame: [55, 241, 265, 80], pad: [])
        label2.numberOfLines = 0
        label2.font = UIFont.drNM13Font()
        label2.textColor = UIColor(hexString:"555555")
        label2.textAlignment = .center
        label2.text = "김모모씨가 미리 준비하신 편지입니다.\n어쩌구 저쩌구 쩌구쩌구 줄줄줄 혹시 길게 쓸 수도 있으니까요."
        addSubview(label2)
    }
    
}
