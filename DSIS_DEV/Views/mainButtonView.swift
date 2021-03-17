import Foundation
import UIKit

class mainButtonView : UIButton {
    let buttonLabel = UILabel()
    var buttonImageName : String? {
        didSet {
            self.setImage(UIImage(named:buttonImageName!), for: .normal)
        }
    }
    var buttonString : String? {
        didSet {
            self.buttonLabel.text = buttonString
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        buttonLabel.frame = CGRect(x:0,y:self.frame.height/5*4,width:self.frame.width,height:self.frame.height/5-5)
        buttonLabel.text = buttonString
        buttonLabel.textAlignment = .center
        buttonLabel.textColor = UIColor.white
        buttonLabel.fontToFit(name: "NotoSansCJKkr-Regular", size: 14)
        self.addSubview(buttonLabel)
        self.buttonStyle()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.buttonStyle()
    }
    
    fileprivate func buttonStyle() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 7
    }
}
