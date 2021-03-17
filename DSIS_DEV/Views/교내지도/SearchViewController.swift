import Foundation
import UIKit
import Alamofire

class SearchViewController : UIViewController,UITextFieldDelegate {

    //UI
    let callScrollView = UIScrollView() //전화번호부 목록이 올라가는 스크롤뷰

    //MARK: UI생성
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
        viewName.text = "강의실"
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
        let searchField = UITextField()
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
        //스크롤뷰
        let scrollBaseView = UIView()
        scrollBaseView.frame = CGRect(x: layoutMargin, y: searchBar.frame.maxY + 20, width: self.view.frame.width - 2*layoutMargin, height: self.view.frame.height - searchBar.frame.maxY - homeIndicatorHeight - 50)
        scrollBaseView.backgroundColor = UIColor.white
        scrollBaseView.layer.shadowColor = UIColor.lightGray.cgColor
        scrollBaseView.layer.shadowOpacity = 1
        scrollBaseView.layer.shadowRadius = 3
        scrollBaseView.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.addSubview(scrollBaseView)
        callScrollView.frame = CGRect(x: 0, y: 0, width: scrollBaseView.frame.width, height: scrollBaseView.frame.height)
        scrollBaseView.addSubview(callScrollView)
    }
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UICreate() //UI생성
        //지도 정보 가져오기(전체)
        callNumberDataGet(str:"")
    }
    //MARK: 검색한 내용 가져오기
    func callNumberDataGet(str:String) {
        let url = "\(classroomInfoURL)\(extensionName)?search=\(str)"
        guard let encoded = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let urlString = URL(string: encoded) else {return}
        Alamofire.request(urlString).responseJSON { (response)in
            guard let data = response.data else {return}
            do {
                let callInfo = try JSONDecoder().decode(RoomSearchInfo.self, from: data)
                DispatchQueue.main.async {
                    self.scrollViewCreate(value: callInfo.result_class_list)
                }
            } catch let jsonErr {
                print("Error = \(jsonErr)")
            }
        }
    }
    //MARK: scrollView Cell Create
    func scrollViewCreate(value:[RoomInfo]) {
        for view in self.callScrollView.subviews {
            view.removeFromSuperview()
        }
        let cellHeight : CGFloat = 60
        for callIndex in 0..<value.count {
            let callCell = SearchTableCell()
            callCell.frame = CGRect(x: 0, y: CGFloat(callIndex)*cellHeight, width: self.callScrollView.frame.width, height: cellHeight)
            callCell.location = value[callIndex].location
            callCell.name = value[callIndex].name
            callCell.layer.addBorder([.bottom], color: UIColor.lightGray, width: 1)
            self.callScrollView.addSubview(callCell)
        }
        //스크롤뷰 높이 설정
        self.callScrollView.contentSize.height = cellHeight*CGFloat(value.count)
    }
    //MARK: 기타 함수들
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        callNumberDataGet(str: textField.text ?? "") //검색된 일부 지도 정보 가져오기
        return true
    }
    @objc func textFieldDidChange(textField: UITextField) {
        callNumberDataGet(str: textField.text ?? "")
    }
    @objc func backButtonTouch(sender: UIButton) {
        print("backButtonTouch")
        self.navigationController?.popViewController(animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
