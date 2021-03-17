import Foundation
import UIKit
import Alamofire
import WebKit
import SafariServices
import SystemConfiguration
import Reachability

class MainHomeViewController : UIViewController,UIScrollViewDelegate {
    
    private let mainButtonLabel: [[String]] = [["캠퍼스 정보", "교내 지도", "개발자"], ["가상 대학", "학생 정보", "교내 식당"], ["학사 일정", "디스스탑이즈", "도서관"]]
    private let mainButtonImageNamed: [[String]] = [
        ["MainCampusInfo.png","MainMap.png","MainDeveloper.png"],
        ["MainCyberCampus.png","MainStudentInfo.png","MainCafeteria.png"],
        ["MainSchedule.png", "MainBus.png", "MainLibrary.png"]
    ]
    //Banner
    var bannerList: [banner] = []
    var bannerMaxIndex: Int = -1
    var timer: Timer?
    let bannerView = UIScrollView()
    //네크워크상태 확인
    private let reachability = try! Reachability()
    // MARK: - UI생성
    private func UICreate(){
        //push를 통했을때 뒤로가기 스와이프 사용
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        //배경
        self.view.backgroundColor = .white
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        imageView.image = UIImage(named: "MainBackground.png")
        self.view.addSubview(imageView)
        //로고
        let logoY : CGFloat = (self.view.frame.height - homeIndicatorHeight - bannerHeight - 18*viewWidthStandard) / 2
        let titleLogo = UIImageView()
        titleLogo.frame.size = CGSize(width: self.view.frame.width/3, height: self.view.frame.width/3)
        titleLogo.center.y = logoY
        titleLogo.center.x = self.view.center.x
        titleLogo.image = UIImage(named: "MainLogo.png")
        self.view.addSubview(titleLogo)
        //메뉴버튼
        let buttonLength : CGFloat = 5 * viewWidthStandard
        for buttonYIndex in 0..<mainButtonLabel.count {
            var buttonX : CGFloat = 1.5 * viewWidthStandard
            let buttonY : CGFloat = self.view.frame.height - homeIndicatorHeight - bannerHeight - 3 * viewWidthStandard - 3 * buttonLength + CGFloat(buttonYIndex) * (buttonLength + viewWidthStandard)
            for buttonXIndex in 0..<mainButtonLabel[buttonYIndex].count {
                let buttonFrame : CGRect = CGRect(x:buttonX,y:buttonY,width:buttonLength,height:buttonLength)
                buttonX += (buttonLength + viewWidthStandard)
                let mainMenuButton = mainButtonView(frame : buttonFrame)
                mainMenuButton.tag = buttonYIndex * 3 + buttonXIndex
                mainMenuButton.buttonString = mainButtonLabel[buttonYIndex][buttonXIndex]
                mainMenuButton.buttonImageName = mainButtonImageNamed[buttonYIndex][buttonXIndex]
                mainMenuButton.addTarget(self, action: #selector(self.mainButtonTouch(sender:)), for: .touchUpInside)
                self.view.addSubview(mainMenuButton)
            }
        }
        //배너
        bannerView.delegate = self
        bannerView.frame = CGRect(x: 0, y: self.view.frame.height - homeIndicatorHeight - bannerHeight, width: self.view.frame.width, height: bannerHeight)
        bannerView.backgroundColor = UIColor.white
        bannerView.isPagingEnabled = true
        bannerView.bounces = false
        bannerView.showsHorizontalScrollIndicator = false
        view.addSubview(bannerView)
    }
    // MARK: - 네트워크확인
    private func reachabilityCheck(){ //네트워크 확인
        //네트워크 확인 - wifi인지, 데이터 사용인지, 아무것도 안킨 상태인지
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            print("노티실행")
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    // MARK: - 버전확인
    private func versionCheck(){
        //버전 확인까지 넘어가면 네트워크는 확인안해도 됨
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else{ return }
        Alamofire.request(versionCheckURL).responseString{ response in
            if response.result.isSuccess {
                guard let dataString = String(data: response.data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue) ) else { return }
                let appVersionArr = version.components(separatedBy: [".","\n"])
                let webVersionArr = dataString.components(separatedBy: [".","\n"])
//                print("앱에서 받아온 버전 = \(appVersionArr)")
//                print("웹에서 받아온 버전 = \(webVersionArr)")
                let storeURL : URL = URL(string: "itms-apps://itunes.apple.com/app/apple-store/id1490702439")!
                if webVersionArr[0] == "-1" { //-1이 뜨면 웹은 살아있고 mysql이 죽은거임
                    print("mysql 문제")
                }
                else if appVersionArr[0] == webVersionArr[0] && appVersionArr[1] == webVersionArr[1] && appVersionArr[2] == webVersionArr[2]  { //최신버전
                    print("최신버전")
                    self.bannerInfoDown() //배너 다운
                }
                else if appVersionArr[0] == webVersionArr[0] && appVersionArr[1] == webVersionArr[1] && appVersionArr[2] != webVersionArr[2] {
                    print("추가 업데이트")
                    let AlertView = UIAlertController(title: "업데이트", message: "최신 업데이트가 있습니다.\n업데이트 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
                    let OK = UIAlertAction(title: "업데이트", style: UIAlertAction.Style.default) { (_: UIAlertAction) -> Void in
                        UIApplication.shared.open(storeURL, options: [:], completionHandler: nil)
                    }
                    let cancel = UIAlertAction(title: "나중에", style: UIAlertAction.Style.default) { (_: UIAlertAction) -> Void in
                        self.bannerInfoDown() //배너 다운
                    }
                    AlertView.addAction(OK)
                    AlertView.addAction(cancel)
                    self.present(AlertView, animated: true, completion: nil)
                }
                else if appVersionArr[0] != webVersionArr[0] || appVersionArr[1] != webVersionArr[1] {
                    print("필수 업데이트")
                    let AlertView = UIAlertController(title: "업데이트", message: "필수 업데이트가 있습니다.\n업데이트 하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
                    let OK = UIAlertAction(title: "업데이트", style: UIAlertAction.Style.default) { (_: UIAlertAction) -> Void in
                        UIApplication.shared.open(storeURL, options: [:], completionHandler: nil)
                    }
                    AlertView.addAction(OK)
                    self.present(AlertView, animated: true, completion: nil)
                }
            }
        }
    }
    // MARK: - 배너다운
    private func bannerInfoDown(){ //배너 다운
        //배너 다운 파트
        Alamofire.request(bannerURL).responseJSON { (response)in
        guard let data = response.data else {return}
        do {
            let bannerData = try JSONDecoder().decode(bannerInfo.self, from: data) //배너정보형태
            let max: Int = bannerData.result.count
            self.bannerMaxIndex = max + 2 //최대값 + 2로 설정(무한스크롤을 위해서)
            self.bannerList.append(bannerData.result[max-1])
            for index in 0..<max {
                self.bannerList.append(bannerData.result[index])
            }
            self.bannerList.append(bannerData.result[0])
            DispatchQueue.main.async {
                self.bannerView.contentSize.width = self.view.frame.width * CGFloat(max+2)
                for index in 0..<self.bannerList.count { //배너 이미지 받아오기
                    let bannerImage = UIImageView()
                    bannerImage.frame = CGRect(x: CGFloat(index)*self.view.frame.width, y: 0, width: self.view.frame.width, height: self.bannerView.frame.height)
                    self.bannerImageDown(view: bannerImage, url: "\(bannerImageDownURL)\(self.bannerList[index].name).\(self.bannerList[index].type)")
                    self.bannerView.addSubview(bannerImage)
                }
                self.bannerView.contentOffset.x = self.view.frame.width
                self.timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: {_ in //타이머를 설정하여 자동으로 스크롤가능하게
                    UIView.animate(withDuration: 1, animations: {self.bannerView.contentOffset.x += self.view.frame.width}) //애니메이션이 실행되는 동안에는 스크롤불가
                    let index: Int = Int(self.bannerView.contentOffset.x/self.view.frame.width)
                    if index == 0 {
                        self.bannerView.contentOffset.x = self.view.frame.width * CGFloat(self.bannerMaxIndex-2)
                    } else if index == self.bannerMaxIndex-1 {
                        self.bannerView.contentOffset.x = self.view.frame.width
                    }
                })
            }
            } catch let jsonErr {
                print("Error = \(jsonErr)")
            }
        }
    }
    func bannerImageDown(view: UIImageView, url: String) { //배너에 들어갈 이미지 다운
        guard let encoded = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let urlString = URL(string: encoded) else {return}
        URLSession.shared.dataTask(with: urlString) { (data, _, _) in
            guard let data = data else {return}
            DispatchQueue.main.async {
                view.image = UIImage(data: data)
            }
        }.resume()
    }
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad()")
        self.UICreate() //UI 생성
        self.reachabilityCheck() //네트워크 확인
    }
    // MARK: - 네트워크확인 오픈소스
    @objc func reachabilityChanged(note: Notification) { //네트워크 확인 오픈소스
      let reachability = note.object as! Reachability
      switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
            self.versionCheck() //버전 확인
        case .cellular:
            print("Reachable via Cellular")
            self.versionCheck() //버전 확인
        case .unavailable:
            print("Network not reachable")
            //기본 AlertView
            let AlertView = UIAlertController(title: "알림", message: "인터넷 연결상태가 좋지 않습니다.\n확인 후 다시 이용해주세요.", preferredStyle: UIAlertController.Style.alert)
            let OK = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_: UIAlertAction) -> Void in
                print("확인")
                self.reachabilityChanged(note: note)
            }
            AlertView.addAction(OK)
            self.present(AlertView, animated: true, completion: nil)
        default :
            break
        }
    }
    // MARK: - 메인 메뉴 버튼
    @objc func mainButtonTouch(sender: UIButton) { //메인 버튼 클릭
        switch sender.tag {
        case 0: //캠퍼스정보
            let vc = BoardHomeViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 1: //교내지도
            let vc = MapHomeViewController()
            vc.menuString = ["승학 캠퍼스", "부민 캠퍼스", "구덕 캠퍼스"]
            vc.viewTitle = "교내지도"
            self.navigationController?.pushViewController(vc, animated: true)
        case 2: //개발자 || 외박신청
            let vc = DevViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 3: //가상대학
            if let url = URL(string: cyberWebURL) {
                if #available(iOS 11.0, *) { //iOS 버전 11이상일때
                    let config = SFSafariViewController.Configuration()
                    config.entersReaderIfAvailable = true
                    let webview = SFSafariViewController(url: url, configuration: config)
                    present(webview, animated: true)
                }
            }
        case 4: //학생정보
            let vc = StudentInfoMainViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 5: //교내식당
            let vc = CafeHomeViewController()
            vc.menuString = ["승학 캠퍼스", "부민 캠퍼스", "한림 생활관"]
            vc.viewTitle = "교내식당"
            self.navigationController?.pushViewController(vc, animated: true)
        case 6: //학사일정
            let vc = CalendarViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 7: //디스스탑이즈
            let vc = ThisStopIsHomeViewController()
            vc.menuString = ["승학 캠퍼스", "부민 캠퍼스", "구덕 캠퍼스"]
            vc.viewTitle = "디스스탑이즈"
            self.navigationController?.pushViewController(vc, animated: true)
        case 8: //도서관
            let vc = LibraryViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    // MARK: - loadView, 공통변수 설정
    override func loadView() { //공통으로 쓰이는 변수값 설정 - 어플실행시 제일 처음으로 실행, loadView -> ViewDidLoad - >View WillApper
        super.loadView()
        //Common Value Update
        let screenHeight = UIScreen.main.bounds.size.height
        if screenHeight >= 812.0 { //아이폰X이상
            statusBarHeight = 44
            navigationBarHeight = 44
            homeIndicatorHeight = 34
            tabBarHeight = 49
            layoutMargin = 16
            phoneMode = 2
        }else if screenHeight <= 568.0 { //아이폰se이하
            statusBarHeight = 20
            navigationBarHeight = 44
            homeIndicatorHeight = 0
            tabBarHeight = 49
            layoutMargin = 16
            phoneMode = 3
        }else{ //그사이
            statusBarHeight = 20
            navigationBarHeight = 44
            homeIndicatorHeight = 0
            tabBarHeight = 49
            layoutMargin = 16
            phoneMode = 1
        }
        viewWidthStandard = view.frame.width/20
        bannerHeight = (120 * self.view.frame.width) / 600.0
    }
    override func viewWillAppear(_ animated: Bool) { //뷰가 올라올때 마다 실행
        self.navigationController?.isNavigationBarHidden = true
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {//스크롤하면 자동스크롤멈춤
        self.timer?.invalidate()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { //드래그 종료 후 반영
        let index: Int = Int(scrollView.contentOffset.x/view.frame.width)
        if index == 0 {
            self.bannerView.contentOffset.x = view.frame.width * CGFloat(self.bannerMaxIndex-2)
        } else if index == self.bannerMaxIndex-1 {
            self.bannerView.contentOffset.x = view.frame.width
        }
    }
}
