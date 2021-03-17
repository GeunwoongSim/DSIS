import Foundation
import UIKit

class ClubCell : UIButton {
    
    var clubName : String?
    var bannerImage : UIImage? {
        didSet{
            self.bannerImageView.image = bannerImage
        }
    }
    let bannerImageView : UIImageView = UIImageView()
    var posterPath : String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addBorder([.bottom], color: UIColor.lightGray, width: 1)
        bannerImageView.frame = CGRect(x: 10, y: 10, width: self.frame.width-20, height: self.frame.height-20)
        self.addSubview(bannerImageView)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
