import Foundation
import UIKit
import SafariServices

class BoardHomeViewController : UIViewController {
    
    private let boardButtonImageName : [[String]] = [["CampusAnnounce.png", "CampusAlba.png"],["CampusCallList.png", "CampusBachelor.png"],["CampusCircle.png", "CampusEvent.png"]]
    
    //MARK: UICreate
    func UICreate(){
        self.view.backgroundColor = UIColor.white
        //배경이미지
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: self.view.frame.height)
        imageView.image = UIImage(named: "MinBackground.png")
        self.view.addSubview(imageView)
        //뒤로가기
        let backButton = UIButton()
        backButton.frame = CGRect(x: layoutMargin, y: statusBarHeight+navigationBarHeight/2, width: 40, height: 40)
        backButton.addTarget(self, action: #selector(self.backButtonTouch(sender:)), for: .touchUpInside)
        view.addSubview(backButton)
        let backButtonImage = UIImageView()
        backButtonImage.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        backButtonImage.image = UIImage(named:"BackButton.png")
        backButton.addSubview(backButtonImage)
        //타이틀바
        let viewName = UILabel()
        viewName.frame = CGRect(x: backButton.frame.maxX+10, y: 0, width: view.frame.width-layoutMargin-20, height: navigationBarHeight)
        viewName.center.y = backButton.center.y
        viewName.text = "Campus information"
        viewName.fontToFit(name: "NotoSansCJKkr-Regular", size: 25)
        viewName.textAlignment = .left
        viewName.textColor = .white
        view.addSubview(viewName)
        //게시판 버튼
        let buttonWidth : CGFloat = self.view.frame.width/2 - 1.5*layoutMargin - 10
        for yIndex in 0..<self.boardButtonImageName.count{
            for xIndex in 0..<self.boardButtonImageName[yIndex].count {
                let buttonView : UIView = UIView()
                buttonView.frame = CGRect(x: 1.5*layoutMargin+CGFloat(xIndex)*(buttonWidth+20), y: viewName.frame.maxY + 40 + CGFloat(yIndex)*(buttonWidth+10), width: buttonWidth, height: buttonWidth)
                buttonView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
                buttonView.layer.cornerRadius = 20
                self.view.addSubview(buttonView)
                let button = UIButton()
                button.tag = yIndex*2 + xIndex
                button.frame = CGRect(x: 8, y: 8, width: buttonView.frame.width-16, height: buttonView.frame.height-16)
                button.backgroundColor = .white
                button.layer.cornerRadius = 15
                button.addTarget(self, action: #selector(self.menuButtonTouch(sender:)), for: .touchUpInside)
                buttonView.addSubview(button)
                let buttonImage = UIImageView()
                buttonImage.frame = CGRect(x: 0, y: 0, width: button.frame.width, height: button.frame.height)
                buttonImage.image = UIImage(named: self.boardButtonImageName[yIndex][xIndex])
                button.addSubview(buttonImage)
            }
        }
    }
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UICreate()
    }
    //MARK: 기타함수
    @objc func backButtonTouch(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: 각 버튼 클릭함수
    @objc func menuButtonTouch(sender:UIButton){
        if #available(iOS 11.0, *){
            switch sender.tag {
            case 0 : //공지사항
                if let url = URL(string: "\(mainWebURL)/gzSub_007001.aspx") {
                    let config = SFSafariViewController.Configuration()
                    config.entersReaderIfAvailable = true
                    let webview = SFSafariViewController(url: url, configuration: config)
                    present(webview, animated: true)
                }
            case 1 : //알바정보
                if let url = URL(string: "\(mainWebURL)/gzSub_007004005.aspx") {
                    let config = SFSafariViewController.Configuration()
                    config.entersReaderIfAvailable = true
                    let webview = SFSafariViewController(url: url, configuration: config)
                    present(webview, animated: true)
                }
            case 2 : //전화번호부
                let vc = CallViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            case 3 : //학사공지
                if let url = URL(string: "\(mainWebURL)/gzSub_007011.aspx") {
                    let config = SFSafariViewController.Configuration()
                    config.entersReaderIfAvailable = true
                    let webview = SFSafariViewController(url: url, configuration: config)
                    present(webview, animated: true)
                }
            case 4 : //동아리정보
                let vc = ClubHomeViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            case 5 : //이벤트
                let vc = EventViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            default :
                break
            }
        }
        else{
            print("iOS 11 이상의 OS 필요")
        }
    }
}
