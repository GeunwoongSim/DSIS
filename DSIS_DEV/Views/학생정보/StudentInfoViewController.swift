import Foundation
import UIKit
import Alamofire
import Kanna
//학적부
class StudentInfoViewController: UIViewController {
    //MARK: Value && Data
    let studentInfoString: [String] = ["대학", "생년월일", "학부(과)", "전공", "수업구분", "학년", "학적상태", "부전공", "복수전공", "연계전공", "주소", "전화번호", "휴대폰", "전자메일", "평생지도교수", "상담여부"]
    var studentInfoText: [String] = []
    //UI
    let imageView = UIImageView()
    let menuBackground = UIView()
    let studentImage = UIImageView() //학생사진
    let studentName = UILabel() //학생이름
    let studentNumber = UILabel() //학생번호
    let studentCollege1 = UILabel() //학생대학
    let studentCollege2 = UILabel() //학생학과
    //student Info
    var studentNameString: String = "" //이름
    var studentNumberString: String = "" //학번
    var studentCollegeString: String = "" //대학
    var studentDeptString: String = "" //학과
    var studentBirthDayString: String = "" //생년월일
    var studentSpecializeString: String = "" //전공
    var studentDayorNightString: String = "" //수업구분(주간,야간)
    var studentGradeString: String = "" //학년
    var studentResister: String = "" //학적상태
    var studentSubDeptString: String = "" //부전공
    var studentMulDeptString: String = "" //복수전공
    var studentConnDeptString: String = "" //연계전공
    var studentPlaceString: String = "" //주소
    var studentHousePhoneString: String = "" //전화번호
    var studentPhoneString: String = "" //휴대폰
    var studentMailString: String = "" //메일
    var studentProfessorString: String = "" //평생지도교수
    var studentConsultationString: String = "" //상담여부
    
