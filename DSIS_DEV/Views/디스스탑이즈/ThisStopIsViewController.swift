import Foundation
import UIKit
import Alamofire

class ThisStopIsViewController : UIViewController, UIScrollViewDelegate {
    //MARK: Value
    var mode : Int = -1 //0:승학, 1:부민, 2:구덕
    let ThisStopIsData : busData = busData()
    var busLocation : [UIButton] = []
    let menuBackground : UIScrollView = UIScrollView()
    var currentH : Int = -1
    var busCell : [cycleBusCell] = []
    
    //MARK: UICreate
    func UICreate(){
        self.view.backgroundColor = UIColor.white
        //배경이미지
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: statusBarHeight+130)
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
        viewName.text = "디스스탑이즈"
        viewName.font = UIFont(name:"NotosansCJKkr-Bold",size:30)
        viewName.textAlignment = .center
        viewName.textColor = .white
        view.addSubview(viewName)
        //캠퍼스위치 버튼
        let locationCount : CGFloat = CGFloat(ThisStopIsData.busCategoryString[mode].count)
        for index in 0..<ThisStopIsData.busCategoryString[mode].count {
            let locationButton = UIButton()
            locationButton.frame = CGRect(x: CGFloat(index)*view.frame.width/locationCount, y: imageView.frame.height - 50, width: view.frame.width/locationCount, height: 50)
            locationButton.tag = index
            locationButton.setTitle(ThisStopIsData.busCategoryString[mode][index], for: .normal)
            if index == 0 {
                locationButton.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Bold",size:18)
                locationButton.setTitleColor(UIColor.white, for: .normal)
            } else {
                locationButton.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Regular",size:18)
                locationButton.setTitleColor(UIColor(hex: 0x231815, alpha: 0.5), for: .normal)
            }
            locationButton.addTarget(self, action: #selector(self.busLocationTouch(sender:)), for: .touchUpInside)
            busLocation.append(locationButton)
            self.view.addSubview(locationButton)
        }
        //컨텐츠 내용 올라갈 스크롤뷰(가로)
        menuBackground.frame = CGRect(x: 0, y: imageView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - homeIndicatorHeight - imageView.frame.height)
        menuBackground.showsHorizontalScrollIndicator = false
        menuBackground.backgroundColor = UIColor(hex: 0xf9f7f7)
        menuBackground.contentSize.width = CGFloat(locationCount) * self.view.frame.width
        menuBackground.isPagingEnabled = true
        menuBackground.contentOffset.x = 0
        menuBackground.delegate = self
        menuBackground.tag = 4
        self.view.addSubview(menuBackground)
        for index in 0..<ThisStopIsData.busCategoryString[mode].count {
            let line = UIView()
            line.frame = CGRect(x: self.view.frame.width * CGFloat(index), y: 0, width: 1, height: menuBackground.frame.height)
            line.backgroundColor = UIColor.lightGray
            menuBackground.addSubview(line)
        }
    }
    //MARK: scrollView 스크롤(가로)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 4 {
            for button in busLocation { //lightGray로 색상 엎음
                button.setTitleColor(UIColor(hex: 0x231815, alpha: 0.5), for: .normal)
                button.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Regular",size:18)
            }
            let index: Int = Int(scrollView.contentOffset.x/view.frame.width)
            busLocation[index].setTitleColor(UIColor.white, for: .normal) //현재 페이지에 맞는 버스위치 색상 변경
            busLocation[index].titleLabel?.font = UIFont(name:"NotoSansCJKkr-Bold",size:18)
        }
    }
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentDayGet() //시간 받아오기
        self.UICreate() //기초 UI생성
        //각 화면 생성
        if self.mode == 0 || self.mode == 2 {
            self.loopBusViewCreate() //순환버스
        }
        self.studentBusViewCreate() //학생차량
        self.attendBusViewCreate() //통학차량
    }
    //MARK: 뒤로가기 버튼 함수
    @objc func backButtonTouch(sender: UIButton) {
        print("backButtonTouch")
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: 현재 시간 받아오기
    func currentDayGet() {
        let dateFormatter = DateFormatter() //날짜형식
        dateFormatter.dateFormat = "HH"
        currentH = (dateFormatter.string(from: Date()) as NSString).integerValue
    }
    //MARK: 순환버스뷰 생성
    func loopBusViewCreate(){
        //순환버스가 올라가는 스크롤뷰
        let baseView = UIScrollView()
        baseView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.menuBackground.frame.height)
        baseView.contentSize.height = CGFloat(self.ThisStopIsData.loopBusLocation[self.mode].count * 80)
        baseView.showsVerticalScrollIndicator = false
        self.menuBackground.addSubview(baseView)
        //새로고침 이미지
        let reloadImage: UIImage? = UIImage(named: "ReloadButton.png")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        //새로고침 버튼
        let reloadButton = UIButton()
        reloadButton.frame = CGRect(x: self.menuBackground.frame.width - 80, y: self.menuBackground.frame.height - 80, width: 60, height: 60)
        reloadButton.setImage(reloadImage, for: .normal)
        reloadButton.tintColor = UIColor(hex: 0x37BCE8)
        reloadButton.addTarget(self, action: #selector(reloadButtonTouch(sender:)), for: .touchUpInside)
        menuBackground.addSubview(reloadButton)
        //cell create
        for index in 0..<self.ThisStopIsData.loopBusLocation[self.mode].count {
            let cellFrame = CGRect(x: 0, y: 80*CGFloat(index), width: baseView.frame.width, height: 80)
            let cell = cycleBusCell(frame:cellFrame)
            cell.addTarget(self, action: #selector(self.busCellTouch(sender:)), for: .touchUpInside)
            cell.busTitle.text = self.ThisStopIsData.loopBusLocation[self.mode][index]
            baseView.addSubview(cell)
            switch index {
            case 0:
                cell.mode = 0
            case self.ThisStopIsData.loopBusLocation[self.mode].count-1:
                cell.mode = 2
            default :
                cell.mode = 1
            }
            self.busCell.append(cell)
        }
        if mode==0 && (currentH<7 || currentH>=23) {
            self.timeOutBus()
        }
        else if mode == 2 && (currentH<7 || currentH>=22){
            self.timeOutBus()
        }
        else{
            self.reloadButtonTouch(sender:nil)
        }
    }
    //MARK: 학생차량뷰 생성
    func studentBusViewCreate(){
        let studentBusFrame = self.mode == 1 ? CGRect(x: 0, y: 0, width: self.menuBackground.frame.width, height: self.menuBackground.frame.height) : CGRect(x: self.menuBackground.frame.width, y: 0, width: self.menuBackground.frame.width, height: self.menuBackground.frame.height)
        let studentBackground = studentBusView(frame: studentBusFrame)
        self.menuBackground.addSubview(studentBackground)
    }
    //MARK: 통학차량뷰 생성
    func attendBusViewCreate(){
        let studentBusFrame = self.mode == 1 ? CGRect(x: self.menuBackground.frame.width, y: 0, width: self.menuBackground.frame.width, height: self.menuBackground.frame.height) : CGRect(x: 2*self.menuBackground.frame.width, y: 0, width: self.menuBackground.frame.width, height: self.menuBackground.frame.height)
        let studentBackground = attendBusView(frame: studentBusFrame)
        self.menuBackground.addSubview(studentBackground)
    }
    //MARK: 새로고침 버튼 클릭
    @objc func reloadButtonTouch(sender:UIButton?){
        print("새로고침")
        let url = self.mode == 0 ? shBusInfoURL : gdBusInfoURL
        Alamofire.request(url).responseJSON { (response)in
            guard let data = response.data else {return}
            do {
                let busInfo = try JSONDecoder().decode(BusInfo.self, from: data)
                DispatchQueue.main.async {
                    if busInfo.bus_result[0].min == -1{ //파싱에러
                        self.dataParseError()
                    }
                    else{ //파싱에러 없음
                        for index in 0..<busInfo.bus_result.count {
                            self.busCell[index].bus_chk = busInfo.bus_result[index].bus_chk //버스가 있는지
                            self.busCell[index].min = busInfo.bus_result[index].min //남은 시간 -1 일 경우 파싱 에러
                            self.busCell[index].station = busInfo.bus_result[index].station //남은 정거장 수
                        }
                    }
                }
            } catch let jsonErr {
                print("Error = \(jsonErr)")
            }
        }
    }
    //MARK: Time out Bus View
    func timeOutBus(){
        let vFrame : CGRect = CGRect(x:0,y:0,width:self.menuBackground.frame.width,height:self.menuBackground.frame.height)
        let v : TimeOutBusView = TimeOutBusView(frame: vFrame)
        if mode == 0 {
            v.text2Content = "승학 순환 버스 운영시간\n 07:00~23:00"
        }
        else{
            v.text2Content = "구덕 순환 버스 운영시간\n 07:00~22:00"
        }
        self.menuBackground.addSubview(v)
    }
    //MARK: bus Data parse Error
    func dataParseError(){
        let errorViewFrame = CGRect(x: 0, y: 0, width: self.menuBackground.frame.width, height: self.menuBackground.frame.height)
        let errorView = busParseErrorView(frame: errorViewFrame)
        self.menuBackground.addSubview(errorView)
    }
    //MARK: busCellTouch
    @objc func busCellTouch(sender:cycleBusCell){
        if sender.station == 0 { // 대기 버스가 없음
            let AlertView = UIAlertController(title: "", message: "버스 도착정보가 없습니다.", preferredStyle: UIAlertController.Style.alert)
            let OK = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_: UIAlertAction) -> Void in
                print("확인")
            }
            AlertView.addAction(OK)
            self.present(AlertView, animated: true, completion: nil)
        }
        else{ // 대기 버스가 있음
            let AlertView = UIAlertController(title: "", message: "버스가 \(sender.station!)정류장 전에서 \(sender.min!)분후 도착예정입니다.", preferredStyle: UIAlertController.Style.alert)
            let OK = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_: UIAlertAction) -> Void in
                print("확인")
            }
            AlertView.addAction(OK)
            self.present(AlertView, animated: true, completion: nil)
        }
    }
    //MARK: 버스 종류 터치
    @objc func busLocationTouch(sender:UIButton){
        let currentPage: Int = Int(menuBackground.contentOffset.x / menuBackground.frame.width)
        if currentPage != sender.tag { //같은위치가 아닐때만 변경
            for button in busLocation {
                button.setTitleColor(UIColor(hex: 0x231815, alpha: 0.5), for: .normal)
                button.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Regular",size:18)
            }
            busLocation[sender.tag].setTitleColor(UIColor.white, for: .normal)
            busLocation[sender.tag].titleLabel?.font = UIFont(name:"NotoSansCJKkr-Bold",size:18)
            let moveIndex = sender.tag - currentPage
            UIView.animate(withDuration: 0.3, animations: {self.menuBackground.contentOffset.x+=CGFloat(moveIndex)*self.menuBackground.frame.width}, completion: nil)
        }
    }
}
