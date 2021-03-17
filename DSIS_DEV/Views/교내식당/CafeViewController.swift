import Foundation
import UIKit
import Alamofire

class CafeViewController : UIViewController,UIScrollViewDelegate {
    
    //MARK: Value
    var cafeData : CafeModel = CafeModel()
    var cafeLocation : [UIButton] = []
    let dateLabel : UILabel = UILabel() // x월 x일
    let cafeMenuScr : UIScrollView = UIScrollView()
    var cafeMenuArray: [UIScrollView] = []
    var menuInfoArray : [[BuildingMenu]] = Array(repeating: [], count: 3)
    //날짜
    var year: Int = 2019
    var month: Int = 1
    var day: Int = 1
    var currentYear: Int = 2019
    var currentMonth: Int = 1
    var currentDay: Int = 1
    var cafeInfoIndex : Int = 1 //오늘: 1, 어제: -1, 다음날: +1
    
    //MARK: UICreate
    func UICreate(){
        self.view.backgroundColor = UIColor.white
        //배경이미지
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: statusBarHeight+150)
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
        //타이틀바 - 캠퍼스 명
        let viewName = UILabel()
        viewName.frame = CGRect(x: backButton.frame.maxX+10, y: 0, width: view.frame.width-2*layoutMargin-100, height: navigationBarHeight)
        viewName.center.y = backButton.center.y
        viewName.text = cafeData.cafeModeString[cafeData.cafeMode]
        viewName.font = UIFont(name:"NotosansCJKkr-Bold",size:30)
        viewName.textAlignment = .center
        viewName.textColor = .white
        view.addSubview(viewName)
        //식단표 레이블
        let viewSubName = UILabel()
        viewSubName.frame = CGRect(x: viewName.frame.minX, y: viewName.frame.maxY, width: viewName.frame.width, height: 30)
        viewSubName.text = "식단표"
        viewSubName.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        viewSubName.textAlignment = .center
        viewSubName.textColor = .white
        view.addSubview(viewSubName)
        //식당 위치 버튼
        let locationCount : CGFloat = CGFloat(cafeData.buildingName[cafeData.cafeMode].count)
        for index in 0..<cafeData.buildingName[cafeData.cafeMode].count {
            let cafeButton = UIButton()
            cafeButton.tag = index
            cafeLocation.append(cafeButton)
            cafeButton.addTarget(self, action: #selector(cafeLocationTouch(sender:)), for: .touchUpInside)
            cafeButton.frame = CGRect(x: CGFloat(index)*view.frame.width/locationCount, y: imageView.frame.height - 50, width: view.frame.width/locationCount, height: 50)
            cafeButton.setTitle(cafeData.buildingName[cafeData.cafeMode][index], for: .normal)
            if index == 0 {
                cafeButton.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Bold",size:18)
                cafeButton.setTitleColor(UIColor.white, for: .normal)
            } else {
                cafeButton.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Regular",size:18)
                cafeButton.setTitleColor(UIColor(hex: 0x231815, alpha: 0.5), for: .normal)
            }
            view.addSubview(cafeButton)
        }
        //버튼 날짜가 올라가는 뷰
        let buttonMenu = UIView()
        buttonMenu.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        buttonMenu.backgroundColor = UIColor(hex: 0xf9f7f7)
        viewBack.addSubview(buttonMenu)
        //날짜
        dateLabel.frame = CGRect(x: buttonMenu.frame.width/3, y: 0, width: buttonMenu.frame.width/3, height: buttonMenu.frame.height)
        dateLabel.textColor = UIColor(hex: 0x565656)
        dateLabel.font = UIFont(name: "NotoSansCJKkr-Bold", size: 18)
        dateLabel.textAlignment = .center
        dateLabel.backgroundColor = UIColor.clear
        buttonMenu.addSubview(dateLabel)
        if month<10 && day<10 {
            dateLabel.text = "0\(currentMonth)월 0\(currentDay)일"
        } else if month<10 && day>10 {
            dateLabel.text = "0\(currentMonth)월 \(currentDay)일"
        } else if month>10 && day<10 {
            dateLabel.text = "\(currentMonth)월 0\(currentDay)일"
        } else {
            dateLabel.text = "\(currentMonth)월 \(currentDay)일"
        }
        //이전날
        let preButton = UIButton()
        preButton.frame = CGRect(x: buttonMenu.frame.width/3 - 60, y: 10, width: 40, height: 40)
        preButton.addTarget(self, action: #selector(self.preButtonTouch(sender:)), for: .touchUpInside)
        buttonMenu.addSubview(preButton)
        let preButtonImage = UIImageView()
        preButtonImage.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        preButtonImage.image = UIImage(named:"CafePreButton.png")
        preButton.addSubview(preButtonImage)
        //다음날
        let nextButton = UIButton()
        nextButton.frame = CGRect(x: 2*buttonMenu.frame.width/3, y: 10, width: 40, height: 40)
        nextButton.addTarget(self, action: #selector(self.nextButtonTouch(sender:)), for: .touchUpInside)
        buttonMenu.addSubview(nextButton)
        let nextButtonImage = UIImageView()
        nextButtonImage.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        nextButtonImage.image = UIImage(named:"CafeNextButton.png")
        nextButton.addSubview(nextButtonImage)
        //메뉴판 올라가는 가로스크롤뷰
        cafeMenuScr.delegate = self
        cafeMenuScr.frame = CGRect(x: 0, y: buttonMenu.frame.height, width: view.frame.width, height: viewBack.frame.height - buttonMenu.frame.height - homeIndicatorHeight)
        cafeMenuScr.isPagingEnabled = true
        cafeMenuScr.showsHorizontalScrollIndicator = false
        cafeMenuScr.contentSize.width = view.frame.width*locationCount
        cafeMenuScr.backgroundColor = UIColor(hex: 0xf9f7f7)
        cafeMenuScr.tag = 4
        viewBack.addSubview(cafeMenuScr)
        for index in 0..<cafeData.buildingName[cafeData.cafeMode].count {
            let scrollView = UIScrollView()
            scrollView.frame = CGRect(x: cafeMenuScr.frame.width * CGFloat(index), y: 0, width: cafeMenuScr.frame.width, height: cafeMenuScr.frame.height)
            scrollView.delegate = self
            scrollView.tag = index
            scrollView.backgroundColor = UIColor(hex: 0xf9f7f7)
            cafeMenuArray.append(scrollView)
            cafeMenuScr.addSubview(scrollView)
        }
    }
    //MARK: 카페위치 버튼 클릭
    @objc func cafeLocationTouch(sender:UIButton){
        let currentPage: Int = Int(cafeMenuScr.contentOffset.x / cafeMenuScr.frame.width) //현재 어디 건물인지 (0~2 || 0~1)
        if currentPage != sender.tag { //같은위치가 아닐때만 변경
            for button in cafeLocation {
                button.setTitleColor(UIColor(hex: 0x231815, alpha: 0.5), for: .normal)
                button.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Regular",size:18)
            }
            cafeLocation[sender.tag].setTitleColor(UIColor.white, for: .normal)
            cafeLocation[sender.tag].titleLabel?.font = UIFont(name:"NotoSansCJKkr-Bold",size:18)
            let moveIndex = sender.tag - currentPage
            print("moveIndex = \(moveIndex)")
            UIView.animate(withDuration: 0.3, animations: {self.cafeMenuScr.contentOffset.x+=CGFloat(moveIndex)*self.cafeMenuScr.frame.width}, completion: nil)
        }
    }
    //MARK: scrollView 스크롤(가로)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 4 {
            for button in cafeLocation { //lightGray로 색상 엎음
                button.setTitleColor(UIColor(hex: 0x231815, alpha: 0.5), for: .normal)
                button.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Regular",size:18)
            }
            let index: Int = Int(scrollView.contentOffset.x/view.frame.width)
            cafeLocation[index].setTitleColor(UIColor.white, for: .normal) //현재 페이지에 맞는 버스위치 색상 변경
            cafeLocation[index].titleLabel?.font = UIFont(name:"NotoSansCJKkr-Bold",size:18)
        }
    }
    //MARK: 오늘 날짜 받아오기
    func todayGet() {
        let dateFormatter = DateFormatter() //날짜 형식
        dateFormatter.dateFormat = "yyyy"
        currentYear = (dateFormatter.string(from: Date()) as NSString).integerValue
        dateFormatter.dateFormat = "MM"
        currentMonth = (dateFormatter.string(from: Date()) as NSString).integerValue
        dateFormatter.dateFormat = "dd"
        currentDay = (dateFormatter.string(from: Date()) as NSString).integerValue
        year = currentYear
        month = currentMonth
        day = currentDay
    }
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.todayGet()
        self.UICreate()
        //데이터 받아오기
        self.cafeDataGet()
    }
    //MARK: 식단표 생성 - menuCreate
    func menuCreate(menuScrollView: UIScrollView, menuNumber: Int) { //menuView: 메뉴가 올라가는 스크롤뷰, menuNumber: 1,2,3(교수회관,학생회관,도서관)등 건물이름
        print("menuCreate실행")
        for view in menuScrollView.subviews { //메뉴 UI 초기화
            view.removeFromSuperview()
        }
        var menuViewY : CGFloat = 20
        for index in 0..<3 {
            var menuString : String = "" //메뉴판내용을 저장하는 변수
            switch index {
            case 0:
                menuString = self.menuInfoArray[menuNumber][cafeInfoIndex].setMenu
            case 1:
                menuString = self.menuInfoArray[menuNumber][cafeInfoIndex].oneMenu
            case 2:
                menuString = self.menuInfoArray[menuNumber][cafeInfoIndex].snackMenu
            default:
                return
            }
            //세트(조식)메뉴판
            let menuArray = menuString.components(separatedBy: "\r\n") //받아온 메뉴를 띄어쓰기를 기준으로 자름
            let menuView = UIView() //메뉴를 올릴 UI
            if menuArray.count < 3 {
                menuView.frame = CGRect(x: 4*layoutMargin, y: menuViewY, width: menuScrollView.frame.width-8*layoutMargin, height: 150)
            } else {
                menuView.frame = CGRect(x: 4*layoutMargin, y: menuViewY, width: menuScrollView.frame.width-8*layoutMargin, height: 30+35*CGFloat(menuArray.count))
            }
            menuViewY += menuView.frame.height + 20
            menuView.layer.shadowColor = UIColor.lightGray.cgColor
            menuView.layer.shadowOpacity = 1
            menuView.layer.shadowRadius = 7
            menuView.layer.shadowOffset = .zero
            menuView.backgroundColor = .white
            menuScrollView.addSubview(menuView)
            //정식(조식) 제목
            let menuTitle = UILabel()
            menuTitle.frame = CGRect(x: 0, y: 0, width: menuView.frame.width, height: 40)
            menuTitle.text = cafeData.subTitleString[cafeData.cafeMode][index]
            menuTitle.textAlignment = .center
            menuTitle.textColor = UIColor(hex: 0x108DBE)
            menuTitle.font = UIFont(name: "NotoSansCJKkr-Bold", size: 20)
            menuView.addSubview(menuTitle)
            //setMenuText
            let menuText = UITextView()
            menuText.isEditable = false
            menuText.isScrollEnabled = false
            menuText.isSelectable = false
            menuText.frame = CGRect(x: 0, y: menuTitle.frame.maxY, width: menuView.frame.width, height: menuView.frame.height - menuTitle.frame.height)
            (menuArray.count == 1 && menuArray[0].count == 0) ? (menuText.text = "\n메뉴가 없습니다") : (menuText.text = menuString)
            menuText.backgroundColor = UIColor.clear
            menuText.textAlignment = .center
            menuText.textColor = UIColor(hex: 0x565656)
            menuText.fontToFit(name: "NotoSansCJKkr-Regular", size: 16)
            menuView.addSubview(menuText)
        }
        menuScrollView.contentSize.height = menuViewY
    }
    //MARK: 식단표 정보 받아오기 - cafeDataGet()
    func cafeDataGet() {
        Alamofire.request("\(cafeInfoURL)\(extensionName)").responseJSON { (response)in
            guard let data = response.data else {return}
            do {
                let cafeInfo = try JSONDecoder().decode(CafeteriaInfo.self, from: data)
                for cafeIndex in 0..<cafeInfo.cafeteria_professor_sh.count {
                    switch self.cafeData.cafeMode {
                    case 0: //승학
                        self.menuInfoArray[0].append(cafeInfo.cafeteria_professor_sh[cafeIndex])
                        self.menuInfoArray[1].append(cafeInfo.cafeteria_student_sh[cafeIndex])
                        self.menuInfoArray[2].append(cafeInfo.cafeteria_library_sh[cafeIndex])
                    case 1: //부민
                        self.menuInfoArray[0].append(cafeInfo.cafeteria_professor_bm[cafeIndex])
                        self.menuInfoArray[1].append(cafeInfo.cafeteria_student_bm[cafeIndex])
                    case 2: //기숙사
                        self.menuInfoArray[0].append(cafeInfo.cafeteria_domitory_sh[cafeIndex])
                        self.menuInfoArray[1].append(cafeInfo.cafeteria_domitory_bm[cafeIndex])
                    default:
                        return
                    }
                }
                DispatchQueue.main.async {
                    self.menuCreate(menuScrollView: self.cafeMenuArray[0], menuNumber: 0)
                    self.menuCreate(menuScrollView: self.cafeMenuArray[1], menuNumber: 1)
                    if self.cafeData.cafeMode == 0 {
                        self.menuCreate(menuScrollView: self.cafeMenuArray[2], menuNumber: 2)
                    }
                }
            } catch let jsonErr {
                print("Error = \(jsonErr)")
            }
        }
    }
    //MARK: 뒤로가기 버튼 함수
    @objc func backButtonTouch(sender: UIButton) {
        print("backButtonTouch")
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: 이전날 버튼
    @objc func preButtonTouch(sender: UIButton) {
        print("preButtonTouch")
        if cafeInfoIndex > 0 {
            cafeInfoIndex = cafeInfoIndex - 1
            if(month == 1) {
                if(day == 1) {
                    year = year - 1
                    month = 12
                    day = 31
                } else {
                    day = day - 1
                }
            } else if(month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
                if(day == 1) {
                    month = month - 1
                    day = 30
                } else {
                    day  = day - 1
                }
            } else if(month == 2 || month == 4 || month == 6 || month == 9 || month == 11) {
                if(day == 1) {
                    month = month - 1
                    day = 31
                } else {
                    day  = day - 1
                }
            } else if(month == 3) {
                if(day == 1) {
                    if(year%4 == 0 && year%400 != 0) {
                        month = month - 1
                        day = 29
                    }//윤년일때
                    else {
                        month = month - 1
                        day = 28
                    }//윤년이아닐때
                } else {
                    day = day - 1
                }
            }
            if month<10 && day<10 {
                dateLabel.text = "0\(month)월 0\(day)일"
            } else if month<10 && day>10 {
                dateLabel.text = "0\(month)월 \(day)일"
            } else if month>10 && day<10 {
                dateLabel.text = "\(month)월 0\(day)일"
            } else {
                dateLabel.text = "\(month)월 \(day)일"
            }
            self.menuCreate(menuScrollView: self.cafeMenuArray[0], menuNumber: 0)
            self.menuCreate(menuScrollView: self.cafeMenuArray[1], menuNumber: 1)
            if self.cafeData.cafeMode == 0 {
                self.menuCreate(menuScrollView: self.cafeMenuArray[2], menuNumber: 2)
            }
        }
    }
    //MARK: 다음날 버튼
    @objc func nextButtonTouch(sender: UIButton) {
        if(cafeInfoIndex<7) {
            cafeInfoIndex = cafeInfoIndex+1
            if(month == 4 || month == 6 || month == 9 || month == 11) {
                if(day == 30) {
                    month = month + 1
                    day = 1
                }//마지막날
                else {
                    day = day + 1
                }
            } else if(month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10) {
                if(day == 31) {
                    month = month + 1
                    day = 1
                } else {
                    day = day + 1
                }
            } else if(month == 12) {
                if(day == 31) {
                    month = 1
                    day = 1
                } else {
                    day = day + 1
                }
            } else if(month == 2) {
                if(year%4 == 0 && year%400 != 0) {
                    if(day == 29) {
                        month = month + 1
                        day = 1
                    } else {
                        day = day + 1
                    }
                } //윤년
                else {
                    if(day == 28) {
                        month = month + 1
                        day = 1
                    } else {
                        day = day + 1
                    }
                }//윤년이 아닐때
            }
            if month<10 && day<10 {
                dateLabel.text = "0\(month)월 0\(day)일"
            } else if month<10 && day>10 {
                dateLabel.text = "0\(month)월 \(day)일"
            } else if month>10 && day<10 {
                dateLabel.text = "\(month)월 0\(day)일"
            } else {
                dateLabel.text = "\(month)월 \(day)일"
            }
            self.menuCreate(menuScrollView: self.cafeMenuArray[0], menuNumber: 0)
            self.menuCreate(menuScrollView: self.cafeMenuArray[1], menuNumber: 1)
            if self.cafeData.cafeMode == 0 {
                self.menuCreate(menuScrollView: self.cafeMenuArray[2], menuNumber: 2)
            }
        }
    }
}
