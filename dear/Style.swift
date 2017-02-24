// Color palette
import UIKit

extension UIColor {

    class var drOR: UIColor {
        return UIColor(red: 241.0 / 255.0, green: 82.0 / 255.0, blue: 11.0 / 255.0, alpha: 1.0)
    }

    class var drGR01: UIColor {
        return UIColor(red: 140.0 / 255.0, green: 150.0 / 255.0, blue: 165.0 / 255.0, alpha: 1.0)
    }

    class var drGR02: UIColor {
        return UIColor(red: 140.0 / 255.0, green: 150.0 / 255.0, blue: 165.0 / 255.0, alpha: 0.5)
    }

    class var drBK: UIColor {
        return UIColor(white: 51.0 / 255.0, alpha: 1.0)
    }

    class var drGR00: UIColor {
        return UIColor(red: 244.0 / 255.0, green: 247.0 / 255.0, blue: 249.0 / 255.0, alpha: 1.0)
    }

    class var drGR03: UIColor {
        return UIColor(red: 140.0 / 255.0, green: 150.0 / 255.0, blue: 165.0 / 255.0, alpha: 0.6)
    }

    class var drGR04: UIColor {
        return UIColor(red: 140.0 / 255.0, green: 150.0 / 255.0, blue: 165.0 / 255.0, alpha: 0.3)
    }

}

// Text styles

extension UIFont {
    class func drNM37Font() -> UIFont? {
        return UIFont(name: "NanumMyeongjoOTF", size: 37.0)
    }

    class func drSDThin34Font() -> UIFont? {
        return UIFont(name: "AppleSDGothicNeo-Thin", size: 34.0)
    }

    class func drNM28Font() -> UIFont? {
        return UIFont(name: "NanumMyeongjoOTF", size: 28.0)
    }

    class func drSDThin28Font() -> UIFont? {
        return UIFont(name: "AppleSDGothicNeo-Thin", size: 27.93)
    }

    class func drNM24Font() -> UIFont? {
        return UIFont(name: "NanumMyeongjoOTF", size: 24.0)
    }

    class func drNM23Font() -> UIFont? {
        return UIFont(name: "NanumMyeongjoOTF", size: 23.12)
    }
    
    class func drNM17Font() -> UIFont? {
        return UIFont(name: "NanumMyeongjoOTF", size: 17)
    }
    
    class func drSDMedium12Font() -> UIFont? {
        return UIFont(name: "AppleSDGothicNeo-Medium", size: 12)
    }

    class func drSDMedium155Font() -> UIFont? {
        return UIFont(name: "AppleSDGothicNeo-Medium", size: 15.5)
    }

    class func drSDLight155Font() -> UIFont? {
        return UIFont(name: "AppleSDGothicNeo-Light", size: 15.5)
    }

    class func drSDULight155Font() -> UIFont? {
        return UIFont(name: "AppleSDGothicNeo-UltraLight", size: 15.5)
    }

    class func drSDULight16Font() -> UIFont? {
        return UIFont(name: "AppleSDGothicNeo-UltraLight", size: 16)
    }

    class func drTextStyleFont() -> UIFont? {
        return UIFont(name: "AppleSDGothicNeo-Regular", size: 13.82)
    }

    class func drSDLight14Font() -> UIFont? {
        return UIFont(name: "AppleSDGothicNeo-Light", size: 13.82)
    }

    class func drSDRegular13Font() -> UIFont? {
        return UIFont(name: "AppleSDGothicNeo-Regular", size: 13.0)
    }

    class func drNMB13Font() -> UIFont? {
        return UIFont(name: "NanumMyeongjoBold", size: 13)
    }
}
