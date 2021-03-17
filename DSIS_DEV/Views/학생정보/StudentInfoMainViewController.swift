import Foundation
import UIKit
import Alamofire
import Kanna

class StudentInfoMainViewController : UIViewController, UITextFieldDelegate {
    //MARK: Value
    let studentID = UITextField()
    let studentPW = UITextField()
    //indicator설정
    let indicatorView = UIActivityIndicatorView()
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
        //로고
        let pinImage = UIImageView()
        pinImage.frame.size = CGSize(width: self.view.frame.width/3, height: self.view.frame.width/3)
        pinImage.center.x = self.view.center.x
        pinImage.frame.origin.y = navigationBarHeight+50
        pinImage.image = UIImage(named: "MainLogo.png")
        self.view.addSubview(pinImage)
        //타이틀 기준 뷰
        let titleCenterY : CGFloat = pinImage.frame.maxY+((self.view.frame.height/2+40)-pinImage.frame.maxY)/2
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
        titleView.center.y = titleCenterY
        self.view.addSubview(titleView)
        //학생정보
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
        titleLabel.text = "학생정보"
        titleLabel.font = UIFont(name: "NotoSansCJKkr-Bold", size: 30)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleView.addSubview(titleLabel)
        //시스템
        let titleLabel2 = UILabel()
        titleLabel2.frame = CGRect(x: 0, y: titleLabel.frame.maxY, width: view.frame.width, height: 30)
        titleLabel2.text = "시스템"
        titleLabel2.font = UIFont(name: "NotoSansCJKkr-Bold", size: 20)
        titleLabel2.textAlignment = .center
        titleLabel2.textColor = UIColor.white
        titleView.addSubview(titleLabel2)
        //학번
        studentID.text = ""
        studentID.frame = CGRect(x: self.view.frame.width/5, y: self.view.frame.height/2+40, width: self.view.frame.width/5*3, height: 50)
        studentID.attributedPlaceholder = NSAttributedString(string: "학번", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        studentID.font = UIFont(name: "NotoSansCJKkr-Regular", size: 16)
        studentID.clearButtonMode = .whileEditing
        studentID.textColor = UIColor.white
        studentID.delegate = self
        studentID.returnKeyType = .next
        studentID.tag = 1
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        view.addSubview(studentID)
        let studentIDLine = UIView()
        studentIDLine.frame = CGRect(x: studentID.frame.minX, y: studentID.frame.maxY, width: studentID.frame.width, height: 1)
        studentIDLine.backgroundColor = UIColor.white
        view.addSubview(studentIDLine)
        //비밀번호
        studentPW.text = ""
        studentPW.frame = CGRect(x: self.view.frame.width/5, y: studentID.frame.maxY, width: self.view.frame.width/5*3, height: 50)
        studentPW.attributedPlaceholder = NSAttributedString(string: "비밀번호", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        studentPW.font = UIFont(name: "NotoSansCJKkr-Regular", size: 16)
        studentPW.textColor = UIColor.white
        studentPW.isSecureTextEntry = true
        studentPW.delegate = self
        studentPW.returnKeyType = .default
        studentPW.clearButtonMode = .whileEditing
        studentPW.tag = 2
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardwillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        view.addSubview(studentPW)
        let studentPWLine = UIView()
        studentPWLine.frame = CGRect(x: studentPW.frame.minX, y: studentPW.frame.maxY, width: studentPW.frame.width, height: 1)
        studentPWLine.backgroundColor = .white
        view.addSubview(studentPWLine)
        //로그인버튼
        let loginButton = UIButton()
        loginButton.frame = CGRect(x: self.view.frame.width/5, y: studentPW.frame.maxY+20, width: self.view.frame.width/5*3, height: 50)
        loginButton.backgroundColor = UIColor.white
        loginButton.layer.borderColor = UIColor(hex: 0x359dd1).cgColor
        loginButton.layer.borderWidth = 1
        loginButton.layer.shadowColor = UIColor.lightGray.cgColor
        loginButton.layer.shadowOpacity = 1
        loginButton.layer.shadowRadius = 7
        loginButton.layer.shadowOffset = .zero
        loginButton.addTarget(self, action: #selector(self.loginButtonTouch(sender:)), for: .touchUpInside)
        loginButton.layer.cornerRadius = loginButton.frame.height/2
        loginButton.setTitle("Login", for: .normal)
        loginButton.setTitleColor(UIColor(hex:0x108DBE), for: .normal)
        loginButton.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Regular",size:20)
        view.addSubview(loginButton)
        //indicator
        indicatorView.frame = CGRect(x:0,y:0,width:self.view.frame.width,height:self.view.frame.height)
        indicatorView.backgroundColor = UIColor(hex: 0x231815, alpha: 0.5)
        indicatorView.style = .large
        indicatorView.color = UIColor.white
        self.view.addSubview(indicatorView)
    }
    //MARK: 로그인버튼 클릭
    @objc func loginButtonTouch(sender:UIButton){
        self.studentID.resignFirstResponder()
        self.studentPW.resignFirstResponder()
        //예전 동의를 한적이 있는지 정보를 받음
        let plist = UserDefaults.standard
        let preAlert = plist.object(forKey: "동의") as? String
        Alamofire.request(pInfoCheckURL).responseJSON { (response)in
            if response.result.isSuccess {
                guard let data = response.data else {
                    DispatchQueue.main.async {
                        self.errorAlertView()
                    }
                    return
                }
                do {
                    let personalInfoData = try JSONDecoder().decode(personalInfoParse.self, from: data)
                    DispatchQueue.main.async {
                        if (preAlert == nil) || (preAlert != personalInfoData.now_p_info_vs[0].now_p_info_vs) { //첫 동의 || 재동의 필요
                            print("첫동의")
                            let vc = AgreeAlertViewController()
                            vc.modalPresentationStyle = .overFullScreen
                            vc.agreeVersion = personalInfoData.now_p_info_vs[0].now_p_info_vs
                            self.present(vc,animated: false,completion: nil)
                        }
                        else{ //현버전 동의
                            print("동의한상태")
                            self.studentInfoRequest()
                        }
                    }
                } catch let jsonErr {
                    print("Error = \(jsonErr)")
                }
            }
            else{
                DispatchQueue.main.async {
                    self.errorAlertView()
                }
                return
            }
        }
    }
    //MARK: studentInfoRequest
    func studentInfoRequest(){
        let parameters: [String: Any] = [ //해당 웹에 넘겨줄 파라미터
            "userid": "\(self.studentID.text!)",
            "passwd": "\(self.studentPW.text!)"
        ]
        indicatorView.startAnimating()
        Alamofire.request(
            studentInfoURL,
            method: .post,
            parameters: parameters).responseString { response in
                self.indicatorView.stopAnimating()
                if response.result.isSuccess {
                    let Sleep_responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue )
                    if (Sleep_responseString?.contains("학번 또는 비밀번호가 틀렸습니다"))! {
                        let message_Alert = UIAlertController(title: "", message: "학번 또는 비밀번호가 틀렸습니다", preferredStyle: UIAlertController.Style.alert)
                        let OK_Action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                        message_Alert.addAction(OK_Action)
                        self.present(message_Alert, animated: true, completion: nil)
                    } else if (Sleep_responseString?.contains("3개월동안"))! {
                        let message_Alert = UIAlertController(title: "", message: "3개월동안 비밀번호를 변경하지 않아 비밀번호 변경이 필요합니다\n변경후 이용해주시기 바랍니다", preferredStyle: UIAlertController.Style.alert)
                        let OK_Action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                        message_Alert.addAction(OK_Action)
                        self.present(message_Alert, animated: true, completion: nil)
                    } else {
                        self.userDataGet(html: Sleep_responseString! as String)
                    }
                } else {
                    print("통신실패")
                }
        }
    }
//    func studentInfoRequest(){
//        let parameters: [String: Any] = [ //해당 웹에 넘겨줄 파라미터
//            "userid": "\(self.studentID.text!)",
//            "passwd": "\(self.studentPW.text!)"
//        ]
//        print("\(self.studentID.text!)")
////        indicatorView.startAnimating()
//        Alamofire.request(studentInfoPyURL,parameters: parameters).responseJSON{ (response) in
//            guard let data = response.data else { return }
//            print("\(data)")
//            let log = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
//            print(log)
//        }
//    }
    //MARK: userDataGet
    func userDataGet(html: String) {
        if let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            let nameTag: String = doc.xpath("//*[@id='lblKorNm']")[0].text ?? ""
            let numberTag: String = doc.xpath("//*[@id='lblStudentCd']")[0].text ?? ""
            let collegeTag: String = doc.xpath("//*[@id='lblCollegeNm']")[0].text ?? ""
            let deptTag: String = doc.xpath("//*[@id='lblDeptNm']")[0].text ?? ""
            let birthdayTag: String = doc.xpath("//*[@id='lblIdNum']")[0].text ?? ""
            let specializeTag: String = doc.xpath("//*[@id='lblMajorNm']")[0].text ?? ""
            let dayOrNightTag: String = doc.xpath("//*[@id='lblClassDiv']")[0].text ?? ""
            let gradeTag: String = doc.xpath("//*[@id='lblStudentYear']")[0].text ?? ""
            let resisterTag: String = doc.xpath("//*[@id='lblSchoolSts']")[0].text ?? ""
            let subDeptTag: String = doc.xpath("//*[@id='lblMinor']")[0].text ?? ""
            let mulDeptTag: String = doc.xpath("//*[@id='lblSmajor']")[0].text ?? ""
            let connDeptTag: String = doc.xpath("//*[@id='lblRmajor']")[0].text ?? ""
            let placeTag: String = doc.xpath("//*[@id='lblRAdd']")[0].text ?? ""
            let housePhoneTag: String = doc.xpath("//*[@id='lblTel']")[0].text ?? ""
            let phoneTag: String = doc.xpath("//*[@id='lblStudentPcs']")[0].text ?? ""
            let mailTag: String = doc.xpath("//*[@id='lblEmail']")[0].text ?? ""
            let professorTag: String = doc.xpath("//*[@id='lblProfNm']")[0].text ?? ""
            let consultationTag: String = doc.xpath("//*[@id='lblAdviseYn']")[0].text ?? ""
            let entranceYear: String = doc.xpath("//*[@id='lblEntDt']")[0].text ?? ""
            let graduationYear : String = doc.xpath("//*[@id='lblGdtDt']")[0].text ?? ""
            
            DispatchQueue.main.async {
                let vc = StudentHomeViewController()
                vc.studentID = self.studentID.text!
                vc.studentPW = self.studentPW.text!
                vc.studentNameString = nameTag
                vc.studentNumberString = numberTag
                vc.studentCollegeString = collegeTag
                vc.studentDeptString = deptTag
                vc.studentBirthDayString = birthdayTag
                vc.studentSpecializeString = specializeTag
                vc.studentDayorNightString = dayOrNightTag
                vc.studentGradeString = gradeTag
                vc.studentResister = resisterTag
                vc.studentSubDeptString = subDeptTag
                vc.studentMulDeptString = mulDeptTag
                vc.studentConnDeptString = connDeptTag
                vc.studentPlaceString = placeTag
                vc.studentHousePhoneString = housePhoneTag
                vc.studentPhoneString = phoneTag
                vc.studentMailString = mailTag
                vc.studentProfessorString = professorTag
                vc.studentConsultationString = consultationTag
                vc.studentEntranceYearString = entranceYear
                vc.studentGraduationYearString = graduationYear
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    //MARK: errorAlertView
    func errorAlertView(){
        let message_Alert = UIAlertController(title: "", message: "현재는 이용이 불가능합니다. 불편을 드려 죄송합니다.", preferredStyle: UIAlertController.Style.alert)
        let OK_Action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
        message_Alert.addAction(OK_Action)
    }
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UICreate()
    }
    //MARK: 뒤로가기 버튼
    @objc func backButtonTouch(sender: UIButton) {
        print("backButtonTouch")
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: 키보드 관련 함수
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            self.studentPW.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -150
    }
    @objc func keyboardwillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0
    }
    //MARK: 빈곳을 터치
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
