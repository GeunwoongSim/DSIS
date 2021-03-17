
import Foundation
import UIKit
import Alamofire

class OpenSourceLicViewController : UIViewController {
    
    //MARK: Value
    let licencesData : Licences = Licences()
    
    //MARK: UICreate()
    func UICreate(){
        self.view.backgroundColor = UIColor.white
        //배경이미지
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: statusBarHeight+100)
        imageView.image = UIImage(named: "MinBackground.png")
        self.view.addSubview(imageView)
        //흰배경
        let viewBack = UIView()
        viewBack.frame = CGRect(x: 0, y: imageView.frame.maxY, width: view.frame.width, height: self.view.frame.height - imageView.frame.height)
        viewBack.backgroundColor = UIColor.white
        self.view.addSubview(viewBack)
        //뒤로가기
        let backButton = UIButton()
        backButton.frame = CGRect(x: layoutMargin, y: statusBarHeight+navigationBarHeight/2, width: 40, height: 40)
        backButton.addTarget(self, action: #selector(self.backButtonTouch(sender:)), for: .touchUpInside)
        self.view.addSubview(backButton)
        let backButtonImage = UIImageView()
        backButtonImage.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        backButtonImage.image = UIImage(named:"BackButton.png")
        backButton.addSubview(backButtonImage)
        //타이틀바
        let viewName = UILabel()
        viewName.frame = CGRect(x: backButton.frame.maxX+10, y: 0, width: view.frame.width-2*layoutMargin-100, height: navigationBarHeight)
        viewName.center.y = backButton.center.y
        viewName.text = "Open Source Licences"
        viewName.font = UIFont(name:"NotosansCJKkr-Bold",size:20)
        viewName.textAlignment = .center
        viewName.textColor = .white
        self.view.addSubview(viewName)
        //라이센스 스크롤뷰
        let licenseView = UITextView()
        licenseView.frame = CGRect(x: 0, y: imageView.frame.maxY, width: view.frame.width, height: self.view.frame.height - homeIndicatorHeight - imageView.frame.height )
        licenseView.backgroundColor = UIColor.white
        licenseView.textContainerInset = UIEdgeInsets(top: 10, left: 20, bottom: 30, right: 20)
        licenseView.font = UIFont(name: "NotoSansCJKkr-Regular", size: 16)
        self.view.addSubview(licenseView)
        //라이센스 내용
        let fontSize = UIFont(name:"NotoSansCJKkr-Bold",size:18)
        var value = ""
        for index in 0..<self.licencesData.openSourceName.count {
            value += self.licencesData.openSourceName[index] + "\n\n" + self.licencesData.openSourceLicense[index] + "\n\n"
        }
        let attributedStr = NSMutableAttributedString(string: value)
        for index in 0..<self.licencesData.openSourceName.count {
            attributedStr.addAttribute((kCTFontAttributeName as NSString) as NSAttributedString.Key, value: fontSize!, range: (value as NSString).range(of: self.self.licencesData.openSourceName[index]))
        }
        licenseView.attributedText = attributedStr
    }
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UICreate()
    }
    @objc func backButtonTouch(sender: UIButton) {
        print("backButtonTouch")
        self.navigationController?.popViewController(animated: true)
    }
}
