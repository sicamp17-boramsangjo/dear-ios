//
// Created by kyungtaek on 2017. 2. 15..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import DigitsKit
import SnapKit
import ChameleonFramework

class CheckPhoneNumberViewController: UIViewController {

    var loginCompletion: (User?, Error?) -> Void
    let apiManager: APIManager = APIManager()

    init (completion: @escaping (User?, Error?) -> Void) {
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
        
        navigationController?.isNavigationBarHidden = true
        
        let label1 = UILabel()
        label1.uni(frame: [41, 116.5, 239.5, 226], pad: [])
        label1.font = UIFont.drSDThin34Font()
        label1.textColor = UIColor(hexString: "8c96a5")
        label1.text = "갑작스러운\n당신의 빈자리.\n\n남겨질\n소중한 사람들에게\n메세지를 남기세요"
        label1.numberOfLines = 0
        view.addSubview(label1)
        
        let label2 = UILabel()
        label2.uni(frame: [41.5, 401.5, 73.5, 35], pad: [])
        label2.font = UIFont.drNM37Font()
        label2.textColor = UIColor(hexString: "f1520b")
        label2.text = "디어."
        label2.numberOfLines = 0
        view.addSubview(label2)
        
        let button1 = UIButton(type: .system)
        button1.uni(frame: [37.5, 577, 300, 50], pad: [])
        button1.backgroundColor = UIColor(hexString: "f1520b")
        button1.titleLabel?.font = UIFont.drSDLight155Font()
        button1.setTitle("전화번호로 시작하기", for: .normal)
        button1.tintColor = UIColor.white
        view.addSubview(button1)
    }

    @objc private func signInButtonTapped() {
        let digits = Digits.sharedInstance()
        guard let configuration = DGTAuthenticationConfiguration(accountFields: .defaultOptionMask) else {
            return
        }
        let appearlance = DGTAppearance()
        appearlance.backgroundColor = UIColor.flatWhite
        appearlance.accentColor = UIColor.flatSkyBlue
        configuration.appearance = appearlance
        configuration.phoneNumber = "+82"

        digits.authenticate(with:nil, configuration:configuration) { [unowned self] (session, error) in

            guard let currentSession = session else {
                return
            }

            self.checkUser(phoneNumber: currentSession.phoneNumber) { alreadyJoined, error in

                guard alreadyJoined else {
                    self.launchSignUpViewController(phoneNumber: currentSession.phoneNumber, loginCompletion: self.loginCompletion)
                    return
                }

                self.launchSignInViewController(phoneNumber: currentSession.phoneNumber, loginCompletion: self.loginCompletion)
            }

        }
    }

    private func checkUser(phoneNumber: String, completion: @escaping (Bool, Error?) -> Void) {

        self.apiManager.checkAlreadyJoin(phoneNumber: phoneNumber) { result, error in
            if error != nil {
                Alert.showError(error!)
                return
            }

            completion(result, nil)
        }
    }

    private func launchSignUpViewController(phoneNumber: String, loginCompletion: @escaping (User?, Error?) -> Void) {
        let signUpViewController = SignUpViewController(phoneNumber: phoneNumber, completion: loginCompletion)
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }

    private func launchSignInViewController(phoneNumber: String, loginCompletion: @escaping (User?, Error?) -> Void) {
        let signInViewController = SignInViewController(phoneNumber: phoneNumber, loginCompletion: self.loginCompletion)
        self.navigationController?.pushViewController(signInViewController, animated: true)
    }

}
