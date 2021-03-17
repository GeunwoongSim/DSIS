import Foundation
import UIKit
class MapViewController : UIViewController {
    
    var mapData : MapModel = MapModel()
    
    let buildingNameButton = UIButton()
    let buildingScrollView = UIScrollView()
    var buildingMenuCheck : Bool = false //열려있지않음
    
    //MARK: viewDidLoad
    override func viewDidLoad(){
        super.viewDidLoad()
        self.UICreate()
    }
    //MARK: UI생성
    func UICreate() {
        self.view.backgroundColor = UIColor.white
        //배경이미지
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        imageView.image = UIImage(named: "MainBackground.png")
        view.addSubview(imageView)
        //네비게이션바
        let navigationBar = UIView()
        navigationBar.frame = CGRect(x: 0, y: statusBarHeight, width: view.frame.width, height: navigationBarHeight)
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
        //지도명
        let mapTitle = UILabel()
        mapTitle.frame = CGRect(x: backButton.frame.maxX, y: 0, width: navigationBar.frame.width - layoutMargin-40, height: navigationBarHeight)
        mapTitle.text = mapData.mapTitleList[mapData.mapMode]
        mapTitle.font = UIFont(name: "NotoSansCJKkr-Regular", size: 24)
        mapTitle.textColor = .white
        navigationBar.addSubview(mapTitle)
        //맵 이미지 배경
        let mapBaseView = UIView()
        mapBaseView.frame = CGRect(x: 10, y: navigationBar.frame.maxY+10, width: view.frame.width-20, height: view.frame.height/2)
        mapBaseView.backgroundColor = naviBarBackgroundColor
        view.addSubview(mapBaseView)
        //맵 정보
        let schoolMap = UIImageView()
        schoolMap.frame = CGRect(x: 10, y: 10, width: mapBaseView.frame.width-20, height: mapBaseView.frame.height-20)
        schoolMap.image = UIImage(named:mapData.mapImageList[mapData.mapMode])
        mapBaseView.addSubview(schoolMap)
        //강의실 정보 버튼
        buildingNameButton.frame = CGRect(x: 0, y: view.frame.height - homeIndicatorHeight - navigationBarHeight, width: view.frame.width, height: navigationBarHeight)
        buildingNameButton.backgroundColor = UIColor(hex:0x565656,alpha: 0.5)
        buildingNameButton.setTitle("건물명 (touch)", for: .normal)
        buildingNameButton.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Regular",size:14)
        buildingNameButton.setTitleColor(UIColor.white, for: .normal)
        buildingNameButton.addTarget(self, action: #selector(self.buildingNameButtonTouch(sender:)), for: .touchUpInside)
        view.addSubview(buildingNameButton)
        //강의실 스크롤 뷰
        let buildingScrollViewHeight : CGFloat = self.view.frame.height - 2*navigationBarHeight - statusBarHeight - 10 - mapBaseView.frame.height
        buildingScrollView.frame = CGRect(x: 0, y: view.frame.height-homeIndicatorHeight, width: view.frame.width, height: buildingScrollViewHeight)
        buildingScrollView.backgroundColor = UIColor.white
        buildingScrollView.bounces = false
        view.addSubview(buildingScrollView)
        //safe area
        let safeArea = UIView()
        safeArea.backgroundColor = UIColor.white
        safeArea.frame = CGRect(x: 0, y: view.frame.height-homeIndicatorHeight, width: view.frame.width, height: homeIndicatorHeight)
        view.addSubview(safeArea)
        
        mapDataSet(menu:buildingScrollView)
    }
    //MARK: 건물명(Touch) 클릭했을때
    @objc func buildingNameButtonTouch(sender:UIButton){
        if self.buildingMenuCheck { //열려있는 상태
            UIView.animate(withDuration: 0.5, animations: {
                self.buildingNameButton.frame.origin.y += (self.buildingScrollView.frame.height - homeIndicatorHeight)
                self.buildingScrollView.frame.origin.y += (self.buildingScrollView.frame.height - homeIndicatorHeight)
                self.buildingMenuCheck.toggle()
            })
        }
        else{ //닫혀있는 상태
            UIView.animate(withDuration: 0.5, animations: {
                self.buildingNameButton.frame.origin.y -= (self.buildingScrollView.frame.height - homeIndicatorHeight)
                self.buildingScrollView.frame.origin.y -= (self.buildingScrollView.frame.height - homeIndicatorHeight)
                self.buildingMenuCheck.toggle()
            })
        }
    }
    //MARK: 건물정보 생성
    func mapDataSet(menu: UIScrollView) {
        menu.contentSize.height = CGFloat(mapData.mapNumberCount[mapData.mapMode]) * navigationBarHeight + CGFloat(mapData.mapNumberCount[mapData.mapMode] + 1) * 10
        let buildingScrillViewImage = UIImageView()
        buildingScrillViewImage.image = UIImage(named: "MainBackground.png")
        buildingScrillViewImage.frame = CGRect(x: 0, y: 0, width: buildingScrollView.frame.width, height: buildingScrollView.contentSize.height)
        buildingScrollView.addSubview(buildingScrillViewImage)
        for buildingIndex in 0..<mapData.mapNumberCount[mapData.mapMode] {
            //버튼
            let button = UIButton()
            button.tag = buildingIndex
            button.frame = CGRect(x: 10, y: 10+CGFloat(buildingIndex)*(navigationBarHeight+10), width: menu.frame.width-20, height: navigationBarHeight)
            button.layer.addBorder([.top,.bottom,.left,.right], color: UIColor.white, width: 1)
            button.addTarget(self, action: #selector(self.buildingButtonTouch(sender:)), for: .touchUpInside)
            if mapData.buildingSupport[mapData.mapMode][buildingIndex] {
                button.setTitle("\(mapData.buildingName[mapData.mapMode][buildingIndex]) - 지원됨", for: .normal)
            } else {
                button.setTitle("\(mapData.buildingName[mapData.mapMode][buildingIndex]) - 지원되지않음", for: .normal)
            }
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Regular",size:14)
            button.contentHorizontalAlignment = .left
            button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            menu.addSubview(button)
        }
    }
    //MARK: 상세 건물정보 클릭
     @objc func buildingButtonTouch(sender: UIButton) {
        print("빌딩 메뉴 클릭")
        if self.mapData.buildingSupport[mapData.mapMode][sender.tag] { //지원함
            let vc = MapDetailViewController()
            vc.buildingName = mapData.buildingName[mapData.mapMode][sender.tag]
            vc.buildingNumber = mapData.buildingNumber[mapData.mapMode][sender.tag]
            vc.buildingImage = mapData.buildingImage[mapData.mapMode][sender.tag]
            vc.buildingString = mapData.mapModeString[mapData.mapMode]
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else{
            let message_Alert = UIAlertController(title: "", message: "건물 정보가 없습니다", preferredStyle: UIAlertController.Style.alert)
            let OK_Action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
            message_Alert.addAction(OK_Action)
            present(message_Alert, animated: true, completion: nil)
        }
    }
    @objc func backButtonTouch(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
