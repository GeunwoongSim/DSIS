import Foundation
import UIKit
//https://developer-fury.tistory.com/33 을 참고하여 레이블 크기 수정
extension UILabel {
    func fontToFit(name:String, size: CGFloat){
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        switch height {
            case 480.0: //Iphone 3,4S => 3.5 inch
                self.font = UIFont(name: name, size: size*0.76)
            case 568.0: //iphone 5, SE => 4 inch
                self.font = UIFont(name: name, size: size*0.87)
            case 667.0: //iphone 6, 6s, 7, 8 => 4.7 inch
                self.font = UIFont(name: name, size: size)
            case 736.0: //iphone 6s+ 6+, 7+, 8+ => 5.5 inch
                self.font = UIFont(name: name, size: size*1.03)
            case 812.0: //iphone X, XS => 5.8 inch
                self.font = UIFont(name: name, size: size*1.09)
            case 896.0: //iphone XR => 6.1 inch  // iphone XS MAX => 6.5 inch
                self.font = UIFont(name: name, size: size*1.25)
            default:
                print("not IPhone height")
        }
        self.adjustsFontSizeToFitWidth = true
    }
}
