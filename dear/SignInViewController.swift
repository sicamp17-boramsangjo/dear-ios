//
// Created by kyungtaek on 2017. 2. 22..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    let phoneNumber: String
    let apiManager: APIManager = APIManager()
    let loginCompletion: (User?, Error?) -> Void

    weak var textField: UITextField!
    weak var doneButton: UIButton!

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

        let textField = UITextField(frame:.zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(textField)
        textField.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 240, height: 60))
            maker.centerX.equalToSuperview()
            maker.topMargin.equalTo(120)
        }
        self.textField = textField

        let doneButton = UIButton(type: .roundedRect)
        doneButton.setTitle("Login", for: .normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(doneButton)
        doneButton.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 240, height: 60))
            maker.centerX.equalToSuperview()
            maker.top.equalTo(textField.snp.bottom).offset(12)
        }
        self.doneButton = doneButton
    }

    @objc private func loginButtonTapped(_ button: UIButton) {

        guard let password = self.textField.text else {
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
