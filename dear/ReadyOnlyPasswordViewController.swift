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
    var textField1 = UITextField()
    var view1 = UIView()
    var label1 = UILabel()
    var imageView2 = UIImageView()
    
    var disposeBag: DisposeBag! = DisposeBag()


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
        view.backgroundColor = UIColor(hexString: "f4f4f4")
        
        imageView1.uni(frame: [138.5, 118.5, 98, 60], pad: [])
        imageView1.image = #imageLiteral(resourceName: "dearCalli")
        view.addSubview(imageView1)
        
        textField1.uni(frame: [50, 217, 270, 30], pad: [])
        textField1.textAlignment = .center
        textField1.font = UIFont.drSDThin28Font()
        textField1.textColor = UIColor(hexString: "8c96a5")
        textField1.keyboardType = .numberPad
        view.addSubview(textField1)
        
        view1.uni(frame: [50, 248, 270, 1], pad: [])
        view1.backgroundColor = UIColor(hexString: "aaaaaa")
        view.addSubview(view1)
        
        label1.uni(frame: [0, 262, 375, 25], pad: [])
        label1.textColor = UIColor(hexString: "555555")
        label1.textAlignment = .center
        label1.font = UIFont.drSDLight16Font()
        label1.text = "생일 4자리를 입력해주세요"
        view.addSubview(label1)
        
        imageView2.uni(frame: [0, 363, 375, 304], pad: [])
        imageView2.image = #imageLiteral(resourceName: "envelope")
        view.addSubview(imageView2)

        textField1.rx.text.orEmpty.subscribe({
            if let text = $0.element {
                if text.characters.count > 3 {
                   self.getTokenForReadOnly()
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


    private func getTokenForReadOnly() {
        self.apiManager.getSessionTokenForReadOnly(readOnlyToken: self.userID, birthDayString:textField1.text!) { [unowned self] dictionary, error in

            guard error == nil, let sessionToken = dictionary?["sessionToken"] as? String else {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                self.textField1.text = ""
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
