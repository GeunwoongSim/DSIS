import UIKit

extension UIColor { //UIColor 컴포넌트로 hex코드를 추가
    convenience init(hex: Int) {
        let components = (
            R : CGFloat((hex >> 16) & 0xff) / 255,
            G : CGFloat((hex >> 08) & 0xff) / 255,
            B : CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
    convenience init(hex: Int, alpha: CGFloat) {
        let components = (
            R : CGFloat((hex >> 16) & 0xff) / 255,
            G : CGFloat((hex >> 08) & 0xff) / 255,
            B : CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: alpha)
    }
}
