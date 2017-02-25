//
//  SideMenuViewController.swift
//  dear
//
//  Created by kyungtaek on 2017. 2. 14..
//  Copyright © 2017년 sicamp. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    var imageView1 = UIImageView()
    var label1 = UILabel()
    var label2 = UILabel()
    var label3 = UILabel()
    var view1 = UIView()
    var button1 = UIButton(type: .system)
    var button2 = UIButton(type: .system)
    var button3 = UIButton(type: .system)
    
    var isOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        view.uni(frame: [-300, 0, 300, 667], pad: [])
        view.backgroundColor = UIColor.white
        
        imageView1.uni(frame: [105, 60, 90, 90], pad: [])
        imageView1.backgroundColor = UIColor(hexString: "bec3c8")
        imageView1.layer.cornerRadius = imageView1.bounds.width / 2
        imageView1.layer.masksToBounds = true
        view.addSubview(imageView1)
        
        label1.uni(frame: [0, 180, 300, 20], pad: [])
        label1.textAlignment = .center
        label1.font = UIFont.drNM20Font()
        label1.text = "선영"
        view.addSubview(label1)
        
        label2.uni(frame: [0, 220, 300, 15], pad: [])
        label2.textAlignment = .center
        label2.font = UIFont.drNM13Font()
        label2.text = "6일째 작성중"
        view.addSubview(label2)
        
        label3.uni(frame: [0, 240, 300, 15], pad: [])
        label3.textAlignment = .center
        label3.font = UIFont.drNM13Font()
        label3.text = "36개 답변 작성"
        view.addSubview(label3)
        
        view1.uni(frame: [45, 303, 210, 1], pad: [])
        view1.backgroundColor = UIColor.black
        view.addSubview(view1)
        
        button1.uni(frame: [0, 340, 300, 70], pad: [])
        button1.titleLabel!.font = UIFont.drNM24Font()
        button1.setTitle("dear", for: .normal)
        button1.tintColor = UIColor(hexString: "555555")
        button1.addTarget(self, action: #selector(action(button1:)), for: .touchUpInside)
        view.addSubview(button1)
        
        button2.uni(frame: [0, 410, 300, 70], pad: [])
        button2.titleLabel!.font = UIFont.drNM24Font()
        button2.setTitle("도움말", for: .normal)
        button2.tintColor = UIColor(hexString: "555555")
        button2.addTarget(self, action: #selector(action(button2:)), for: .touchUpInside)
        view.addSubview(button2)
        
        button3.uni(frame: [0, 480, 300, 70], pad: [])
        button3.titleLabel!.font = UIFont.drNM24Font()
        button3.setTitle("설정", for: .normal)
        button3.tintColor = UIColor(hexString: "555555")
        button3.addTarget(self, action: #selector(action(button3:)), for: .touchUpInside)
        view.addSubview(button3)
    }
    
    @objc private func action(button1: UIButton) {
        
    }
    
    @objc private func action(button2: UIButton) {
        
    }
    
    @objc private func action(button3: UIButton) {
        
    }
    
}
