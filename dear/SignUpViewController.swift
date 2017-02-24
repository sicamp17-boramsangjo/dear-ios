//
// Created by kyungtaek on 2017. 2. 19..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit
import SMDatePicker
import ChameleonFramework
import RxCocoa
import RxSwift

class SignUpViewController: UIViewController, SMDatePickerDelegate {
    
    let textField1 = UITextField()
    let button1 = UIButton()
    let button2 = UIButton(type: .system)
    
    let phoneNumber: String
    let loginCompletion: ((User?, Error?) -> Void)
    let apiManager: APIManager = APIManager()
    var birthDay: Date?
    var disposeBag: DisposeBag! = DisposeBag()
    
    init(phoneNumber: String, completion: @escaping (User?, Error?) -> Void) {
        self.phoneNumber = phoneNumber
        self.loginCompletion = completion
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    private func setupView() {
        self.view.backgroundColor = UIColor.flatWhite

        let label1 = UILabel()
        label1.uni(frame: [106.5, 136, 165, 70.5], pad: [])
        label1.font = UIFont.drNM28Font()
        label1.textColor = UIColor(hexString: "8c96a5")
        label1.text = "나머지 정보를\n입력해주세요"
        label1.textAlignment = .center
        label1.numberOfLines = 0
        view.addSubview(label1)
        
        textField1.uni(frame: [70, 274, 235, 25], pad: [])
        textField1.backgroundColor = UIColor.clear
        textField1.font = UIFont.drSDThin28Font()
        textField1.textColor = UIColor(hexString: "8c96a5")
        textField1.textAlignment = .center
        textField1.placeholder = "사용자 이름"
        view.addSubview(textField1)
        
        let view1 = UIView()
        view1.uni(frame: [70, 299, 235, 0.5], pad: [])
        view1.backgroundColor = UIColor(hexString: "8c96a5")
        view.addSubview(view1)
        
        button1.uni(frame: [70, 339, 235, 25], pad: [])
        button1.backgroundColor = UIColor.clear
        button1.titleLabel!.font = UIFont.drSDThin28Font()
        button1.setTitleColor(UIColor(hexString: "8c96a5"), for: .normal)
        button1.titleLabel!.textAlignment = .center
        button1.setTitle("생년월일", for: .normal)
        button1.addTarget(self, action: #selector(birthdayFieldTapped), for: .touchUpInside)
        view.addSubview(button1)
        
        let view2 = UIView()
        view2.uni(frame: [70, 364, 235, 0.5], pad: [])
        view2.backgroundColor = UIColor(hexString: "8c96a5")
        view.addSubview(view2)
        
        let label2 = UILabel()
        label2.uni(frame: [76.5, 473.5, 222.5, 37], pad: [])
        label2.font = UIFont.drSDULight155Font()
        label2.textColor = UIColor(hexString: "8c96a5")
        label2.text = "작성하신 내용은 심적효력만 있어요 :)\n법적효력은 없으니 주의해주세요!"
        label2.textAlignment = .center
        label2.numberOfLines = 0
        view.addSubview(label2)
        
        let label3 = UILabel()
        label3.uni(frame: [69.5, 535, 236.5, 14], pad: [])
        label3.font = UIFont.drSDULight155Font()
        label3.textColor = UIColor(hexString: "8c96a5")
        label3.text = "푸시 메세지를 받아보시는걸 권장드려요"
        label3.textAlignment = .center
        label3.numberOfLines = 0
        view.addSubview(label3)
        
        button2.uni(frame: [37.5, 585, 300, 50], pad: [])
        button2.backgroundColor = UIColor(hexString: "f1520b")
        button2.titleLabel?.font = UIFont.drSDLight155Font()
        button2.setTitle("가입하기", for: .normal)
        button2.tintColor = UIColor.white
        button2.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        view.addSubview(button2)
        
        textField1.rx.text.orEmpty.subscribe({ value in
            self.checkText()
        }).addDisposableTo(disposeBag)
    }
    
    private func checkText() {
        if !textField1.text!.isEmpty && button1.currentTitle != "생년월일" {
            button2.isEnabled = true
            button2.alpha = 1
        } else {
            button2.isEnabled = false
            button2.alpha = 0.3
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed {
            disposeBag = nil
        }
    }

    @objc private func birthdayFieldTapped(_ sender: UIButton?) {
        let datePicker = SMDatePicker()
        datePicker.delegate = self
        datePicker.pickerMode = .date
        datePicker.showPickerInView(self.view, animated: true)
    }

    @objc func datePicker(_ picker: SMDatePicker, didPickDate date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        button1.setTitle(formatter.string(from: date), for: .normal)
        self.birthDay = date
        checkText()
    }

    @objc private func signUpButtonTapped(_ sender: UIButton) {
        self.apiManager.createUser(userName: "kyungtaek", phoneNumber: self.phoneNumber, birthDay:self.birthDay!, password:"password") { userRawInfo, error in

            if userRawInfo != nil {
                DataSource.instance.storeLoginUser(loginUserValue: userRawInfo!)
                self.loginCompletion(DataSource.instance.fetchLoginUser(), nil)
                return
            } else {
                print(error)
            }

        }

    }

}
