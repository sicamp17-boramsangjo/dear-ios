//
// Created by kyungtaek on 2017. 2. 15..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import DigitsKit
import SnapKit
import ChameleonFramework

class SignInViewController: UIViewController {

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

        let signInButton = UIButton(type:.custom)
        signInButton.setTitle("Sign in with Phone number", for: .normal)
        signInButton.setTitleColor(UIColor.white, for: .normal)
        signInButton.backgroundColor = UIColor.flatSkyBlue
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(signInButton)
        signInButton.snp.makeConstraints { makes in
            makes.centerX.equalToSuperview()
            makes.bottom.equalTo(-60)
        }
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

            self.checkUser(phoneNumber: currentSession.phoneNumber) { user, error in

                guard user != nil && error == nil else {
                    self.launchSignUpViewController(phoneNumber: currentSession.phoneNumber, loginCompletion: self.loginCompletion)
                    return
                }

                self.loginCompletion(user, nil)
            }

        }
    }

    private func checkUser(phoneNumber: String, completion: @escaping (User?, Error?) -> Void) {

        self.apiManager.getUserInfo(userId: phoneNumber) {[unowned self] loginUser, error in

#if DEBUG
            completion(nil, APIInternalError.notFound)
#else
            guard let loginedUser = loginUser else {
                completion(nil, error)
                return
            }

            DataSource.instance.storeLoginUser(loginUserValue: loginUser as! [String:Any])
            completion(DataSource.instance.fetchLoginUser(), nil)
#endif
        }
    }

    private func launchSignUpViewController(phoneNumber: String, loginCompletion: @escaping (User?, Error?) -> Void) {
        let signUpViewController = SignUpViewController(phoneNumber: phoneNumber, completion: loginCompletion)
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }

}
