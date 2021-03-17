import Foundation
import UIKit
import Alamofire

class DevViewController : UIViewController {
    //MARK: Value
    let scrollView : UIScrollView = UIScrollView()
    var devList : [[member_result]] = Array(repeating: [], count: 1000)
    var devButtonCheck : [Bool] = Array(repeating: false, count: 1000)
    var devButtonList : [UIButton] = []
    var devBackList : [UIView] = []
    var devIndex : Int = 1 // 몇기까지 생성되었는지
    //MARK: UICreate
    func UICreate(){
        self.view.backgroundColor = UIColor.white
        //배경이미지
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        imageView.image = UIImage(named: "MainBackground.png")
        self.view.addSubview(imageView)
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
        viewName.text = "TEAM MEMBERS"
        viewName.font = UIFont(name:"NotosansCJKkr-Bold",size:30)
        viewName.textAlignment = .center
        viewName.textColor = .white
        viewName.backgroundColor = UIColor.clear
        self.view.addSubview(viewName)
        //스크롤뷰
        scrollView.frame = CGRect(x: 0, y: viewName.frame.maxY+20, width: view.frame.width, height: self.view.frame.height - homeIndicatorHeight - viewName.frame.maxY - 80)
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
        //오픈소스 버튼
        let openSourceButton = UIButton()
        openSourceButton.frame = CGRect(x: 2*layoutMargin, y: scrollView.frame.maxY, width: self.view.frame.width - 4*layoutMargin, height: 60)
        openSourceButton.setTitle("Open Source Licenses", for: .normal)
        openSourceButton.setTitleColor(UIColor.white, for: .normal)
        openSourceButton.contentHorizontalAlignment = .right
        openSourceButton.addTarget(self, action: #selector(self.openSourceButtonTouch(sender:)), for: .touchUpInside)
        self.view.addSubview(openSourceButton)
    }
    //MARK: 개발자 정보를 받아옴
    func devDataGet(){
        Alamofire.request("\(memberInfoURL)\(extensionName)").responseJSON{ (response) in
            guard let data = response.data else { return }
            do{
                let devInfo = try JSONDecoder().decode(DevInfo.self, from: data)
                //데이터 저장
                for x in devInfo.member_result{
                    guard let number: Int = Int(x.group_num) else { return }
                    self.devList[number].append(x) //우선 기존코드처럼 배열에 보관
                }
                DispatchQueue.main.async{
                    self.devViewCreate()
                }
            } catch let jsonErr {
                print("Error = \(jsonErr)")
            }
        }
    }
    //MARK: 개발자 정보를 바탕으로 UI생성
    func devViewCreate(){
        //일반 팀원 뷰(기수가 계속늘어가기 때문에 일반 팀원이 종료되고 어시스턴트를 생성하는 방식)
        while self.devList[devIndex].count != 0 {
            //개발자 목록 버튼
            let button = UIButton()
            devButtonList.append(button)
            button.tag = devIndex
            button.frame = CGRect(x: layoutMargin, y: CGFloat(devIndex-1)*80, width: self.view.frame.width - 2*layoutMargin, height: 70)
            button.backgroundColor = UIColor.clear
            button.layer.addBorder([.top,.bottom,.left,.right], color: UIColor.white, width: 1)
            button.addTarget(self, action: #selector(self.devViewTouch(sender:)), for: .touchUpInside)
            self.scrollView.addSubview(button)
            //디스이즈 x기
            let buttonLabel = UILabel()
            buttonLabel.text = "디스이즈 \(devIndex)기"
            buttonLabel.frame = CGRect(x: 20, y: 0, width: button.frame.width-40, height: button.frame.height)
            buttonLabel.textAlignment = .left
            buttonLabel.textColor = .white
            buttonLabel.font = UIFont(name:"NotoSansCJKkr-Regular",size:18)
            button.addSubview(buttonLabel)
            //기수별 멤버 뷰 생성
            let devBack = UIView()
            devBack.frame = CGRect(x: layoutMargin, y: button.frame.maxY, width: self.view.frame.width - 2*layoutMargin, height: 80*CGFloat(devList[devIndex].count)+10)
            devBack.backgroundColor = UIColor.clear
            devBack.layer.addBorder([.bottom,.left,.right], color: UIColor.white, width: 1)
            devBack.isHidden = true
            self.devBackList.append(devBack)
            self.scrollView.addSubview(devBack)
            for index in 0..<self.devList[devIndex].count{
                let devView : devListCell = devListCell()
                devView.frame = CGRect(x: 0, y: CGFloat(index)*80, width: devBack.frame.width, height: 80)
                devView.name = self.devList[devIndex][index].name //이름
                devView.position = self.devList[devIndex][index].postion //직군
                devView.team = self.devList[devIndex][index].team //학교 학과 학번
                devView.period = self.devList[devIndex][index].period //활동 기간
                devBack.addSubview(devView)
            }
            devIndex += 1
        }
        //Assistant 메뉴 생성
        let button = UIButton()
        devButtonList.append(button)
        button.tag = devIndex
        button.frame = CGRect(x: layoutMargin, y: CGFloat(devIndex-1)*80, width: self.view.frame.width - 2*layoutMargin, height: 70)
        button.backgroundColor = UIColor.clear
        button.layer.addBorder([.top,.bottom,.left,.right], color: UIColor.white, width: 1)
        button.addTarget(self, action: #selector(self.devViewTouch(sender:)), for: .touchUpInside)
        self.scrollView.addSubview(button)
        //디스이즈 x기
        let buttonLabel = UILabel()
        buttonLabel.text = "Assistant"
        buttonLabel.frame = CGRect(x: 20, y: 0, width: button.frame.width-40, height: button.frame.height)
        buttonLabel.textAlignment = .left
        buttonLabel.textColor = .white
        buttonLabel.font = UIFont(name:"NotoSansCJKkr-Regular",size:18)
        button.addSubview(buttonLabel)
        //기수별 멤버 뷰 생성
        let devBack = UIView()
        devBack.frame = CGRect(x: layoutMargin, y: button.frame.maxY, width: self.view.frame.width - 2*layoutMargin, height: 80*CGFloat(devList[999].count)+10)
        devBack.backgroundColor = UIColor.clear
        devBack.layer.addBorder([.bottom,.left,.right], color: UIColor.white, width: 1)
        devBack.isHidden = true
        self.devBackList.append(devBack)
        self.scrollView.addSubview(devBack)
        for index in 0..<self.devList[999].count{
            let devView : devListCell = devListCell()
            devView.frame = CGRect(x: 0, y: CGFloat(index)*80, width: devBack.frame.width, height: 80)
            devView.name = self.devList[999][index].name //이름
            devView.position = self.devList[999][index].postion //직군
            devView.team = self.devList[999][index].team //학교 학과 학번
            devView.period = self.devList[999][index].period //활동 기간
            devBack.addSubview(devView)
        }
        self.scrollView.contentSize.height = 80*CGFloat(devIndex)
    }
    //MARK: devViewTouch
    @objc func devViewTouch(sender:UIButton){
        let viewNumber : Int = sender.tag - 1
        if self.devButtonCheck[viewNumber] { //열려있는 상태 -> 닫아야함
            self.devBackList[viewNumber].isHidden = true
            for index in sender.tag..<self.devIndex {
                self.devButtonList[index].frame.origin.y -= self.devBackList[viewNumber].frame.height
                self.devBackList[index].frame.origin.y -= self.devBackList[viewNumber].frame.height
            }
            self.scrollView.contentSize.height -= self.devBackList[viewNumber].frame.height
        }
        else{ //닫아진 상태 -> 열어야 함
            self.devBackList[viewNumber].isHidden = false
            for index in sender.tag..<self.devIndex {
                self.devButtonList[index].frame.origin.y += self.devBackList[viewNumber].frame.height
                self.devBackList[index].frame.origin.y += self.devBackList[viewNumber].frame.height
            }
            self.scrollView.contentSize.height += self.devBackList[viewNumber].frame.height
        }
        self.devButtonCheck[viewNumber].toggle()
    }
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UICreate()
        self.devDataGet() //개발자 정보 받아오기
    }
    //MARK: 오픈소스 버튼 클릭
    @objc func openSourceButtonTouch(sender:UIButton){
        let vc = OpenSourceLicViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    //MARK: 뒤로가기 버튼
    @objc func backButtonTouch(sender: UIButton) {
        print("backButtonTouch")
        self.navigationController?.popViewController(animated: true)
    }
}
