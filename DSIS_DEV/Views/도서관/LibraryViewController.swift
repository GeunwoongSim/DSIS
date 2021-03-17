import Foundation
import UIKit
import Alamofire
import SafariServices

class LibraryViewController : UIViewController {
    
    //value
    let viewButton : [UIButton] = [UIButton(),UIButton()]
    let reloadButton : UIButton = UIButton()
    let sitBaseView = UIView()
    //도서관 좌석 수 버튼
    var libButtonArray : [LibSitCell] = []
    
    //indicator value
    let indicatorView = UIActivityIndicatorView()
    
    //MARK: UICreate
    private func UICreate(){
        self.view.backgroundColor = .white
        //배경이미지
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: statusBarHeight+200)
        imageView.image = UIImage(named: "MinBackground.png")
        self.view.addSubview(imageView)
        //흰배경
        let viewBack = UIView()
        viewBack.frame = CGRect(x: 0, y: imageView.frame.maxY, width: view.frame.width, height: self.view.frame.height - imageView.frame.height)
        viewBack.backgroundColor = UIColor(hex: 0xF9F7F7)
        self.view.addSubview(viewBack)
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
        viewName.text = "도서관"
        viewName.font = UIFont(name:"NotosansCJKkr-Bold",size:30)
        viewName.textAlignment = .left
        viewName.textColor = .white
        view.addSubview(viewName)
        //열람실현황 레이블
        let viewSubName = UILabel()
        viewSubName.frame = CGRect(x: viewName.frame.minX, y: viewName.frame.maxY, width: viewName.frame.width, height: 30)
        viewSubName.text = "열람실 좌석 현황"
        viewSubName.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        viewSubName.textColor = .white
        view.addSubview(viewSubName)
        //새로고침 버튼
        reloadButton.tag = 0 //0이면 승학 1이면 부민
        reloadButton.frame = CGRect(x: view.frame.width-layoutMargin-45, y: 0, width: 35, height: 35)
        reloadButton.center.y = viewName.center.y
        reloadButton.setImage(UIImage(named: "ReloadButton.png"), for: .normal)
        reloadButton.addTarget(self, action: #selector(self.reloadButtonClick(sender:)), for: .touchUpInside)
        self.view.addSubview(reloadButton)
        //승학버튼
        viewButton[0].frame = CGRect(x: layoutMargin, y: viewSubName.frame.maxY, width: self.view.frame.width/2 - layoutMargin, height: 30)
        viewButton[0].setTitle("승 학", for: .normal)
        viewButton[0].setTitleColor(UIColor.white, for: .normal)
        viewButton[0].titleLabel?.font = UIFont(name: "NotoSansCJKkr-Bold", size: 20)
        viewButton[0].tag = 0
        viewButton[0].addTarget(self, action: #selector(self.libraryListButtonTouch(sender:)), for: .touchUpInside)
        self.view.addSubview(viewButton[0])
        //부민버튼
        viewButton[1].frame = CGRect(x: viewButton[0].frame.maxX, y: viewSubName.frame.maxY, width: self.view.frame.width/2 - layoutMargin, height: 30)
        viewButton[1].setTitle("부 민", for: .normal)
        viewButton[1].setTitleColor(UIColor(hex: 0x231815, alpha: 0.5), for: .normal)
        viewButton[1].titleLabel?.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        viewButton[1].tag = 1
        viewButton[1].addTarget(self, action: #selector(self.libraryListButtonTouch(sender:)), for: .touchUpInside)
        self.view.addSubview(viewButton[1])
        //도서관 베이스 뷰
        let libBaseView = UIView() //도서관 베이스 뷰
        libBaseView.frame = CGRect(x: layoutMargin, y: viewButton[0].frame.maxY + 10, width: self.view.frame.width - 2*layoutMargin, height: self.view.frame.height - viewButton[0].frame.maxY - homeIndicatorHeight - 40)
        libBaseView.backgroundColor = UIColor.white
        libBaseView.layer.shadowColor = UIColor.lightGray.cgColor
        libBaseView.layer.shadowOpacity = 1
        libBaseView.layer.shadowRadius = 3
        libBaseView.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.addSubview(libBaseView)
        //좌석 베이스 뷰
        sitBaseView.frame = CGRect(x: 0, y: 0, width: libBaseView.frame.width, height: libBaseView.frame.height - 80)
        sitBaseView.backgroundColor = UIColor.white
        libBaseView.addSubview(sitBaseView)
        //모바일 도서관 버튼
        let mLibButton = UIButton()
        mLibButton.frame = CGRect(x: 0, y: libBaseView.frame.height - 80, width: libBaseView.frame.width, height: 80)
        mLibButton.backgroundColor = UIColor.white
        mLibButton.setTitle("도서관 모바일 홈", for: .normal)
        mLibButton.setTitleColor(UIColor(hex: 0x108DBE), for: .normal)
        mLibButton.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Regular",size:18)
        mLibButton.addTarget(self, action: #selector(self.mobileButtonTouch(sender:)), for: .touchUpInside)
        mLibButton.layer.addBorder([.top], color: UIColor(hex: 0x108DBE), width: 1)
        libBaseView.addSubview(mLibButton)
        //indicator 설정
        indicatorView.frame = CGRect(x: libBaseView.frame.width/2-50, y: sitBaseView.frame.height/2-50, width: 100, height: 100)
        indicatorView.backgroundColor = UIColor.clear
        indicatorView.style = .large
        indicatorView.color = UIColor.gray
        libBaseView.addSubview(indicatorView)
    }
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UICreate()
        //좌석표 생성
        libraryListButtonTouch(sender: self.viewButton[0])
    }
    //MARK: 새로고침함수
    @objc func reloadButtonClick(sender: UIButton) {
        self.libraryListButtonTouch(sender:self.viewButton[sender.tag])
    }
    //MARK: 모바일도서관함수
    @objc func mobileButtonTouch(sender: UIButton) {
        if let url = URL(string: mobileLibraryURL) {
            if #available(iOS 11.0, *) { //iOS 버전 11이상일때
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                let webview = SFSafariViewController(url: url, configuration: config)
                present(webview, animated: true)
            } else { //11미만 일때
                // Fallback on earlier versions
            }
        }
    }
    //MARK: 기타함수
    @objc func backButtonTouch(sender: UIButton) {
        print("backButtonTouch")
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: 건물 버튼 클릭(승학, 부민)
    @objc func libraryListButtonTouch(sender: UIButton) {
        //뷰 초기화
        for view in self.sitBaseView.subviews {
            view.removeFromSuperview()
        }
        self.libButtonArray.removeAll()
        //색상 번경
        for view in self.viewButton {
            view.setTitleColor(UIColor(hex: 0x231815, alpha: 0.5), for: .normal)
            view.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        }
        // 클릭색상 변경
        self.viewButton[sender.tag].setTitleColor(UIColor.white, for: .normal)
        self.viewButton[sender.tag].titleLabel?.font = UIFont(name: "NotoSansCJKkr-Bold", size: 20)
        //필요한 변수 선언
        let sitButtonHeight : CGFloat = self.sitBaseView.frame.height/4 //버튼높이
        let sitButtonWidth : CGFloat = self.sitBaseView.frame.width/2
        var startIndex : Int = -1 //웹에 접근하기 위한 시작 인덱스
        var finishIndex : Int = -1 //웹에 접근하기 위한 마지막 인덱스
        if sender.tag == 0 {
            startIndex = 0
            finishIndex = 7
            self.reloadButton.tag = 0
        }else{
            startIndex = 7
            finishIndex = 15
            self.reloadButton.tag = 1
        }
        //좌석수 버튼 생성
        for index in startIndex..<finishIndex {
            //열람실 버튼
            let button = LibSitCell()
            button.backgroundColor = UIColor.white
            sender.tag == 0 ? (button.tag = index+1) : (button.tag = index + 7)
            button.addTarget(self, action: #selector(self.libraryButtonTouch(sender:)), for: .touchUpInside)
            if (index-startIndex)%2 == 0 {
                button.frame = CGRect(x: 0, y: CGFloat((index-startIndex)/2)*sitButtonHeight, width: sitButtonWidth, height: sitButtonHeight)
                button.layer.addBorder([.right], color: UIColor.lightGray, width: 1)
            }else{
                button.frame = CGRect(x: sitButtonWidth, y: CGFloat((index-startIndex)/2)*sitButtonHeight, width: sitButtonWidth, height: sitButtonHeight)
            }
            if index-startIndex < 6 { //끝에 2개를 제외하고는 밑에 볼더 추가
                button.layer.addBorder([.bottom], color: UIColor.lightGray, width: 1)
            }
            self.sitBaseView.addSubview(button)
            self.libButtonArray.append(button)
        }
        //자리 데이터 받아오기
        libraryDataGet(startIndex: startIndex, finishIndex: finishIndex)
    }
    //MARK: 도서관 자리수 받아오기
    func libraryDataGet(startIndex: Int, finishIndex: Int) {
        //인디케이터 on
        self.indicatorView.isHidden = false
        indicatorView.startAnimating()
        //정보 받아오기
        Alamofire.request("\(libraryInfoURL)\(extensionName)").responseJSON { (response)in
            //정보를 받아왔으니 인디케이터 off
            self.indicatorView.stopAnimating()
            //데이터 다루기
            guard let data = response.data else {return}
            do {
                let libraryData = try JSONDecoder().decode(libraryInfo.self, from: data)
                DispatchQueue.main.async {
                    for index in startIndex..<finishIndex {
                        let nameArray = libraryData.result[index].Lname.components(separatedBy: " ")
                        var name: String = ""
                        for strIndex in 1..<nameArray.count {
                            name = name + nameArray[strIndex]
                        }
                        self.libButtonArray[index-startIndex].name = name
                        self.libButtonArray[index-startIndex].restSit = libraryData.result[index].Restsit
                        self.libButtonArray[index-startIndex].allSit = libraryData.result[index].Allsit
                    }
                }
            } catch let jsonErr {
                print("Error = \(jsonErr)")
            }
        }
    }
    //MARK: 좌석 버튼 클릭
    @objc func libraryButtonTouch(sender:LibSitCell){
        if let url = URL(string: "\(librarySeatURL)\(sender.tag)") {
            if #available(iOS 11.0, *) { //iOS 버전 11이상일때
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                let webview = SFSafariViewController(url: url, configuration: config)
                present(webview, animated: true)
            } else { //11미만 일때
                // Fallback on earlier versions
            }
        }
    }
}
