//
// Created by kyungtaek on 2017. 2. 22..
// Copyright (c) 2017 sicamp. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class ReadyOnlyPasswordViewController: UIViewController {
    
    var imageView1 = UIImageView()
    var label1 = UILabel()
    var textField1 = UITextField()
    var view1 = UIView()
    var imageView2 = UIImageView()
    
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
        view.backgroundColor = UIColor(hexString: "f4f4f4")
        
        imageView1.uni(frame: [146.5, 145, 82.5, 33], pad: [])
        imageView1.contentMode = .scaleAspectFit
        imageView1.image = #imageLiteral(resourceName: "logoDark")
        view.addSubview(imageView1)
        
        label1.uni(frame: [0, 228, 375, 25], pad: [])
        label1.textColor = UIColor(hexString: "555555")
        label1.textAlignment = .center
        label1.font = UIFont.drNM15Font()
        label1.text = "생일 4자리를 입력해주세요"
        view.addSubview(label1)
        
        textField1.uni(frame: [50, 264, 270, 30], pad: [])
        textField1.textAlignment = .center  
        textField1.font = UIFont.drSDThin28Font()
        textField1.textColor = UIColor(hexString: "8c96a5")
        textField1.keyboardType = .numberPad
        textField1.clearButtonMode = .always
        view.addSubview(textField1)
        
        view1.uni(frame: [50, 296.5, 270, 0.5], pad: [])
        view1.backgroundColor = UIColor(hexString: "808080")
        view.addSubview(view1)
        
        imageView2.uni(frame: [0, 357.5, 375, 309.5], pad: [])
        imageView2.contentMode = .scaleAspectFit
        imageView2.image = #imageLiteral(resourceName: "envelope")
        view.addSubview(imageView2)
        
        textField1.rx.text.orEmpty.subscribe({
            if let text = $0.element {
                if text.characters.count > 3 {
                    self.getSessionTokenForReadOnly()
                }
                if text.characters.count > 4 {
                    self.textField1.text = text.substring(to: text.characters.index(text.startIndex, offsetBy: 4))
                }
            }
        }).addDisposableTo(disposeBag)
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

    private func getSessionTokenForReadOnly() {
        guard let birthdayString = textField1.text else {
            return
        }
        //userID = "58b1e63abf825f790eede16c"
        self.apiManager.getSessionTokenForReadOnly(readOnlyToken: self.userID, birthDayString:birthdayString) { [unowned self] dictionary, error in
            guard error == nil, let sessionToken = dictionary?["sessionToken"] as? String else {
                self.textField1.text = ""
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
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
