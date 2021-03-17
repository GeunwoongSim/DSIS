import Foundation
import UIKit

class attendBusView : UIScrollView{
    //MARK: Value && Data
    let data : busData = busData()
    //MARK: UICreate()
    func UICreate(){
        //베이스뷰1
        let base1View = UIView()
        base1View.frame = CGRect(x: 40, y: 0, width: self.frame.width-80, height: 200)
        self.addSubview(base1View)
        //사상 -> 승학캠퍼스
        let typeOneTitle = UILabel()
        typeOneTitle.frame = CGRect(x: 0, y: 0, width: base1View.frame.width, height: 50)
        typeOneTitle.text = self.data.attendingBusName[0]
        typeOneTitle.font = UIFont(name:"NotoSansCJKkr-Regular",size:18)
        typeOneTitle.textColor = UIColor(hex: 0x1491b1)
        base1View.addSubview(typeOneTitle)
        let typeOneContent = UILabel()
        typeOneContent.frame = CGRect(x: 0, y: typeOneTitle.frame.maxY, width: base1View.frame.width, height: 150)
        typeOneContent.text = self.data.attendingBusText[0]
        typeOneContent.numberOfLines = 0
        typeOneContent.font = UIFont(name:"NotoSansCJKkr-Regular",size:14)
        typeOneContent.textColor = UIColor(hex: 0x565656)
        base1View.addSubview(typeOneContent)
        //밑줄
        let line1 = UIView()
        line1.frame = CGRect(x: 0, y: base1View.frame.maxY+20, width: self.frame.width, height: 1)
        line1.backgroundColor = UIColor.gray
        self.addSubview(line1)
        //베이스뷰2
        let base2View = UIView()
        base2View.frame = CGRect(x: 40, y: line1.frame.maxY, width: self.frame.width-80, height: 200)
        self.addSubview(base2View)
        //사상 -> 승학캠퍼스
        let typeTwoTitle = UILabel()
        typeTwoTitle.frame = CGRect(x: 0, y: 0, width: base2View.frame.width, height: 50)
        typeTwoTitle.text = self.data.attendingBusName[1]
        typeTwoTitle.font = UIFont(name:"NotoSansCJKkr-Regular",size:18)
        typeTwoTitle.textColor = UIColor(hex: 0x1491b1)
        base2View.addSubview(typeTwoTitle)
        let typeTwoContent = UILabel()
        typeTwoContent.frame = CGRect(x: 0, y: typeTwoTitle.frame.maxY, width: base2View.frame.width, height: 150)
        typeTwoContent.text = self.data.attendingBusText[1]
        typeTwoContent.numberOfLines = 0
        typeTwoContent.font = UIFont(name:"NotoSansCJKkr-Regular",size:14)
        typeTwoContent.textColor = UIColor(hex: 0x565656)
        base2View.addSubview(typeTwoContent)
        //밑줄
        let line2 = UIView()
        line2.frame = CGRect(x: 0, y: base2View.frame.maxY+20, width: self.frame.width, height: 1)
        line2.backgroundColor = UIColor.gray
        self.addSubview(line2)
        //베이스뷰3
        let base3View = UIView()
        base3View.frame = CGRect(x: 40, y: line2.frame.maxY, width: self.frame.width-80, height: 450)
        self.addSubview(base3View)
        //사상 -> 승학캠퍼스
        let typeThreeTitle = UILabel()
        typeThreeTitle.frame = CGRect(x: 0, y: 0, width: base3View.frame.width, height: 50)
        typeThreeTitle.text = self.data.attendingBusName[2]
        typeThreeTitle.font = UIFont(name:"NotoSansCJKkr-Regular",size:18)
        typeThreeTitle.textColor = UIColor(hex: 0x1491b1)
        base3View.addSubview(typeThreeTitle)
        let typeThreeContent = UILabel()
        typeThreeContent.frame = CGRect(x: 0, y: typeThreeTitle.frame.maxY, width: base2View.frame.width, height: 400)
        typeThreeContent.text = self.data.attendingBusText[2]
        typeThreeContent.numberOfLines = 0
        typeThreeContent.font = UIFont(name:"NotoSansCJKkr-Regular",size:14)
        typeThreeContent.textColor = UIColor(hex: 0x565656)
        base3View.addSubview(typeThreeContent)
        //컨텐트사이즈 조절
        self.contentSize.height = base1View.frame.height + base2View.frame.height + base3View.frame.height + 60
    }
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.showsVerticalScrollIndicator = false
        self.UICreate()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
