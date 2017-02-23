
import RxSwift
import RxCocoa

extension UIViewController {
    
    func keyboardWillShow(_ completion: @escaping (KeyboardObserver.keyboardRect) -> Void) {
        KeyboardObserver.shared.willShow {completion($0)}
    }
    
    func keyboardWillHide(_ completion: @escaping (KeyboardObserver.keyboardRect) -> Void) {
        KeyboardObserver.shared.willHide {completion($0)}
    }
    
}

class KeyboardObserver {
    
    static let shared = KeyboardObserver()
    private let disposeBag = DisposeBag()
    
    struct keyboardRect {
        var width: CGFloat = 0
        var height: CGFloat = 0
    }
    
    func willShow(_ completion: @escaping (keyboardRect!) -> Void) {
        NotificationCenter.default.rx.notification(.UIKeyboardWillShow).subscribe({
            completion(self.frameInfo($0.element))
        }).addDisposableTo(disposeBag)
    }
    
    func willHide(_ completion: @escaping (keyboardRect!) -> Void) {
        NotificationCenter.default.rx.notification(.UIKeyboardWillHide).subscribe({
            completion(self.frameInfo($0.element))
        }).addDisposableTo(disposeBag)
    }
    
    private func frameInfo(_ noti: Notification?) -> keyboardRect! {
        if let rect = noti?.userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect? {
            return keyboardRect(width: rect.width, height: rect.height)
        } else {
            return nil
        }
    }
    
}
