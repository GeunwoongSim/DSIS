import Foundation
import UIKit
import Alamofire

class ClubHomeViewController : UIViewController,UIScrollViewDelegate {
    
    //MARK: Value
    let categoryString : [[String]] = [["전체","문예1","문예2","봉사"],["종교","체육","학술1","학술2"]]
    var category : [UIButton] = []
    let clubBaseView : UIScrollView = UIScrollView() //가로 스크롤뷰
    var clubArray : [[club]] = Array(repeating: [], count: 8) // 0 : 전체, 1~7 카테고리
    
    //MARK: UICreate
    func UICreate(){
        self.view.backgroundColor = UIColor.white
        //배경이미지
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: statusBarHeight+100)
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
        viewName.frame = CGRect(x: backButton.frame.maxX+10, y: 0, width: view.frame.width-2*layoutMargin-100, height: navigationBarHeight)
        viewName.center.y = backButton.center.y
        viewName.text = "동아리"
        viewName.font = UIFont(name:"NotosansCJKkr-Bold",size:30)
        viewName.textAlignment = .center
        viewName.textColor = .white
        view.addSubview(viewName)
        for yIndex in 0..<self.categoryString.count {
            for xIndex in 0..<self.categoryString[yIndex].count {
                let categoryButton = UIButton()
                categoryButton.frame = CGRect(x: CGFloat(xIndex)*self.view.frame.width/4, y: imageView.frame.maxY+CGFloat(yIndex)*50, width: self.view.frame.width/4, height: 50)
                categoryButton.tag = 4*yIndex+xIndex
                categoryButton.backgroundColor = UIColor(hex: 0xF9F7F7)
                categoryButton.addTarget(self, action: #selector(categoryTouch(sender:)), for: .touchUpInside)
                category.append(categoryButton)
                categoryButton.setTitle(self.categoryString[yIndex][xIndex], for: .normal)
                if yIndex == 0 && xIndex == 0 {
                    categoryButton.setTitleColor(UIColor(hex: 0x108DBE), for: .normal)
                    categoryButton.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Bold",size:18)
                } else {
                    categoryButton.setTitleColor(UIColor(hex: 0x231815, alpha: 0.5), for: .normal)
                    categoryButton.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Regular",size:18)
                }
                self.view.addSubview(categoryButton)
                if xIndex != self.categoryString[yIndex].count-1 {
                    categoryButton.layer.addBorder([.right], color: UIColor.lightGray, width: 1)
                }
                categoryButton.layer.addBorder([.bottom], color: UIColor.lightGray, width: 1)
            }
        }
        //가로 스크롤뷰
        clubBaseView.frame = CGRect(x: 0, y: self.category[self.category.count-1].frame.maxY, width: self.view.frame.width, height: self.view.frame.height - homeIndicatorHeight - self.category[self.category.count-1].frame.maxY)
        clubBaseView.isPagingEnabled = true
        clubBaseView.contentSize.width = view.frame.width*8
        clubBaseView.backgroundColor = UIColor(hex: 0xf9f7f7)
        clubBaseView.delegate = self
        clubBaseView.tag = 10
        self.view.addSubview(clubBaseView)
    }
    //MARK: 동아리 정보 가져오기
    func clubDataGet(){
        Alamofire.request(clubURL).responseJSON { (response)in
            guard let data = response.data else {return}
            do {
                let clubInfo = try JSONDecoder().decode(ClubInfo.self, from: data)
                for clubContent in clubInfo.club {
                    guard let cateNumber : Int = Int(clubContent.depart) else {return}
                    self.clubArray[cateNumber].append(clubContent) //카테고리에 맡게 append
                    self.clubArray[0].append(clubContent) //전체 카테고리에 append
                }
                DispatchQueue.main.async {
                    self.categoryScrollCreate()
                }
            } catch let jsonErr {
                print("Error = \(jsonErr)")
            }
        }
    }
    //MARK: 카테고리에 맞는 스크롤뷰 생성
    func categoryScrollCreate(){
        let height : CGFloat = 100
        for cateIndex in 0..<self.clubArray.count {
            //각 화면의 왼쪽에 라인 생성
            let line = UIView()
            line.frame = CGRect(x: CGFloat(cateIndex)*self.view.frame.width-0.5, y: 0, width: 1, height: self.clubBaseView.frame.height)
            line.backgroundColor = UIColor.lightGray
            self.clubBaseView.addSubview(line)
            //해당 카테고리의 스크롤뷰
            let scrollView = UIScrollView()
            scrollView.showsVerticalScrollIndicator = false
            scrollView.frame = CGRect(x: CGFloat(cateIndex)*self.view.frame.width, y: 0, width: self.view.frame.width, height: self.clubBaseView.frame.height)
            scrollView.contentSize.height = CGFloat(self.clubArray[cateIndex].count)*height
            self.clubBaseView.addSubview(scrollView)
            //동아리 내용 채우기
            if self.clubArray[cateIndex].count == 0 { //해당 카테고리의 동아리 없음
                let clubLabel = UILabel()
                clubLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80)
                clubLabel.text = "해당 분과 동아리가 없습니다"
                clubLabel.font = UIFont(name:"NotoSansCJKkr-Regular",size:18)
                clubLabel.textAlignment = .center
                clubLabel.textColor = UIColor.black
                scrollView.addSubview(clubLabel)
            }
            else{
                for clubIndex in 0..<self.clubArray[cateIndex].count {
                    let buttonFrame : CGRect = CGRect(x: 0, y: CGFloat(clubIndex)*height, width: self.view.frame.width, height: height)
                    let button = ClubCell(frame : buttonFrame)
                    button.addTarget(self, action: #selector(self.bannerTouch(sender:)), for: .touchUpInside)
                    button.clubName = clubArray[cateIndex][clubIndex].name
                    scrollView.addSubview(button)
                    var path : String = clubArray[cateIndex][clubIndex].banner
                    path.remove(at: path.index(path.startIndex, offsetBy: 0)) //"."을 잘라낸 문자열
                    let bannerPath : String = "\(clubInfoURL)\(path)"
                    bannerImageDown(view: button, url: bannerPath)
                    path = clubArray[cateIndex][clubIndex].poster
                    path.remove(at: path.index(path.startIndex, offsetBy: 0)) //"."을 잘라낸 문자열
                    let posterPath = "\(clubInfoURL)\(path)"
                    button.posterPath = posterPath
                }
            }
        }
        let line = UIView() //가장 오른쪽 뷰의 오른쪽에 라인 생성
        line.frame = CGRect(x: CGFloat(self.clubArray.count)*self.view.frame.width-0.5, y: 0, width: 1, height: self.clubBaseView.frame.height)
        line.backgroundColor = UIColor.lightGray
        self.clubBaseView.addSubview(line)
    }
    //MARK: 배너 클릭 함수
    @objc func bannerTouch(sender: ClubCell){
        let vc = ClubDetailViewController()
        vc.posterName = sender.clubName
        vc.posterPath = sender.posterPath
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    //MARK: 배너이미지다운
    func bannerImageDown(view: ClubCell, url: String) {
        guard let encoded = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let urlString = URL(string: encoded) else {return}
        Alamofire.request(urlString).responseData(completionHandler: { (data) in
            guard let data = data.data else { return }
            DispatchQueue.main.async {
                view.bannerImage = UIImage(data:data)
            }
        })
    }
    //MARK: 카테고리 클릭 함수
    @objc func categoryTouch(sender:UIButton){
        let currentPage: Int = Int(clubBaseView.contentOffset.x / clubBaseView.frame.width) //0~7 현재 페이지
        if currentPage != sender.tag {
            for button in self.category {
                button.setTitleColor(UIColor(hex: 0x231815, alpha: 0.5), for: .normal)
                button.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Regular",size:18)
            }
            self.category[sender.tag].setTitleColor(UIColor(hex: 0x108DBE), for: .normal)
            self.category[sender.tag].titleLabel?.font = UIFont(name:"NotoSansCJKkr-Bold",size:18)
            let moveIndex = sender.tag - currentPage
            UIView.animate(withDuration: 0, animations: {self.clubBaseView.contentOffset.x+=CGFloat(moveIndex)*self.clubBaseView.frame.width}, completion: nil)
        }
    }
    //MARK: 스크롤뷰(가로) 스크롤
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag == 10 {
            for button in category { //lightGray로 색상 엎음
                button.setTitleColor(UIColor(hex: 0x231815, alpha: 0.5), for: .normal)
                button.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Regular",size:18)
            }
            let index: Int = Int(scrollView.contentOffset.x/view.frame.width)
            category[index].setTitleColor(UIColor(hex: 0x108DBE), for: .normal) //현재 페이지에 맞는 버스위치색상 변경
            category[index].titleLabel?.font = UIFont(name:"NotoSansCJKkr-Bold",size:18)
        }
    }
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UICreate()
        self.clubDataGet()
    }
    //MARK: 뒤로가기버튼 함수
    @objc func backButtonTouch(sender: UIButton) {
        print("backButtonTouch")
        self.navigationController?.popViewController(animated: true)
    }
}
