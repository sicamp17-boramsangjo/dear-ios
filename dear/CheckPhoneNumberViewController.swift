//
// Created by kyungtaek on 2017. 2. 15..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import DigitsKit
import SnapKit
import ChameleonFramework
import FLAnimatedImage

class CheckPhoneNumberViewController: UIViewController {

    var imageView:FLAnimatedImageView!
    var charImageView:UIImageView!

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

        let imageView = FLAnimatedImageView(frame:.zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
         }
        imageView.loopCompletionBlock = { _ in
            imageView.stopAnimating()
        }
        self.imageView = imageView

        let charImageView = UIImageView(image: UIImage(named: "introIllust"))
        charImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(charImageView)
        charImageView.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 148, height: 135))
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(103)
         }

        let button1 = UIButton(type: .system)
        button1.uni(frame: [37.5, 577, 300, 50], pad: [])
        button1.backgroundColor = UIColor.drDB
        button1.titleLabel?.font = UIFont.drSDMedium16Font()
        button1.setTitle("전화번호로 시작하기", for: .normal)
        button1.setTitleColor(UIColor.white, for: .normal)
        button1.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        view.addSubview(button1)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let bundle = Bundle.main
        guard let path = bundle.path(forResource: "app_intro", ofType: "gif") else {
            return
        }
        let image = FLAnimatedImage(animatedGIFData: NSData(contentsOfFile: path) as Data!)
        self.imageView.animatedImage = image!
    }


    @objc private func signInButtonTapped() {
        let digits = Digits.sharedInstance()
        guard let configuration = DGTAuthenticationConfiguration(accountFields: .defaultOptionMask) else {
            return
        }
        let appearlance = DGTAppearance()
        appearlance.backgroundColor = UIColor.drGR00
        appearlance.accentColor = UIColor.drDB
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

        guard phoneNumber != nil else {
            completion(false, InternalError.notFound)
            return
        }

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
