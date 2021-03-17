import Foundation
import UIKit
import Alamofire

class CallViewController : UIViewController, UITextFieldDelegate {
    
    //MARK: Value
    let buildingName : [String] = ["승학","부민","구덕"]
    var location : [UIButton] = []
    let callScrollView : UIScrollView = UIScrollView()
    let searchField = UITextField() //검색 필드
    var viewMode : Int = 0 // 0:승학, 1:부민, 2:구덕
    
    //MARK: Data
    var callNumberList: [[callNumber]] = Array(repeating: [], count: 3) //승학, 부민, 구덕 데이터(처음 뷰가 로드될때 저장 후 끌어다 씀)
    var callNumberViewList: [callNumber] = [] //보여줄 뷰 데이터
    
    //MARK: UICreate
    func UICreate(){
        self.view.backgroundColor = UIColor.white
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
        viewName.text = "연락처"
        viewName.font = UIFont(name:"NotosansCJKkr-Bold",size:30)
        viewName.textAlignment = .left
        viewName.textColor = .white
        view.addSubview(viewName)
        //검색 필드
        let searchBar = UIView()
        searchBar.frame = CGRect(x: 2*layoutMargin, y: viewName.frame.maxY+10, width: self.view.frame.width - 4*layoutMargin, height: 40)
        searchBar.layer.cornerRadius = 5
        searchBar.backgroundColor = UIColor(hex: 0x8FCBE3)
        view.addSubview(searchBar)
        let searchIcon = UIImageView()
        searchIcon.image = UIImage(named: "CampusCallListSearchIcon.png")
        searchIcon.frame = CGRect(x: 10, y: 10, width: searchBar.frame.height-20, height: searchBar.frame.height-20)
        searchBar.addSubview(searchIcon)
        searchField.frame = CGRect(x: searchIcon.frame.maxX+10, y: 0, width: searchBar.frame.width-searchIcon.frame.width-30, height: searchBar.frame.height)
        searchField.textColor = UIColor.black
        searchField.attributedPlaceholder = NSAttributedString(string: "검 색", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        searchField.tag = 1
        searchField.returnKeyType = .search
        searchField.textColor = .white
        searchField.font = UIFont(name: "NotosansCJKkr-Regular", size: 18)
        searchField.delegate = self
        searchField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        searchField.clearButtonMode = .whileEditing
        searchBar.addSubview(searchField)
        //건물위치 버튼
        let locationCount : CGFloat = CGFloat(self.buildingName.count)
        for index in 0..<self.buildingName.count {
            let locationButton = UIButton()
            locationButton.tag = index
            location.append(locationButton)
            locationButton.addTarget(self, action: #selector(self.locationTouch(sender:)), for: .touchUpInside)
            locationButton.frame = CGRect(x: CGFloat(index)*self.view.frame.width/locationCount, y: searchBar.frame.maxY+10, width: self.view.frame.width/locationCount, height: 30)
            locationButton.setTitle(self.buildingName[index], for: .normal)
            if index == 0 {
                locationButton.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Bold",size:18)
                locationButton.setTitleColor(UIColor.white, for: .normal)
            } else {
                locationButton.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Regular",size:18)
                locationButton.setTitleColor(UIColor(hex: 0x231815, alpha: 0.5), for: .normal)
            }
            self.view.addSubview(locationButton)
        }
        //전화번호가 올라가는 베이스 뷰(그림자 효과를 넣기 위해서 제작 - 일반 스크롤뷰는 그림자가 안먹힌다)
        let callBaseView = UIView()
        callBaseView.frame = CGRect(x: 1.5*layoutMargin, y: self.location[0].frame.maxY+10, width: self.view.frame.width - 3*layoutMargin, height: self.view.frame.height - homeIndicatorHeight - self.location[0].frame.maxY - 40)
        callBaseView.backgroundColor = UIColor.white
        callBaseView.layer.shadowColor = UIColor.lightGray.cgColor
        callBaseView.layer.shadowOpacity = 1
        callBaseView.layer.shadowRadius = 3
        callBaseView.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.view.addSubview(callBaseView)
        //실질적인 전화번호가 올라가는 스크롤 뷰
        self.callScrollView.frame = CGRect(x: 0, y: 0, width: callBaseView.frame.width, height: callBaseView.frame.height-80)
        self.callScrollView.backgroundColor = UIColor.white
        callBaseView.addSubview(self.callScrollView)
        let tipLabel = UILabel()
        tipLabel.frame = CGRect(x: 0, y: callBaseView.frame.height - 80, width: callBaseView.frame.width, height: 80)
        tipLabel.layer.addBorder([.top], color: UIColor(hex:0x108DBE), width: 1)
        tipLabel.text = "슬롯을 누르면 전화 연결이 됩니다."
        tipLabel.font = UIFont(name:"NotosansCJKkr-Regular",size:16)
        tipLabel.textColor = UIColor(hex:0x108DBE)
        tipLabel.textAlignment = .center
        callBaseView.addSubview(tipLabel)
    }
    //MARK: 연락처 Data 받아옴
    func callNumberDataGet(){
        Alamofire.request(callURL).responseJSON { (response)in
            guard let data = response.data else {return}
            do {
                let callInfo = try JSONDecoder().decode(callNumberInfo.self, from: data)
                for callIndex in 0..<callInfo.SeungHak.count { // 승학 정보
                    self.callNumberList[0].append(callInfo.SeungHak[callIndex])
                }
                for callIndex in 0..<callInfo.Bumin.count { // 부민 정보
                    self.callNumberList[1].append(callInfo.Bumin[callIndex])
                }
                for callIndex in 0..<callInfo.Gudeuk.count { //구덕 정보
                    self.callNumberList[2].append(callInfo.Gudeuk[callIndex])
                }
                DispatchQueue.main.async {
                    self.locationTouch(sender: self.location[0])
                }
            } catch let jsonErr {
                print("Error = \(jsonErr)")
            }
        }
    }
    //MARK: 스크롤뷰에 올라갈 셀 제작
    func scrollViewCellCreate(){
        //현재 보여지고 있는 뷰들 삭제
        for view in self.callScrollView.subviews {
            view.removeFromSuperview()
        }
        //새로운 뷰들 생성
        for index in 0..<self.callNumberViewList.count {
            let rect : CGRect = CGRect(x: 0, y: CGFloat(index)*60, width: self.callScrollView.frame.width, height: 60)
            let callButton = CallTableCell(frame: rect)
            callButton.organization.text = self.callNumberViewList[index].organization
            callButton.office.text = self.callNumberViewList[index].office
            callButton.number.text = self.callNumberViewList[index].number
            callButton.layer.addBorder([.bottom], color: UIColor.lightGray, width: 1)
            callButton.addTarget(self, action: #selector(self.buttonTouch(sender:)), for: .touchUpInside)
            self.callScrollView.addSubview(callButton)
        }
        self.callScrollView.contentSize.height = CGFloat(60 * self.callNumberViewList.count)
    }
    //MARK: location 버튼 클릭
    @objc func locationTouch(sender:UIButton){
        for button in location {
            button.setTitleColor(UIColor(hex: 0x231815, alpha: 0.5), for: .normal)
            button.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Regular",size:18)
        }
        self.location[sender.tag].setTitleColor(UIColor.white, for: .normal)
        self.location[sender.tag].titleLabel?.font = UIFont(name:"NotoSansCJKkr-Bold",size:18)
        self.viewMode = sender.tag
        //기존에 보여주던 리스트는 전부 지움
        self.callNumberViewList.removeAll()
        //뷰 생성을 위해 검색필드쪽 활용
        self.textFieldDidChange(textField: self.searchField)
        self.callScrollView.contentOffset.y = 0 //스크롤뷰 젤 위로 설정
    }
    //MARK: 텍스트필드 내용 변경일때
    @objc func textFieldDidChange(textField: UITextField) {
        self.callNumberViewList.removeAll()
        let str = textField.text ?? ""
        if str == ""{
            for value in self.callNumberList[self.viewMode]{
                self.callNumberViewList.append(value)
            }
        }
        else{
            for value in self.callNumberList[self.viewMode] {
                if value.organization.contains(str) {
                    self.callNumberViewList.append(value)
                } else if value.number.contains(str) {
                    self.callNumberViewList.append(value)
                }
            }
        }
        self.scrollViewCellCreate()
    }
    //MARK: 검색버튼 클릭시
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    //MARK: 키보드 외부클릭시 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //UI생성
        self.UICreate()
        //실질적인 데이터를 받아옴
        self.callNumberDataGet()
    }
    //MARK: 기타함수
    @objc func backButtonTouch(sender: UIButton) {
        print("backButtonTouch")
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: 전화번호 클릭
    @objc func buttonTouch(sender:CallTableCell){
        let AlertView = UIAlertController(title: "", message: "\(sender.organization.text!) \(sender.office.text!)입니다.\n연락하시겠습니까?", preferredStyle: UIAlertController.Style.alert)
        let OK = UIAlertAction(title: "확인", style: UIAlertAction.Style.default) { (_: UIAlertAction) -> Void in
            guard let phoneCallURL = URL(string: "tel://051-\(sender.number.text!)") else {return}
            let application: UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
        let Cancel = UIAlertAction(title: "취소", style: UIAlertAction.Style.cancel)
        AlertView.addAction(Cancel)
        AlertView.addAction(OK)
        self.present(AlertView, animated: true, completion: nil)
        
    }
}
