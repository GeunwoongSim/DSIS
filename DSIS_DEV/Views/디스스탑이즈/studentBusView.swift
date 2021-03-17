import Foundation
import UIKit

class studentBusView : UIScrollView {
    //MARK: Value && Data
    let data : busData = busData()
    let typeOneBase = UIView()
    let typeTwoBase = UIView()
    let wordHeight : CGFloat = 25
    //MARK: 승학 -> 부민 생성
    func typeOneCreate(){
        //베이스뷰 생성
        let typeOneBaseH : CGFloat = 100 + wordHeight * CGFloat(self.data.typeOneTextTimeString.count)
        typeOneBase.frame = CGRect(x: 40, y: 0, width: self.frame.width-80, height: typeOneBaseH)
        self.addSubview(typeOneBase)
        self.contentSize.height = typeOneBase.frame.height * 2
        //제목
        let typeName = UILabel() //승학 -> 구덕 -> 부민 버스
        typeName.frame = CGRect(x: 0, y: 0, width: typeOneBase.frame.width, height: 50)
        typeName.text = "승학 → 구덕 → 부민"
        typeName.font = UIFont(name:"NotoSansCJKkr-Regular",size:18)
        typeName.textColor = UIColor(hex: 0x1491b1)
        typeOneBase.addSubview(typeName)
        //시간과 장소
        var originY : CGFloat = 0
        for textIndex in 0..<self.data.typeOneTextTimeString.count {
            let timeString = UILabel()
            timeString.text = self.data.typeOneTextTimeString[textIndex]
            timeString.font = UIFont(name:"NotoSansCJKkr-Regular",size:14)
            timeString.textColor = UIColor(hex: 0x565656)
            typeOneBase.addSubview(timeString)
            let placeString = UILabel()
            placeString.backgroundColor = UIColor.clear
            placeString.text = self.data.typeOneTextPlaceString[textIndex]
            placeString.font = UIFont(name:"NotoSansCJKkr-Regular",size:14)
            placeString.textColor = UIColor(hex: 0x565656)
            typeOneBase.addSubview(placeString)
            //frame 잡기 글자수에 따라 변경
            if self.data.typeOneTextPlaceString[textIndex].count > 13 { //둘줄 필요
                timeString.frame = CGRect(x: 0, y: typeName.frame.maxY+originY, width: 80, height: wordHeight)
                placeString.frame = CGRect(x: timeString.frame.maxX, y: typeName.frame.maxY+originY, width: typeOneBase.frame.width - timeString.frame.width, height: 2*wordHeight)
                placeString.numberOfLines = 0
                originY += 2*wordHeight
            }
            else{ //한줄 필요
                timeString.frame = CGRect(x: 0, y: typeName.frame.maxY+originY, width: 80, height: wordHeight)
                placeString.frame = CGRect(x: timeString.frame.maxX, y: typeName.frame.maxY+originY, width: typeOneBase.frame.width - timeString.frame.width, height: wordHeight)
                originY += wordHeight
            }
        }
    }
    //MARK: 부민 -> 승학 생성
    func typeTwoCreate(){
        //두 타입 구분선
        let line = UIView()
        line.frame = CGRect(x: 0, y: self.typeOneBase.frame.height+20, width: self.frame.width, height: 1)
        line.backgroundColor = UIColor.gray
        self.addSubview(line)
        //베이스뷰 생성
        let typeTwoBaseH : CGFloat = 50 + wordHeight * CGFloat(self.data.typeOneTextTimeString.count)
        typeTwoBase.frame = CGRect(x: 40, y: line.frame.maxY, width: self.frame.width-80, height: typeTwoBaseH)
        self.addSubview(typeTwoBase)
        //제목
        let typeName = UILabel() //승학 -> 구덕 -> 부민 버스
        typeName.frame = CGRect(x: 0, y: 0, width: typeTwoBase.frame.width, height: 50)
        typeName.text = "부민 → 구덕 → 승학"
        typeName.font = UIFont(name:"NotoSansCJKkr-Regular",size:18)
        typeName.textColor = UIColor(hex: 0x1491b1)
        typeTwoBase.addSubview(typeName)
        //시간과 장소
        for textIndex in 0..<self.data.typeTwoTextTimeString.count {
            let timeString = UILabel()
            timeString.frame = CGRect(x: 0, y: typeName.frame.maxY+CGFloat(textIndex)*wordHeight, width: 80, height: wordHeight)
            timeString.text = self.data.typeTwoTextTimeString[textIndex]
            timeString.font = UIFont(name:"NotoSansCJKkr-Regular",size:14)
            timeString.textColor = UIColor(hex: 0x565656)
            typeTwoBase.addSubview(timeString)
            let placeString = UILabel()
            placeString.backgroundColor = UIColor.clear
            placeString.frame = CGRect(x: timeString.frame.maxX, y: typeName.frame.maxY+CGFloat(textIndex)*wordHeight, width: typeTwoBase.frame.width - timeString.frame.width, height: wordHeight)
            placeString.text = self.data.typeTwoTextPlaceString[textIndex]
            placeString.font = UIFont(name:"NotoSansCJKkr-Regular",size:14)
            placeString.textColor = UIColor(hex: 0x565656)
            typeTwoBase.addSubview(placeString)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.showsVerticalScrollIndicator = false
        self.typeOneCreate()
        self.typeTwoCreate()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
