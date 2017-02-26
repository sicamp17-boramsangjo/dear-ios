//
// Created by kyungtaek on 2017. 2. 22..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class ReadyOnlyPasswordViewController: UIViewController {
    
    var label1 = UILabel()
    var textField1 = UITextField()
    var view1 = UIView()
    var button1 = UIButton()
    
    var disposeBag: DisposeBag! = DisposeBag()

    var userID: String
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
        UIApplication.shared.statusBarStyle = .lightContent
        view.backgroundColor = UIColor.white
        
        label1.uni(frame: [0, 216, 375, 30], pad: [])
        label1.textColor = UIColor(hexString: "555555")
        label1.textAlignment = .center
        label1.font = UIFont.drNM28Font()
        label1.text = "생년월일을 입력해주세요"
        view.addSubview(label1)
        
        textField1.uni(frame: [50, 273, 270, 30], pad: [])
        textField1.textAlignment = .center  
        textField1.font = UIFont.drSDThin28Font()
        textField1.textColor = UIColor(hexString: "8c96a5")
        textField1.keyboardType = .numberPad
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
        button1.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button1)
        
        textField1.rx.text.orEmpty.subscribe({
            if let text = $0.element, text.characters.count > 3 {
                self.button1.isEnabled = true
                self.button1.alpha = 1
                if text.characters.count > 4 {
                    self.textField1.text = text.substring(to: text.characters.index(text.startIndex, offsetBy: 4))
                }
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

    @objc private func doneButtonTapped(_ button: UIButton) {
        guard let birthdayString = textField1.text else {
            return
        }
        //userID = "58b1e63abf825f790eede16c"
        self.apiManager.getSessionTokenForReadOnly(readOnlyToken: self.userID, birthDayString:birthdayString) { [unowned self] dictionary, error in
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
