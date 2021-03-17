import Foundation
import UIKit
import Alamofire
import Kanna

class StudentHomeViewController: UIViewController {

    let studentHomeMenuString: [String] = ["학적부", "성적표", "시간표", "장학정보"]
    let studentHomeMenuImage : [String] = ["StudentBachelor.png","StudentReport.png","StudentSchedule.png","StudentScholarship.png"]
    //UI
    let studentImage = UIImageView() //학생사진
    let studentName = UILabel() //학생이름
    let studentNumber = UILabel() //학생번호
    let studentCollege1 = UILabel() //학생대학
    let studentCollege2 = UILabel() //학생학과
    //student Info
    var studentID: String = ""
    var studentPW: String = ""
    var studentNameString: String = ""
    var studentNumberString: String = ""
    var studentCollegeString: String = ""
    var studentDeptString: String = ""
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
    var studentEntranceYearString: String = "" //입학년도(성적 조회에 필요)
    var studentGraduationYearString: String = "" //졸업년도(성적 조회에 필요)

    //MARK: UICreate
    func UICreate(){
        view.backgroundColor = UIColor(hex: 0xf9f7f7)
        //배경이미지
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: statusBarHeight+150)
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
        //메뉴
        let menuBackground = UIView()
        menuBackground.frame = CGRect(x: 0, y: imageView.frame.maxY, width: view.frame.width, height: self.view.frame.height - imageView.frame.height)
        menuBackground.backgroundColor = UIColor(hex: 0xf9f7f7)
        view.addSubview(menuBackground)
        let menuButtonH : CGFloat = (menuBackground.frame.height - homeIndicatorHeight - 150) / 4
        for buttonIndex in 0..<studentHomeMenuString.count {
            let menuButton = UIButton() //버튼
            menuButton.addTarget(self, action: #selector(studentButtonTouch(sender:)), for: .touchUpInside)
            menuButton.tag = buttonIndex
            menuButton.frame = CGRect(x: 30, y: 30+CGFloat(buttonIndex)*(menuButtonH+30), width: self.view.frame.width - 60, height: menuButtonH)
            menuButton.backgroundColor = .white
            menuButton.layer.shadowColor = UIColor.lightGray.cgColor
            menuButton.layer.shadowOpacity = 1
            menuButton.layer.shadowRadius = 7
            menuButton.layer.shadowOffset = .zero
            menuBackground.addSubview(menuButton)
            let menuButtonIcon = UIImageView() //아이콘
            menuButtonIcon.image = UIImage(named:self.studentHomeMenuImage[buttonIndex])
            menuButtonIcon.frame = CGRect(x: menuButton.frame.height/4, y: menuButton.frame.height/4, width: menuButton.frame.height/2, height: menuButton.frame.height/2)
            menuButtonIcon.backgroundColor = .clear
            menuButton.addSubview(menuButtonIcon)
            let menuButtonLabel = UILabel()
            menuButtonLabel.frame = CGRect(x: menuButton.frame.width/5*3, y: menuButton.frame.height/3, width: menuButton.frame.width/5*1.5, height: menuButton.frame.height/3)
            menuButtonLabel.text = "\(studentHomeMenuString[buttonIndex])"
            menuButtonLabel.textColor = UIColor(hex: 0x565656)
            menuButtonLabel.textAlignment = .right
            menuButtonLabel.fontToFit(name: "NotoSansCJKkr-Regular", size: 18)
            menuButton.addSubview(menuButtonLabel)
        }
    }
    //MARK: 뒤로가기버튼 클릭
    @objc func backButtonTouch(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UICreate()
    }
    //MARK: 메뉴 버튼 터치
    @objc func studentButtonTouch(sender: UIButton) {
        switch sender.tag {
        case 0: //학적부
            let vc = StudentInfoViewController()
            vc.studentNameString = studentNameString
            vc.studentNumberString = studentNumberString
            vc.studentCollegeString = studentCollegeString
            vc.studentDeptString = studentDeptString
            vc.studentBirthDayString = studentBirthDayString
            vc.studentSpecializeString = studentSpecializeString
            vc.studentDayorNightString = studentDayorNightString
            vc.studentGradeString = studentGradeString
            vc.studentResister = studentResister
            vc.studentSubDeptString = studentSubDeptString
            vc.studentMulDeptString = studentMulDeptString
            vc.studentConnDeptString = studentConnDeptString
            vc.studentPlaceString = studentPlaceString
            vc.studentHousePhoneString = studentHousePhoneString
            vc.studentPhoneString = studentPhoneString
            vc.studentMailString = studentMailString
            vc.studentProfessorString = studentProfessorString
            vc.studentConsultationString = studentConsultationString
            self.navigationController?.pushViewController(vc, animated: true)
        case 1: //성적표
            let vc = StudentReportViewController()
            vc.studentID = studentID
            vc.studentPW = studentPW
            vc.studentEntranceYearString = studentEntranceYearString
            vc.studentGraduationYearString = studentGraduationYearString
            self.navigationController?.pushViewController(vc, animated: true)
        case 2: //시간표
            let vc = StudentScheduleViewController()
            vc.studentID = studentID
            vc.studentPW = studentPW
            vc.studentEntranceYearString = studentEntranceYearString
            vc.studentGraduationYearString = studentGraduationYearString
            vc.studentResister = studentResister
            self.navigationController?.pushViewController(vc, animated: true)
            case 3: //장학정보
                let vc = StudentScholarshipViewController()
                vc.studentID = studentID
                vc.studentPW = studentPW
                self.navigationController?.pushViewController(vc, animated: true)
            default :
                return
            }
        
    }
}