    //MARK: UICreate
    func UICreate(){
        view.backgroundColor = UIColor(hex: 0xf9f7f7)
        //학생정보연결
        studentInfoMatch()
        //배경이미지
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: statusBarHeight+150)
        imageView.image = UIImage(named: "MainBackground.png")
        view.addSubview(imageView)
        //뒤로가기
        let backButton = UIButton()
        backButton.frame = CGRect(x: layoutMargin, y: statusBarHeight+10, width: 40, height: 40)
        backButton.addTarget(self, action: #selector(self.backButtonTouch(sender:)), for: .touchUpInside)
        view.addSubview(backButton)
        let backButtonImage = UIImageView()
        backButtonImage.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        backButtonImage.image = UIImage(named:"BackButton.png")
        backButton.addSubview(backButtonImage)
        // 상단의 학생 정보를 업데이트
        self.studentUpperInfoSet()
        //메뉴가 올라가는 배경
        menuBackground.frame = CGRect(x: 0, y: imageView.frame.maxY, width: view.frame.width, height: self.view.frame.height - imageView.frame.height)
        menuBackground.backgroundColor = UIColor(hex: 0xf9f7f7)
        view.addSubview(menuBackground)
        //컨텐츠 높이
        let infoH : CGFloat = (self.view.frame.height - imageView.frame.height - homeIndicatorHeight - 40) / 9
        //대학 ~ 연계전공
        for infoIndex in 0..<5 {
            let infoView1 = UIView()
            infoView1.frame = CGRect(x: 20, y: 20+CGFloat(infoIndex)*infoH, width: (menuBackground.frame.width - 40)/2, height: infoH)
            menuBackground.addSubview(infoView1)
            let infoView1Label = UILabel() //항목명
            infoView1Label.frame = CGRect(x: 0, y: 0, width: infoView1.frame.width/5*2, height: infoView1.frame.height)
            infoView1Label.text = " \(studentInfoString[infoIndex*2])"
            infoView1Label.textColor = UIColor(hex: 0x108DBE)
            infoView1Label.font = UIFont(name:"NotoSansCJKkr-Regular",size:16)
            infoView1Label.adjustsFontSizeToFitWidth = true
            infoView1.addSubview(infoView1Label)
            let infoView1Text = UILabel() //항목값
            infoView1Text.frame = CGRect(x: infoView1Label.frame.maxX, y: 0, width: infoView1.frame.width/5*3-10, height: infoView1.frame.height)
            infoView1Text.text = "\(studentInfoText[infoIndex*2])"
            infoView1Text.textColor = UIColor(hex:0x565656)
            infoView1Text.textAlignment = .right
            infoView1Text.font = UIFont(name:"NotoSansCJKkr-Regular",size:16)
            infoView1Text.numberOfLines = 2
            infoView1Text.adjustsFontSizeToFitWidth = true
            infoView1.addSubview(infoView1Text)
            let infoView1Line = UIView() //밑줄
            infoView1Line.frame = CGRect(x: 0, y: infoView1.frame.height-1, width: infoView1.frame.width, height: 1)
            infoView1Line.backgroundColor = UIColor.lightGray
            infoView1.addSubview(infoView1Line)
            let infoView12Line = UIView() //세로줄
            infoView12Line.frame = CGRect(x: infoView1.frame.width-1, y: 0, width: 1, height: infoView1.frame.height)
            infoView12Line.backgroundColor = UIColor.lightGray
            infoView1.addSubview(infoView12Line)
            let infoView2 = UIView()
            infoView2.frame = CGRect(x: infoView1.frame.maxX, y: infoView1.frame.minY, width: infoView1.frame.width, height: infoView1.frame.height)
            menuBackground.addSubview(infoView2)
            let infoView2Label = UILabel() //항목명
            infoView2Label.frame = CGRect(x: 0, y: 0, width: infoView1.frame.width/5*2, height: infoView1.frame.height)
            infoView2Label.text = " \(studentInfoString[infoIndex*2+1])"
            infoView2Label.textColor = UIColor(hex: 0x108DBE)
            infoView2Label.font = UIFont(name:"NotoSansCJKkr-Regular",size:16)
        infoView2Label.adjustsFontSizeToFitWidth = true
            infoView2.addSubview(infoView2Label)
            let infoView2Text = UILabel() //항목값
            infoView2Text.font = UIFont(name:"NotoSansCJKkr-Regular",size:16)
            infoView2Text.frame = CGRect(x: infoView2Label.frame.maxX, y: 0, width: infoView1.frame.width/5*3-10, height: infoView1.frame.height)
            infoView2Text.text = "\(studentInfoText[infoIndex*2+1])"
            infoView2Text.textColor = UIColor(hex:0x565656)
            infoView2Text.textAlignment = .right
            infoView2Text.adjustsFontSizeToFitWidth = true
            infoView2.addSubview(infoView2Text)
            let infoView2Line = UIView() //밑줄
            infoView2Line.frame = CGRect(x: 0, y: infoView2.frame.height-1, width: infoView2.frame.width, height: 1)
            infoView2Line.backgroundColor = UIColor.lightGray
            infoView2.addSubview(infoView2Line)
        }
        //주소
        let infoView3 = UIView()
        infoView3.frame = CGRect(x: 20, y: 20+infoH*5, width: menuBackground.frame.width - 40, height: infoH)
        menuBackground.addSubview(infoView3)
        let infoView3Label = UILabel()
        infoView3Label.frame = CGRect(x: 0, y: 0, width: infoView3.frame.width/10*2, height: infoView3.frame.height)
        infoView3Label.text = " \(studentInfoString[10])"
        infoView3Label.textColor = UIColor(hex: 0x108DBE)
        infoView3Label.font = UIFont(name:"NotoSansCJKkr-Regular",size:16)
        infoView3Label.adjustsFontSizeToFitWidth = true
        infoView3.addSubview(infoView3Label)
        let infoView3Text = UILabel() //항목값
        infoView3Text.frame = CGRect(x: infoView3Label.frame.maxX, y: 0, width: infoView3.frame.width/10*8-10, height: infoView3.frame.height)
        infoView3Text.text = "\(studentInfoText[10])"
        infoView3Text.textColor = UIColor(hex:0x565656)
        infoView3Text.textAlignment = .left
        infoView3Text.font = UIFont(name:"NotoSansCJKkr-Regular",size:16)
        infoView3Text.numberOfLines = 0
        infoView3Text.adjustsFontSizeToFitWidth = true
        infoView3.addSubview(infoView3Text)
        let infoView3Line = UIView() //밑줄
        infoView3Line.frame = CGRect(x: 0, y: infoView3.frame.height-1, width: infoView3.frame.width, height: 1)
        infoView3Line.backgroundColor = UIColor.lightGray
        infoView3.addSubview(infoView3Line)
        //휴대폰
        let infoView5 = UIView()
        infoView5.frame = CGRect(x: 20, y: infoView3.frame.maxY, width: infoView3.frame.width, height: infoH)
        menuBackground.addSubview(infoView5)
        let infoView5Label = UILabel()
        infoView5Label.frame = CGRect(x: 0, y: 0, width: infoView5.frame.width/10*2, height: infoView5.frame.height)
        infoView5Label.text = " \(studentInfoString[12])"
        infoView5Label.textColor = UIColor(hex: 0x108DBE)
        infoView5Label.font = UIFont(name:"NotoSansCJKkr-Regular",size:16)
        infoView5Label.adjustsFontSizeToFitWidth = true
        infoView5.addSubview(infoView5Label)
        let infoView5Text = UILabel() //항목값
        infoView5Text.frame = CGRect(x: infoView5Label.frame.maxX, y: 0, width: infoView5.frame.width/10*8-10, height: infoView5.frame.height)
        infoView5Text.text = "\(studentInfoText[12])"
        infoView5Text.textColor = UIColor(hex:0x565656)
        infoView5Text.textAlignment = .right
        infoView5Text.font = UIFont(name:"NotoSansCJKkr-Regular",size:16)
        infoView5Text.adjustsFontSizeToFitWidth = true
        infoView5.addSubview(infoView5Text)
        let infoView5Line = UIView() //밑줄
        infoView5Line.frame = CGRect(x: 0, y: infoView5.frame.height-1, width: infoView5.frame.width, height: 1)
        infoView5Line.backgroundColor = UIColor.lightGray
        infoView5.addSubview(infoView5Line)
        //전자메일
        let infoView6 = UIView()
        infoView6.frame = CGRect(x: 20, y: infoView5.frame.maxY, width: infoView5.frame.width, height: infoH)
        menuBackground.addSubview(infoView6)
        let infoView6Label = UILabel()
        infoView6Label.frame = CGRect(x: 0, y: 0, width: infoView6.frame.width/10*2, height: infoView6.frame.height)
        infoView6Label.text = " \(studentInfoString[13])"
        infoView6Label.textColor = UIColor(hex: 0x108DBE)
        infoView6Label.font = UIFont(name:"NotoSansCJKkr-Regular",size:16)
        infoView6Label.adjustsFontSizeToFitWidth = true
        infoView6.addSubview(infoView6Label)
        let infoView6Text = UILabel() //항목값
        infoView6Text.frame = CGRect(x: infoView6Label.frame.maxX, y: 0, width: infoView6.frame.width/10*8-10, height: infoView6.frame.height)
        infoView6Text.text = "\(studentInfoText[13])"
        infoView6Text.textColor = UIColor(hex:0x565656)
        infoView6Text.textAlignment = .right
        infoView6Text.font = UIFont(name:"NotoSansCJKkr-Regular",size:16)
        infoView6Text.adjustsFontSizeToFitWidth = true
        infoView6.addSubview(infoView6Text)
        let infoView6Line = UIView() //밑줄
        infoView6Line.frame = CGRect(x: 0, y: infoView6.frame.height-1, width: infoView6.frame.width, height: 1)
        infoView6Line.backgroundColor = UIColor.lightGray
        infoView6.addSubview(infoView6Line)
        //평생지도교수
        let infoView7 = UIView()
        infoView7.frame = CGRect(x: 20, y: infoView6.frame.maxY, width: (menuBackground.frame.width-40)/2, height: infoH)
        menuBackground.addSubview(infoView7)
        let infoView7Label = UILabel()
        infoView7Label.frame = CGRect(x: 0, y: 0, width: infoView7.frame.width/5*3, height: infoView7.frame.height)
        infoView7Label.text = " \(studentInfoString[14])"
        infoView7Label.textColor = UIColor(hex: 0x108DBE)
        infoView7Label.font = UIFont(name:"NotoSansCJKkr-Regular",size:16)
        infoView7Label.adjustsFontSizeToFitWidth = true
        infoView7.addSubview(infoView7Label)
        let infoView7Text = UILabel() //항목값
        infoView7Text.frame = CGRect(x: infoView7Label.frame.maxX, y: 0, width: infoView7.frame.width/5*2-10, height: infoView7.frame.height)
        infoView7Text.text = "\(studentInfoText[14])"
        infoView7Text.textColor = UIColor(hex:0x565656)
        infoView7Text.textAlignment = .right
        infoView7Text.font = UIFont(name:"NotoSansCJKkr-Regular",size:16)
        infoView7Text.adjustsFontSizeToFitWidth = true
        infoView7.addSubview(infoView7Text)
        let infoView78Line = UIView() //세로줄
        infoView78Line.frame = CGRect(x: infoView7.frame.width-1, y: 0, width: 1, height: infoView7.frame.height)
        infoView78Line.backgroundColor = UIColor.lightGray
        infoView7.addSubview(infoView78Line)
        //상담여부
        let infoView8 = UIView()
        infoView8.frame = CGRect(x: infoView7.frame.maxX, y: infoView7.frame.minY, width: infoView7.frame.width, height: infoH)
        menuBackground.addSubview(infoView8)
        let infoView8Label = UILabel()
        infoView8Label.frame = CGRect(x: 0, y: 0, width: infoView8.frame.width/5*2, height: infoView8.frame.height)
        infoView8Label.text = " \(studentInfoString[15])"
        infoView8Label.textColor = UIColor(hex: 0x108DBE)
        infoView8Label.font = UIFont(name:"NotoSansCJKkr-Regular",size:16)
        infoView8Label.adjustsFontSizeToFitWidth = true
        infoView8.addSubview(infoView8Label)
        let infoView8Text = UILabel() //항목값
        infoView8Text.frame = CGRect(x: infoView8Label.frame.maxX+10, y: 0, width: infoView8.frame.width/5*3-20, height: infoView8.frame.height)
        infoView8Text.numberOfLines = 0
        infoView8Text.text = "\(studentInfoText[15])"
        infoView8Text.textColor = UIColor(hex:0x565656)
        infoView8Text.textAlignment = .right
        infoView8Text.font = UIFont(name:"NotoSansCJKkr-Regular",size:16)
        infoView8Text.adjustsFontSizeToFitWidth = true
        infoView8.addSubview(infoView8Text)
    }
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UICreate()
    }
    //MARK: imageView studentInfo create
    func studentUpperInfoSet() { //학생정보 세팅
        //학생 정보 내용 높이
        let studentInfoLabelHeight: CGFloat = (imageView.frame.height - statusBarHeight - 20)/5
        //학생이름
        let studentNameLabel = UILabel()
        studentNameLabel.frame = CGRect(x: self.view.frame.width/5, y: statusBarHeight+10, width: self.view.frame.width/5, height: studentInfoLabelHeight)
        studentNameLabel.text = "이름"
        studentNameLabel.textAlignment = .center
        studentNameLabel.fontToFit(name: "NotoSansCJKkr-Bold", size: 16)
        studentNameLabel.textColor = UIColor.white
        view.addSubview(studentNameLabel)
        studentName.frame = CGRect(x: studentNameLabel.frame.maxX, y: studentNameLabel.frame.minY, width: self.view.frame.width/5*2, height: studentInfoLabelHeight)
        studentName.text = "\(studentNameString)"
        studentName.textColor = UIColor.white
        studentName.fontToFit(name: "NotoSansCJKkr-Bold", size: 13)
        view.addSubview(studentName)
        //학생번호
        let studentNumberLabel = UILabel()
        studentNumberLabel.frame = CGRect(x: self.view.frame.width/5, y: studentNameLabel.frame.maxY, width: self.view.frame.width/5, height: studentInfoLabelHeight)
        studentNumberLabel.text = "학번"
        studentNumberLabel.textAlignment = .center
        studentNumberLabel.fontToFit(name: "NotoSansCJKkr-Bold", size: 16)
        studentNumberLabel.textColor = UIColor.white
        view.addSubview(studentNumberLabel)
        studentNumber.frame = CGRect(x: studentNumberLabel.frame.maxX, y: studentNumberLabel.frame.minY, width: self.view.frame.width/5*2, height: studentInfoLabelHeight)
        studentNumber.text = "\(studentNumberString)"
        studentNumber.textColor = UIColor.white
        studentNumber.fontToFit(name: "NotoSansCJKkr-Bold", size: 13)
        view.addSubview(studentNumber)
        //학생학과
        let studentCollegeLabel = UILabel()
        studentCollegeLabel.frame = CGRect(x: self.view.frame.width/5, y: studentNumberLabel.frame.maxY, width: self.view.frame.width/5, height: studentInfoLabelHeight)
        studentCollegeLabel.text = "학과"
        studentCollegeLabel.textAlignment = .center
        studentCollegeLabel.fontToFit(name: "NotoSansCJKkr-Bold", size: 16)
        studentCollegeLabel.textColor = UIColor.white
        view.addSubview(studentCollegeLabel)
        studentCollege1.frame = CGRect(x: studentCollegeLabel.frame.maxX, y: studentCollegeLabel.frame.minY, width: self.view.frame.width/5*2, height: studentInfoLabelHeight)
        studentCollege1.text = "\(studentCollegeString)"
        studentCollege1.textColor = UIColor.white
        studentCollege1.fontToFit(name: "NotoSansCJKkr-Bold", size: 13)
        view.addSubview(studentCollege1)
        studentCollege2.frame = CGRect(x: studentCollegeLabel.frame.maxX, y: studentCollege1.frame.maxY, width: self.view.frame.width/5*2, height: studentInfoLabelHeight*2)
        studentCollege2.text = "\(studentDeptString)"
        studentCollege2.numberOfLines = 0
        studentCollege2.textColor = UIColor.white
        studentCollege2.fontToFit(name: "NotoSansCJKkr-Bold", size: 13)
        view.addSubview(studentCollege2)
    }
    //MARK: studentInfo Match
    func studentInfoMatch() {
        studentInfoText.append(studentCollegeString) //대학
        studentInfoText.append(studentBirthDayString) //생년월일
        studentInfoText.append(studentDeptString) //학부(과)
        studentInfoText.append(studentSpecializeString) //전공
        studentInfoText.append(studentDayorNightString) //수업구분
        studentInfoText.append(studentGradeString) //학년
        studentInfoText.append(studentResister) //학적상태
        studentInfoText.append(studentSubDeptString) //부전공
        studentInfoText.append(studentMulDeptString) //복수전공
        studentInfoText.append(studentConnDeptString) //연계전공
        studentInfoText.append(studentPlaceString) //주소
        studentInfoText.append(studentHousePhoneString) //전화번호
        studentInfoText.append(studentPhoneString) //휴대폰
        studentInfoText.append(studentMailString) //전자메일
        studentInfoText.append(studentProfessorString) //평생지도교수
        studentInfoText.append(studentConsultationString) //상담여부
    }
    //MARK: BackButton
    @objc func backButtonTouch(sender: UIButton) {
        print("backButtonTouch")
        self.navigationController?.popViewController(animated: true)
    }
}
