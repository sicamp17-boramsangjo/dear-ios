//
// Created by kyungtaek on 2017. 2. 22..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit

class ReadyOnlyPasswordViewController: UIViewController {

    let userID: String
    let apiManager = APIManager()
    weak var textField: UITextField!
    weak var doneButton: UIButton!

    init(userID: String) {
        self.userID = userID
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
        doneButton.setTitle("Confirm", for: .normal)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
        self.view.addSubview(doneButton)
        doneButton.snp.makeConstraints { maker in
            maker.size.equalTo(CGSize(width: 240, height: 60))
            maker.centerX.equalToSuperview()
            maker.top.equalTo(textField.snp.bottom).offset(12)
        }
        self.doneButton = doneButton
    }

    @objc private func doneButtonTapped(_ button: UIButton) {
        self.apiManager.getSessionTokenForReadOnly(userID: self.userID, birthDay: Date()) { [unowned self] dictionary, error in
            guard error == nil, let sessionToken = dictionary?["sessionToken"] as? String else {
                Alert.showError(error ?? InternalError.unknown)
                return
            }

            self.launchReadOnlyContentViewController(sessionToken: sessionToken)
        }
    }

    private func launchReadOnlyContentViewController(sessionToken:String) {
        let readOnlyContentViewController = ReadOnlyContentViewController(sessionToken: sessionToken)
        self.present(readOnlyContentViewController, animated: true)
    }


}
