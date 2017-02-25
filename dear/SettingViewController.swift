//
//  SettingViewController.swift
//  dear
//
//  Created by 김경록 on 2017. 2. 25..
//  Copyright © 2017년 sicamp. All rights reserved.
//

import UIKit
import MessageUI

class SettingViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
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
    
    var messageComposer: MFMessageComposeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {

        self.navigationItem.title = "환경설정"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "closeButton"), style: .plain, target: self, action: #selector(closeButtonTapped(_:)))

        view.backgroundColor = UIColor(hexString: "f1f2f3")
        
        view1.uni(frame: [0, 0, 375, 64], pad: [])
        view1.backgroundColor = UIColor.white
        view1.layer.shadowRadius = 2
        view1.layer.shadowOpacity = 0.08
        view1.layer.shadowOffset = CGSize(width: 0, height: 2)
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
        
        settingView3.uni(frame: [0, 94, 375, 45], pad: [])
        settingView3.label1.text = "마지막 접속일 설정"
        settingView3.label2.text = "1년  >"
        settingView3.isLast = true
        settingView3.button1.tag = 3
        settingView3.button1.addTarget(self, action: #selector(action(button:)), for: .touchUpInside)
        view.addSubview(settingView3)
        
        settingView2.uni(frame: [0, 94, 375, 45], pad: [])
        settingView2.label1.text = "질문주기 설정"
        settingView2.label2.text = "월, 금  >"
        settingView2.button1.tag = 2
        settingView2.button1.addTarget(self, action: #selector(action(button:)), for: .touchUpInside)
        view.addSubview(settingView2)
        
        settingView1.uni(frame: [0, 94, 375, 45], pad: [])
        settingView1.isSwitch = true
        settingView1.isLast = true
        settingView1.label1.text = "푸쉬알림허용"
        settingView1.switchButton1.addTarget(self, action: #selector(action(switchButton:)), for: .touchUpInside)
        view.addSubview(settingView1)
        
        settingView4.uni(frame: [0, 165, 375, 45], pad: [])
        settingView4.label1.text = "나의 dear 지정"
        settingView4.label2.text = "엄마, 아빠  >"
        settingView4.button1.tag = 4
        settingView4.button1.addTarget(self, action: #selector(action(button:)), for: .touchUpInside)
        view.addSubview(settingView4)
        
        settingView5.uni(frame: [0, 210, 375, 45], pad: [])
        settingView5.label1.text = "dear에게 열쇠 미리주기"
        settingView5.label2.text = ">"
        settingView5.isLast = true
        settingView5.button1.tag = 5
        settingView5.button1.addTarget(self, action: #selector(action(button:)), for: .touchUpInside)
        view.addSubview(settingView5)
        
        settingView6.uni(frame: [0, 282, 375, 45], pad: [])
        settingView6.label1.text = "프로필 설정"
        settingView6.label2.text = ">"
        settingView6.button1.tag = 6
        settingView6.button1.addTarget(self, action: #selector(action(button:)), for: .touchUpInside)
        view.addSubview(settingView6)
        
        settingView7.uni(frame: [0, 327, 375, 45], pad: [])
        settingView7.label1.text = "비밀번호 설정"
        settingView7.label2.text = ">"
        settingView7.button1.tag = 7
        settingView7.button1.addTarget(self, action: #selector(action(button:)), for: .touchUpInside)
        view.addSubview(settingView7)
        
        settingView8.uni(frame: [0, 372, 375, 45], pad: [])
        settingView8.label1.text = "로그아웃"
        settingView8.label2.text = ">"
        settingView8.button1.tag = 8
        settingView8.button1.addTarget(self, action: #selector(action(button:)), for: .touchUpInside)
        view.addSubview(settingView8)
        
        settingView9.uni(frame: [0, 417, 375, 45], pad: [])
        settingView9.label1.text = "탈퇴하기"
        settingView9.label2.text = ">"
        settingView9.isLast = true
        settingView9.button1.tag = 9
        settingView9.button1.addTarget(self, action: #selector(action(button:)), for: .touchUpInside)
        view.addSubview(settingView9)
        
        viewExtend()
    }
    
    @objc private func dismiss(_ button: UIButton) {
        print("dismiss")
    }
    
    @objc private func action(button: UIButton) {
        if button.tag == 5 {
            if MFMessageComposeViewController.canSendText() {
                messageComposer = MFMessageComposeViewController()
                messageComposer.body = "[dear.] 선영님이 당신을 위해 미리 준비해둔 메세지입니다. 꼭 기억하시다가, 때가 되었을때 확인해주세요"
                messageComposer.messageComposeDelegate = self
                modalTransitionStyle = .crossDissolve
                present(messageComposer, animated: true, completion: nil)
            }
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func action(switchButton: UISwitch) {
        asd += 1
        viewExtend()
    }
    
    var asd = 1
    private func viewExtend() {
        if asd % 2 == 0 {
            settingView1.isLast = false
            settingView1.layoutSubviews()
            UIView.animate(withDuration: 0.25, animations: {
                self.settingView2.frame.origin.y = self.uni(height: [139])
                self.settingView3.frame.origin.y = self.uni(height: [184])
                self.settingView4.frame.origin.y = self.uni(height: [255])
                self.settingView5.frame.origin.y = self.uni(height: [300])
                self.settingView6.frame.origin.y = self.uni(height: [372])
                self.settingView7.frame.origin.y = self.uni(height: [417])
                self.settingView8.frame.origin.y = self.uni(height: [462])
                self.settingView9.frame.origin.y = self.uni(height: [507])
            })
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.settingView2.frame.origin.y = self.uni(height: [94])
                self.settingView3.frame.origin.y = self.uni(height: [94])
                self.settingView4.frame.origin.y = self.uni(height: [165])
                self.settingView5.frame.origin.y = self.uni(height: [210])
                self.settingView6.frame.origin.y = self.uni(height: [282])
                self.settingView7.frame.origin.y = self.uni(height: [327])
                self.settingView8.frame.origin.y = self.uni(height: [372])
                self.settingView9.frame.origin.y = self.uni(height: [417])
            }, completion: { finish in
                self.settingView1.isLast = true
                self.settingView1.layoutSubviews()
            })
        }
    }

    @objc private func closeButtonTapped(_ button: UIBarButtonItem) {
        self.dismiss(animated:true)
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
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: 2)
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
