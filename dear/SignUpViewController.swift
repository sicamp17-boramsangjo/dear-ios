//
// Created by kyungtaek on 2017. 2. 19..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit
import SMDatePicker
import ChameleonFramework

class SignUpViewController: UIViewController, SMDatePickerDelegate {

    weak var nameTextField: UITextField!
    weak var passwordTextField: UITextField!
    weak var birthdayField: UIButton!
    weak var genderField: UISegmentedControl!
    weak var signUpButton: UIButton!

    let phoneNumber: String
    let loginCompletion: ((User?, Error?) -> Void)
    let apiManager: APIManager = APIManager(session: nil, needUserAuthorization: false)
    var birthDay: Date?

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

        let nameTextField = UITextField(frame:.zero)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.text = "Name"
        nameTextField.textColor = UIColor.black
        nameTextField.snp.makeConstraints { (make) in
            make.height.equalTo(30)
        }
        self.nameTextField = nameTextField

        let passwordTextField = UITextField(frame:.zero)
        passwordTextField.text = "Password"
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.textColor = UIColor.black
        passwordTextField.snp.makeConstraints { (make) in
            make.height.equalTo(30)
        }
        self.passwordTextField = passwordTextField

        let birthdayField = UIButton(type:.custom)
        birthdayField.setTitle("birth day", for: .normal)
        birthdayField.setTitleColor(UIColor.black, for: .normal)
        birthdayField.addTarget(self, action: #selector(birthdayFieldTapped(_:)), for: .touchUpInside)
        birthdayField.translatesAutoresizingMaskIntoConstraints = false
        birthdayField.snp.makeConstraints { (make) in
            make.width.equalTo(240)
            make.height.equalTo(30)
        }
        self.birthdayField = birthdayField

        let genderField = UISegmentedControl(items: ["male", "female", "other"])
        genderField.translatesAutoresizingMaskIntoConstraints = false
        genderField.snp.makeConstraints { (make) in
            make.width.equalTo(240)
            make.height.equalTo(30)
        }
        self.genderField = genderField

        let signUpButton = UIButton(type: .custom)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitle("Sign up", for: .normal)
        signUpButton.backgroundColor = UIColor.flatSkyBlue
        signUpButton.setTitleColor(UIColor.black, for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped(_:)), for: .touchUpInside)
        signUpButton.snp.makeConstraints { (make) in
            make.height.equalTo(30)
        }
        self.signUpButton = signUpButton

        let container = UIStackView(arrangedSubviews: [nameTextField, passwordTextField, birthdayField, genderField, signUpButton])
        container.axis = .vertical
        container.distribution = .equalSpacing
        container.alignment = .fill
        container.spacing = 10
        container.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(320)
            make.topMargin.equalTo(80)
        }

    }

    @objc private func birthdayFieldTapped(_ sender: UIButton?) {
        let datePicker = SMDatePicker()
        datePicker.delegate = self
        datePicker.pickerMode = .date
        datePicker.showPickerInView(self.view, animated: true)
    }

    @objc func datePicker(_ picker: SMDatePicker, didPickDate date: Date) {
        self.birthdayField.setTitle(date.getBirthdayString(), for: .normal)
        self.birthDay = date
    }

    @objc private func signUpButtonTapped(_ sender: UIButton) {
        self.apiManager.createUser(name: "kyungtaek", phoneNumber: self.phoneNumber, birth:self.birthDay!, gender: true) { userRawInfo, error in

            if userRawInfo != nil {
                DataSource.instance.storeLoginUser(loginUser: userRawInfo as! [String:Any])
                self.loginCompletion(DataSource.instance.fetchLoginUser(), nil)
                return
            } else {
                print(error)
            }

        }
    }

}
