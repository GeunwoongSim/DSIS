import Foundation
import UIKit

/*
 * 메뉴를 통해서 뷰에 들어가는 화면
 * 교내지도 메뉴, 교내식당 메뉴, 디스스탑이즈 메뉴
 */

class MenuHomeViewController : UIViewController {
    
    let mapIcon = UIImageView()
    
    var pinImageString : String = "" {
        didSet {
            mapIcon.image = UIImage(named: "\(pinImageString).png")
        }
    }
    var menuString : [String] = []
    var viewTitle : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UICreate() //UI생성
    }
    // MARK: - UI생성
    private func UICreate(){
        self.view.backgroundColor = .white
        //배경이미지
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        imageView.image = UIImage(named: "MainBackground.png")
        self.view.addSubview(imageView)
        //뒤로가기버튼
        let backButton = UIButton()
        backButton.frame = CGRect(x: layoutMargin, y: statusBarHeight+navigationBarHeight/2, width: 40, height: 40)
        backButton.addTarget(self, action: #selector(self.backButtonTouch(sender:)), for: .touchUpInside)
        self.view.addSubview(backButton)
        //뒤로가기버튼 이미지 : 버튼에 이미지를 직접 씌우면 터치의 접근성이 떨어지기 때문에 이미지를 위에 올림
        let backButtonImage = UIImageView()
        backButtonImage.frame = CGRect(x: 10, y: 10, width: backButton.frame.width-20, height: backButton.frame.height-20)
        backButtonImage.image = UIImage(named:"BackButton.png")
        backButton.addSubview(backButtonImage)
        //타이틀바
        let viewName = UILabel()
        viewName.frame = CGRect(x: 0, y: statusBarHeight+navigationBarHeight/2, width: self.view.frame.width, height: navigationBarHeight)
        viewName.text = "\(self.viewTitle)"
        viewName.fontToFit(name: "NotoSansCJKkr-Bold", size: 30)
        viewName.textAlignment = .center
        viewName.textColor = .white
        self.view.addSubview(viewName)
        //핀 이미지
        mapIcon.frame = CGRect(x: self.view.frame.width/2 - viewWidthStandard*2.5, y: viewName.frame.maxY+20, width: viewWidthStandard*5, height: viewWidthStandard*5)
        self.view.addSubview(mapIcon)
        //위치별 버튼 - 승학,부민,구덕,한림생활관 등
        let menuButtonHeight : CGFloat = self.view.frame.height/6
        var menuButtonY : CGFloat = self.view.frame.height - homeIndicatorHeight - 3*menuButtonHeight - 100
        for index in 0..<self.menuString.count {
            let button = UIButton()
            button.tag = index
            button.frame = CGRect(x: 0, y: menuButtonY ,width: self.view.frame.width, height: menuButtonHeight)
            button.setTitle(self.menuString[index], for: .normal)
            button.titleLabel?.fontToFit(name:"NotoSansCJKkr-Bold",size:24)
            if index%2 == 0 {
                button.layer.addBorder([.top, .bottom], color: UIColor.white, width: 1.0)
            }
            button.addTarget(self, action: #selector(self.menuButtonTouch(sender:)), for: .touchUpInside)
            self.view.addSubview(button)
            menuButtonY += menuButtonHeight
        }
    }
    @objc func menuButtonTouch(sender:UIButton) { }
    
    @objc private func backButtonTouch(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}
