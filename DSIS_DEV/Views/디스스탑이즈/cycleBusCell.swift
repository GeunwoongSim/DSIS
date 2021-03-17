import Foundation
import UIKit

class cycleBusCell : UIButton {
    //MARK: View
    let busTitle = UILabel() //정거장 이름
    let busChkImage = UIImageView() //현재 버스가 있는지
    let busChk = UIView()
    let upLine = UIView()
    let downLine = UIView()
    //MARK: Data
    var mode : Int? {//mode
        didSet{
            if mode == 0{
                upLine.isHidden = true
            }
            else if mode == 2{
                downLine.isHidden = true
            }
        }
    }
    var station : Int? //남은 정거장
    var min : Int? //남은 시간
    var bus_chk : Int?{ // 0: 버스 없음, 1: 버스있음
        didSet{
            if bus_chk == 0{
                self.busChkImage.isHidden = true
            }
            else{
                self.busChkImage.isHidden = false
            }
        }
    }
    //MARK: UICreate
    func UICreate(){
        //기본적인 볼더 처리
//        self.layer.addBorder([.bottom], color: UIColor.gray, width: 1)
        //버스 위치 표시
        busChk.frame = CGRect(x: layoutMargin+10, y: self.frame.height/2-12.5, width: 25, height: 25)
        busChk.layer.cornerRadius = busChk.frame.width/2
        busChk.layer.borderColor = UIColor.gray.cgColor
        busChk.layer.borderWidth = 1
        self.addSubview(busChk)
        //디자인상 필요한 위 아래 라인
        upLine.frame = CGRect(x: 0, y: 0, width: 1, height: self.frame.height/2-12.5)
        upLine.backgroundColor = UIColor.gray
        upLine.center.x = busChk.center.x
        self.addSubview(upLine)
        downLine.frame = CGRect(x: 0, y: self.frame.height/2+12.5, width: 1, height: self.frame.height/2-12.5)
        downLine.backgroundColor = UIColor.gray
        downLine.center.x = busChk.center.x
        self.addSubview(downLine)
        //현재 버스 위치 표시
        busChkImage.frame = CGRect(x: layoutMargin+8.5, y: self.frame.height/2-14, width: 28, height: 28)
        busChkImage.image = UIImage(named:"ThisStopIsBusIcon.png")
        busChkImage.isHidden = true
        self.addSubview(busChkImage)
        //정거장 이름
        busTitle.frame = CGRect(x: self.busChk.frame.maxX + 20, y: 0, width: self.frame.width - (self.busChk.frame.maxX+20), height: self.frame.height)
        busTitle.text = "정거장 이름"
        busTitle.font = UIFont(name:"NotoSansCJKkr-Regular",size:20)
        busTitle.textColor = UIColor(hex: 0x565656)
        self.addSubview(busTitle)
    }
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.UICreate()
    }
    required init?(coder: NSCoder) {
        super.init(coder:coder)
    }
    
}
