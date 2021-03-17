import Foundation
import UIKit
class devListCell : UIView {
    let nameLabel = UILabel()
    var name : String? {
        didSet{
            nameLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height/3)
            nameLabel.text = name
            nameLabel.textColor = UIColor.white
            nameLabel.textAlignment = .center
            nameLabel.backgroundColor = UIColor(hex: 0xF9F7F7, alpha: 0.5)
            nameLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
            self.addSubview(nameLabel)
        }
    }
    var position : String? {
        didSet{
            self.nameLabel.text! += " (\(position!))"
        }
    }
    var period : String? {
        didSet{
            let periodLabel = UILabel()
            periodLabel.frame = CGRect(x: 0, y: self.frame.height/3*2, width: self.frame.width, height: self.frame.height/3)
            periodLabel.text = "활동기간 \(period!)"
            periodLabel.textColor = UIColor.white
            periodLabel.textAlignment = .center
            periodLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
            self.addSubview(periodLabel)
        }
    }
    var team : String? {
        didSet{
            let teamLabel = UILabel()
            teamLabel.frame = CGRect(x: 0, y: self.frame.height/3, width: self.frame.width, height: self.frame.height/3)
            teamLabel.text = "소 속 \(team!)"
            teamLabel.textColor = UIColor.white
            teamLabel.textAlignment = .center
            teamLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
            self.addSubview(teamLabel)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
