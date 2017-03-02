
import RxSwift
import RxCocoa

protocol Universal: NSObjectProtocol {
    func uni(width: [CGFloat]) -> CGFloat
    func uni(height: [CGFloat]) -> CGFloat
}

extension Universal {
    
    func uni(width: [CGFloat]) -> CGFloat {
        let screen = UIScreen.main.bounds.width
        let reference: CGFloat = (device() == .phone) ? 375 : 1024
        let value = ((device() == .phone) || width.count <= 1) ? width[0] : width[1]
        return value / reference * screen
    }
    
    func uni(height: [CGFloat]) -> CGFloat {
        let screen = UIScreen.main.bounds.height
        let reference: CGFloat = (device() == .phone) ? 667 : 1366
        let value = ((device() == .phone) || height.count <= 1) ? height[0] : height[1]
        return value / reference * screen
    }
    
    func device() -> UIUserInterfaceIdiom {
        return UIDevice.current.userInterfaceIdiom
    }
    
}

extension UIView: Universal {
    
    func uni(frame: [CGFloat], pad: [CGFloat]) {
        self.frame = CGRect(x: uni(width: [frame[0], pad.isEmpty ? frame[0] : pad[0]]),
                            y: uni(height: [frame[1], pad.isEmpty ? frame[1] : pad[1]]),
                            width: uni(width: [frame[2], pad.isEmpty ? frame[2] : pad[2]]),
                            height: uni(height: [frame[3], pad.isEmpty ? frame[3] : pad[3]]))
    }
    
}

extension UIViewController: Universal {
    
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
