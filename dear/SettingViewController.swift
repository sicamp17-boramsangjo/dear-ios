//
//  asdsViewController.swift
//  dear
//
//  Created by 김경록 on 2017. 2. 25..
//  Copyright © 2017년 sicamp. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    var view1 = UIView()
    var button1 = UIButton()
    var label1 = UILabel()
    
    var settingView1 = SettingView()
    var settingView2 = SettingView()
    var settingView3 = SettingView()
    
    var settingView4 = SettingView()
    var settingView5 = SettingView()
    
    var settingView6 = SettingView()
    var settingView7 = SettingView()
    var settingView8 = SettingView()
    var settingView9 = SettingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        view.backgroundColor = UIColor(hexString: "f1f2f3")
        
        view1.uni(frame: [0, 0, 375, 64], pad: [])
        view1.backgroundColor = UIColor.white
        view1.layer.shadowRadius = 3
        view1.layer.shadowOpacity = 0.08
        view1.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        view1.layer.shadowColor = UIColor.black.cgColor
        view.addSubview(view1)
        
        button1.uni(frame: [0, 20, 64, 40], pad: [])
        button1.setTitle("닫기", for: .normal)
        button1.titleLabel!.font = UIFont.drSDLight16Font()
        button1.setTitleColor(UIColor(hexString: "555555"), for: .normal)
        button1.addTarget(self, action: #selector(dismiss(_:)), for: .touchUpInside)
        view.addSubview(button1)
        
        label1.uni(frame: [0, 20, 375, 40], pad: [])
        label1.textColor = UIColor(hexString: "555555")
        label1.textAlignment = .center
        label1.font = UIFont.drSDLight16Font()
        label1.text = "설정"
        view.addSubview(label1)
        
        settingView1.uni(frame: [0, 94, 375, 45], pad: [])
        settingView1.isSwitch = true
        settingView1.label1.text = "푸쉬알림허용"
        settingView1.switchButton1.addTarget(self, action: #selector(action(switchButton:)), for: .touchUpInside)
        view.addSubview(settingView1)
        
        settingView2.uni(frame: [0, 139, 375, 45], pad: [])
        settingView2.label1.text = "질문주기 설정"
        settingView2.label2.text = "월, 금  >"
        settingView2.button1.tag = 2
        settingView2.button1.addTarget(self, action: #selector(action(button:)), for: .touchUpInside)
        view.addSubview(settingView2)
        
        settingView3.uni(frame: [0, 184, 375, 45], pad: [])
        settingView3.label1.text = "마지막 접속일 설정"
        settingView3.label2.text = "1년  >"
        settingView3.isLast = true
        settingView3.button1.tag = 3
        settingView3.button1.addTarget(self, action: #selector(action(button:)), for: .touchUpInside)
        view.addSubview(settingView3)
        
        settingView4.uni(frame: [0, 255, 375, 45], pad: [])
        settingView4.label1.text = "나의 dear 지정"
        settingView4.label2.text = "엄마, 아빠  >"
        settingView4.button1.tag = 4
        settingView4.button1.addTarget(self, action: #selector(action(button:)), for: .touchUpInside)
        view.addSubview(settingView4)
        
        settingView5.uni(frame: [0, 300, 375, 45], pad: [])
        settingView5.label1.text = "dear에게 열쇠 미리주기"
        settingView5.label2.text = ">"
        settingView5.isLast = true
        settingView5.button1.tag = 5
        settingView5.button1.addTarget(self, action: #selector(action(button:)), for: .touchUpInside)
        view.addSubview(settingView5)
        
        settingView6.uni(frame: [0, 372, 375, 45], pad: [])
        settingView6.label1.text = "프로필 설정"
        settingView6.label2.text = ">"
        settingView6.button1.tag = 6
        settingView6.button1.addTarget(self, action: #selector(action(button:)), for: .touchUpInside)
        view.addSubview(settingView6)
        
        settingView7.uni(frame: [0, 417, 375, 45], pad: [])
        settingView7.label1.text = "비밀번호 설정"
        settingView7.label2.text = ">"
        settingView7.button1.tag = 7
        settingView7.button1.addTarget(self, action: #selector(action(button:)), for: .touchUpInside)
        view.addSubview(settingView7)
        
        settingView8.uni(frame: [0, 462, 375, 45], pad: [])
        settingView8.label1.text = "로그아웃"
        settingView8.label2.text = ">"
        settingView8.button1.tag = 8
        settingView8.button1.addTarget(self, action: #selector(action(button:)), for: .touchUpInside)
        view.addSubview(settingView8)
        
        settingView9.uni(frame: [0, 507, 375, 45], pad: [])
        settingView9.label1.text = "탈퇴하기"
        settingView9.label2.text = ">"
        settingView9.isLast = true
        settingView9.button1.tag = 9
        settingView9.button1.addTarget(self, action: #selector(action(button:)), for: .touchUpInside)
        view.addSubview(settingView9)
    }
    
    @objc private func dismiss(_ button: UIButton) {
        //dismiss(animated: true, completion: nil)
        print("dismiss")
    }
    
    @objc private func action(button: UIButton) {
        print(button.tag)
    }
    
    @objc private func action(switchButton: UISwitch) {
        print(switchButton.isOn)
    }
    
}

class SettingView: UIView {
    
    var label1 = UILabel()
    var switchButton1 = UISwitch()
    var label2 = UILabel()
    var button1 = UIButton()
    var view1 = UIView()
    
    var isSwitch = false
    var isLast = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    private func initView() {
        backgroundColor = UIColor.white
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 0, height: 0.5)
        layer.shadowColor = UIColor.black.cgColor
        
        label1.uni(frame: [15, 0, 300, 44], pad: [])
        label1.textColor = UIColor(hexString: "333333")
        label1.font = UIFont.drSDLight16Font()
        addSubview(label1)
        
        switchButton1.uni(frame: [309, 5.5, 51, 31], pad: [])
        switchButton1.onTintColor = UIColor(hexString: "f57337")
        addSubview(switchButton1)
        
        label2.uni(frame: [187, 0, 173, 44], pad: [])
        label2.textColor = UIColor(hexString: "8c96a5")
        label2.textAlignment = .right
        label2.font = UIFont.drSDLight16Font()
        addSubview(label2)
        
        button1.uni(frame: [0, 0, 375, 44], pad: [])
        addSubview(button1)
        
        view1.uni(frame: [15, 44, 360, 1], pad: [])
        view1.backgroundColor = UIColor(hexString: "dddddd")
        addSubview(view1)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switchButton1.isHidden = isSwitch ? false : true
        label2.isHidden = isSwitch ? true : false
        button1.isHidden = isSwitch ? true : false
        layer.shadowOpacity = isLast ? 0.08 : 0
        view1.isHidden = isLast ? true : false
    }
    
}
