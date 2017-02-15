//
// Created by kyungtaek on 2017. 2. 15..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import DigitsKit
import SnapKit
import ChameleonFramework

class SignInViewController: UIViewController {

    var loginCompletion: ((String?, Error?) -> Void)?

    convenience init (completion: @escaping (String?, Error?) -> Void) {
        self.init(nibName: nil, bundle: nil)
        self.loginCompletion = completion
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }

    private func setupView() {

        self.view.backgroundColor = UIColor.flatWhite()

        guard let signInButton = DGTAuthenticateButton(authenticationCompletion: { session, error in
            self.loginCompletion?(session?.phoneNumber, error)
        }) else { return }

        signInButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(signInButton)
        signInButton.snp.makeConstraints { makes in
            makes.centerX.equalToSuperview()
            makes.bottom.equalTo(-60)
        }
    }

}
