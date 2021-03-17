import Foundation
import UIKit

class busParseErrorView : UIView {
    func errorViewCreate(){
        self.backgroundColor = UIColor(hex:0x3D9DC7)
        let text1 = UILabel()
        text1.frame = CGRect(x: 0, y: 30, width: self.frame.width, height: 40)
        text1.text = "지금은 정보를 받아올 수 없습니다"
        text1.textAlignment = .center
        text1.font = UIFont(name:"NotoSansCJKkr-Regular",size:16)
        text1.textColor = .white
        self.addSubview(text1)
        let busIcon = UIImageView()
        busIcon.frame = CGRect(x: 0, y: text1.frame.maxY+60, width: 140, height: 140)
        busIcon.center = self.center
        busIcon.image = UIImage(named:"THISSTOPISIcon.png")
        self.addSubview(busIcon)
        let text2 = UILabel()
        text2.frame = CGRect(x: 0, y: self.frame.height - 160, width: self.frame.width - 100, height: 70)
        text2.center.x = self.center.x
        text2.layer.borderColor = UIColor.white.cgColor
        text2.layer.borderWidth = 1
        text2.numberOfLines = 0
        text2.text = "잠시 후 다시 시도해 주세요\n이용에 불편을 드려서 죄송합니다"
        text2.textAlignment = .center
        text2.textColor = .white
        text2.font = UIFont(name:"NotoSansCJKkr-Regular",size:16)
        self.addSubview(text2)
        let text3 = UILabel()
        text3.frame = CGRect(x: 0, y: self.frame.height - 50, width: self.frame.width, height: 40)
        text3.text = "디스스탑이즈"
        text3.textAlignment = .center
        text3.textColor = .white
        text3.font = UIFont(name:"NotoSansCJKkr-Regular",size:16)
        self.addSubview(text3)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.errorViewCreate()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
