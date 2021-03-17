import Foundation
import UIKit
import WebKit
import Alamofire

class MapDetailViewController : UIViewController, UIScrollViewDelegate{
    
    var buildingName: String = ""
    var buildingNumber: String = ""
    var buildingImage: Int = -1
    var buildingString: String = ""
    //UI
    var checkCircle: [UIView] = []
    let infoView: UIImageView = UIImageView() //상세정보 웹뷰
    var infoCheck: Bool = false //상세정보가 열려있는지
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UICreate()
    }
    
    //MARK: UI생성
    func UICreate() {
        view.backgroundColor = .white
        //배경이미지
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        imageView.image = UIImage(named: "MainBackground.png")
        view.addSubview(imageView)
        //네비게이션바
        let navigationBar = UIView()
        navigationBar.frame = CGRect(x: 0, y: statusBarHeight, width: view.frame.width, height: navigationBarHeight+15)
        navigationBar.backgroundColor = naviBarBackgroundColor
        view.addSubview(navigationBar)
        //뒤로가기버튼
        let backButton = UIButton()
        backButton.frame = CGRect(x: layoutMargin, y: navigationBarHeight/2-20, width: 40, height: 40)
        backButton.addTarget(self, action: #selector(self.backButtonTouch(sender:)), for: .touchUpInside)
        navigationBar.addSubview(backButton)
        let backButtonImage = UIImageView()
        backButtonImage.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        backButtonImage.image = UIImage(named:"BackButton.png")
        backButton.addSubview(backButtonImage)
        //타이틀바
        let viewName = UILabel()
        viewName.frame = CGRect(x: backButton.frame.maxX, y: statusBarHeight, width: view.frame.width - 2*layoutMargin-navigationBarHeight, height: navigationBarHeight)
        viewName.text = buildingName
        viewName.fontToFit(name: "NotoSancCJKkr-Regular", size: 20)
        viewName.textAlignment = .left
        viewName.textColor = .white
        view.addSubview(viewName)
        //건물 층 표현 동그라미
        for circleIndex in 0..<buildingImage {
            let circle = UIView()
            self.checkCircle.append(circle)
            let circleX: CGFloat = view.frame.width/2 - CGFloat(buildingImage)/2*15 + CGFloat(15*circleIndex)
            circle.frame = CGRect(x: circleX, y: statusBarHeight+navigationBarHeight + 2.5, width: 10, height: 10)
            circle.backgroundColor = UIColor.clear
            circle.layer.borderWidth = 1
            circle.layer.borderColor = UIColor.lightGray.cgColor
            circle.layer.cornerRadius = 5
            view.addSubview(circle)
        }
        self.checkCircle[0].backgroundColor = UIColor.white
        //건물 도면
        let scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: statusBarHeight+navigationBarHeight+15, width: view.frame.width, height: view.frame.height/2)
        scrollView.backgroundColor = UIColor.clear
        scrollView.contentSize.width = view.frame.width * CGFloat(buildingImage)
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
        //Map
        for index in 0..<buildingImage {
            //건물도면 베이스 뷰
            let baseWebView = UIView()
            baseWebView.frame = CGRect(x: layoutMargin+CGFloat(index)*view.frame.width, y: layoutMargin, width: view.frame.width-2*layoutMargin, height: scrollView.frame.height-2*layoutMargin)
            baseWebView.backgroundColor = naviBarBackgroundColor
            scrollView.addSubview(baseWebView)
            self.floorMap(baseView: baseWebView, index: index) //층 이미지정보 불러오기
        }
        //상세정보 버튼
        let infoButton = UIButton()
        infoButton.setTitle("실번호/실명 (touch)", for: .normal)
        infoButton.setTitleColor(UIColor.white, for: .normal)
        infoButton.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Regular",size:14)
        infoButton.frame = CGRect(x: 0, y: view.frame.height-navigationBarHeight-homeIndicatorHeight, width: view.frame.width, height: navigationBarHeight)
        infoButton.backgroundColor = UIColor(hex:0x565656,alpha: 0.5)
        infoButton.addTarget(self, action: #selector(self.infoButtonTouch(sender:)), for: .touchUpInside)
        self.view.addSubview(infoButton)
        //상세정보 뷰
        let infoViewHeight : CGFloat = view.frame.height - scrollView.frame.maxY - navigationBarHeight - homeIndicatorHeight
        infoView.frame = CGRect(x: 0, y: infoButton.frame.maxY, width: view.frame.width, height: infoViewHeight)
        infoView.contentMode = .scaleToFill
        infoView.backgroundColor = UIColor(hex:0xE8E5DD)
        //상세정보 뷰 이미지 정보 받아오기
        let url: String = "\(mapInfoURL)\(buildingString)/\(buildingNumber)/info/0.png"
        guard let encoded = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let urlString = URL(string: encoded) else {return}
        Alamofire.request(urlString).responseData(completionHandler: { (data) in
            guard let data = data.data else { return }
            DispatchQueue.main.async {
                self.infoView.image = UIImage(data: data)
            }
        })
        view.addSubview(infoView)
        //safe area
        let safeArea = UIView()
        safeArea.backgroundColor = UIColor.white
        safeArea.frame = CGRect(x: 0, y: view.frame.height-homeIndicatorHeight, width: view.frame.width, height: homeIndicatorHeight)
        view.addSubview(safeArea)
    }
    //MARK: 층 이미지 받아오기
    func floorMap(baseView:UIView, index:Int){
        let url: String  = "\(mapInfoURL)\(buildingString)/\(buildingNumber)/Originals/\(index).png"
        guard let encoded = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else {return} //웹주소 인코딩해줌
        guard let urlString = URL(string: encoded) else {return}
        Alamofire.request(urlString).responseData(completionHandler: { (data) in
            guard let data = data.data else { return }
            DispatchQueue.main.async {
                let imageView = UIImageView()
                imageView.contentMode = .scaleToFill
                imageView.frame = CGRect(x: 10, y: 10, width: baseView.frame.width-20, height: baseView.frame.height-20)
                imageView.image = UIImage(data: data)
                baseView.addSubview(imageView)
            }
        })
    }
    //MARK: 층 상세정보 열기
    @objc func infoButtonTouch(sender: UIButton) {
        if(self.infoCheck) { //열려있음
            UIView.animate(withDuration: 0.5, animations: {
                self.infoView.frame.origin.y += self.infoView.frame.height
                sender.frame.origin.y += self.infoView.frame.height
            })
        } else {//닫혀있음
            UIView.animate(withDuration: 0.5, animations: {
                self.infoView.frame.origin.y -= self.infoView.frame.height
                sender.frame.origin.y -= self.infoView.frame.height
            })
        }
        self.infoCheck.toggle()
    }
    @objc func backButtonTouch(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: 층 정보 드래그
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for circle in self.checkCircle {
            circle.backgroundColor = UIColor.clear
            circle.layer.borderColor = UIColor.lightGray.cgColor
        }
        let index: Int = Int(scrollView.contentOffset.x/view.frame.width)
        self.checkCircle[index].backgroundColor = UIColor.white
        self.checkCircle[index].layer.borderColor = UIColor.white.cgColor
        //이미지 불러오기
        let url: String = "\(mapInfoURL)\(buildingString)/\(buildingNumber)/info/\(index).png"
        guard let encoded = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let urlString = URL(string: encoded) else {return}
        Alamofire.request(urlString).responseData(completionHandler: { (data) in
            guard let data = data.data else { return }
            DispatchQueue.main.async {
                self.infoView.image = UIImage(data: data)
            }
        })
    }
}
