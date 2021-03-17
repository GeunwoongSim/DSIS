import Foundation
import UIKit
class CallTableCell : UIButton{
    
    let organization = UILabel()
    let office = UILabel()
    let number = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //부서
        self.organization.frame = CGRect(x: layoutMargin, y: 5, width: self.frame.width/3*2, height: (self.frame.height-15)/2)
        self.organization.text = "organization"
        self.organization.textColor = UIColor(hex:0x37BCE8)
        self.organization.font = UIFont(name:"NotoSansCJKkr-Regular",size:15)
        self.addSubview(organization)
        //위치
        self.office.frame = CGRect(x: layoutMargin, y: self.organization.frame.maxY+5, width: (self.frame.width/3-2*layoutMargin)*2, height: (self.frame.height-15)/2)
        self.office.text = "office"
        self.office.textColor = UIColor.black
        self.office.font = UIFont(name:"NotoSansCJKkr-Regular",size:15)
        self.addSubview(office)
        //전화번호
        self.number.frame = CGRect(x: self.organization.frame.maxX, y: 5, width: self.frame.width/3-2*layoutMargin, height: self.frame.height-10)
        self.number.text = "number"
        self.number.textColor = UIColor.black
        self.number.font = UIFont(name:"NotoSansCJKkr-Regular",size:18)
        self.addSubview(number)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
