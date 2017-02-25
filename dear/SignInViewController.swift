//
// Created by kyungtaek on 2017. 2. 22..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SignInViewController: UIViewController {
    
    var label1 = UILabel()
    var textField1 = UITextField()
    var view1 = UIView()
    var button1 = UIButton()
    
    var disposeBag: DisposeBag! = DisposeBag()
    
    let phoneNumber: String
    let apiManager: APIManager = APIManager()
    let loginCompletion: (User?, Error?) -> Void
    
    init(phoneNumber:String, loginCompletion:@escaping (User?, Error?) -> Void) {
        self.phoneNumber = phoneNumber
        self.loginCompletion = loginCompletion
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
        view.backgroundColor = UIColor.white
        
        label1.uni(frame: [0, 216, 375, 30], pad: [])
        label1.textColor = UIColor(hexString: "555555")
        label1.textAlignment = .center
        label1.font = UIFont.drNM28Font()
        label1.text = "비밀번호를 입력해주세요"
        view.addSubview(label1)
        
        textField1.uni(frame: [50, 273, 270, 30], pad: [])
        textField1.textAlignment = .center
        textField1.font = UIFont.drSDThin28Font()
        textField1.textColor = UIColor(hexString: "8c96a5")
        textField1.clearButtonMode = .always
        view.addSubview(textField1)
        
        view1.uni(frame: [50, 304, 270, 0.5], pad: [])
        view1.backgroundColor = UIColor(hexString: "8c96a5")
        view.addSubview(view1)
        
        button1.uni(frame: [37.5, 585, 300, 50], pad: [])
        button1.backgroundColor = UIColor(hexString: "f1520b")
        button1.setTitle("로그인", for: .normal)
        button1.titleLabel!.font = UIFont.drSDLight16Font()
        button1.setTitleColor(UIColor.white, for: .normal)
        button1.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button1)

        textField1.font = UIFont.drSDThin28Font()
        textField1.textAlignment = .center
        textField1.isSecureTextEntry = true
        textField1.rx.text.orEmpty.subscribe({
            if let text = $0.element, text.characters.count > 3 {
                self.button1.isEnabled = true
                self.button1.alpha = 1
            } else {
                self.button1.isEnabled = false
                self.button1.alpha = 0.3
            }
        }).addDisposableTo(disposeBag)
        
        keyboardWillShow {
            self.button1.frame.origin.y = self.view.bounds.height - $0.height - self.uni(height: [60])
        }
        keyboardWillHide { _ in
            self.button1.frame.origin.y = self.uni(height: [585])
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        view.endEditing(false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed {
            disposeBag = nil
        }
    }
    
    @objc private func loginButtonTapped(_ button: UIButton) {
        guard let password = self.textField1.text else {
            return
        }
        
        self.apiManager.login(phoneNumber: self.phoneNumber, password:password ) { [unowned self] loginResult, error in
            if error != nil {
                Alert.showError(error!)
                return
            }
            
            if loginResult == false {
                self.loginCompletion(nil, InternalError.loginFail)
                return
            }
            
            self.apiManager.getUserInfo {[unowned self] dictionary, error in
                
                guard let loginUserValue = dictionary else {
                    self.loginCompletion(nil, error ?? InternalError.loginFail)
                    return
                }
                
                DataSource.instance.storeLoginUser(loginUserValue: loginUserValue)
                self.loginCompletion(DataSource.instance.fetchLoginUser(), nil)
            }
            
        }
    }
    
}
