import Foundation
import UIKit

class LibSitCell : UIButton {
    
    let image : UIImageView = UIImageView()
    let nameLabel : UILabel = UILabel()
    let restSitLabel : UILabel = UILabel()
    let sliceLabel : UILabel = UILabel()
    let allSitLabel : UILabel = UILabel()
    
    //MARK: 열람실 이름
    var name : String? {
        didSet {
            //열람실 이름
            self.nameLabel.frame = CGRect(x: 10, y: 10, width: self.frame.width - 40, height: 40)
            self.nameLabel.textColor = UIColor.black
            self.nameLabel.fontToFit(name: "NotoSansCJKkr-Regular", size:17)
            self.nameLabel.text = name
            self.nameLabel.textAlignment = .left
            self.addSubview(nameLabel)
            // > 이미지
            image.frame = CGRect(x: self.frame.width-30, y: 20, width: 15, height: 15)
            image.image = UIImage(named: "LibraryWebButton.png")
            self.addSubview(image)
        }
    }
    //MARK: 남은 좌석
    var restSit : String? {
        didSet{
            //남은 좌석
            self.restSitLabel.frame = CGRect(x: 10, y: self.nameLabel.frame.maxY, width: 40, height: 30)
            self.restSitLabel.fontToFit(name: "NotoSansCJKkr-Regular", size:17)
            self.restSitLabel.text = restSit
            self.restSitLabel.textAlignment = .center
            self.restSitLabel.textColor = UIColor(hex:0x37BCE8)
            self.addSubview(restSitLabel)
            // / 레이블
            self.sliceLabel.frame = CGRect(x: self.restSitLabel.frame.maxX, y: self.nameLabel.frame.maxY, width: 20, height: 30)
            self.sliceLabel.textColor = UIColor.black
            self.sliceLabel.fontToFit(name: "NotoSansCJKkr-Regular", size:17)
            self.sliceLabel.text = "/"
            self.sliceLabel.textAlignment = .center
            self.addSubview(sliceLabel)
        }
    }
    //MARK: 전체 좌석
    var allSit : String? {
        didSet{
            //전체 좌석
            self.allSitLabel.frame = CGRect(x: self.sliceLabel.frame.maxX, y: self.nameLabel.frame.maxY, width: 40, height: 30)
            self.allSitLabel.textColor = UIColor.black
            self.allSitLabel.fontToFit(name: "NotoSansCJKkr-Regular", size:17)
            self.allSitLabel.text = allSit
            self.allSitLabel.textAlignment = .center
            self.addSubview(allSitLabel)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
