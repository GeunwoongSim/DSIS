import Foundation
import UIKit

class SearchTableCell : UIView {
    
    var location : String? {
        didSet{
            let locationLabel = UILabel()
            locationLabel.frame = CGRect(x: layoutMargin, y: 5, width: self.frame.width-2*layoutMargin, height: self.frame.height/2-5)
            locationLabel.text = location
            locationLabel.textColor = UIColor(hex:0x37BCE8)
            locationLabel.font = UIFont(name:"NotoSansCJKkr-Bold",size:14)
            self.addSubview(locationLabel)
        }
    }
    var name : String? {
        didSet{
            //이름
            let nameLabel = UILabel()
            nameLabel.frame = CGRect(x: layoutMargin, y: self.frame.height/2, width: self.frame.width-2*layoutMargin, height: self.frame.height/2-5)
            nameLabel.text = name
            nameLabel.textColor = UIColor.black
            nameLabel.font = UIFont(name:"NotoSansCJKkr-Regular",size:14)
            self.addSubview(nameLabel)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
