import UIKit
import Foundation
import Alamofire
import Kanna

class StudentScheduleViewController : UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate {
    //MARK: Data&Value
    //student Info
    var studentEntranceYearString: String = "" //입학년도
    var studentGraduationYearString: String = "" //졸업년도
    var studentID: String = "" //학번
    var studentPW: String = "" //비밀번호
    var scheduleYear: String = "2016"
    var scheduleSMT: Int = 10
    var studentResister: String = "" //학적상태
    
    //시간표
    let scheduleBaseView = UIView() //성적표가 올라가는 베이스 뷰
    let scheduleScrollView = UIScrollView() //시간표가 올라가는 뷰
    var yearPickerContent : [String] = []
    let semesterPickerContent : [String] = ["1학기","여름계절학기","2학기","겨울계절학기"]
    let yearPickerView = UITextField() //년도를 선택하는 뷰
    let semesterPickerView = UITextField() //학기를 선택하는 뷰
    let scheduleRowTitle : [String] = ["시간","월","화","수","목","금"]
    let scheduleColTitle : [String] = ["8","9","10","11","12","1","2","3","4","5","6","7","8","9","10"]
    var scheduleWidth : CGFloat = 0
    var scheduleHeight : CGFloat = 0
    var weekSchedule : [[classInfo]] = Array(repeating: [], count: 5) //월 ~ 금 그날의 수업 배열
    var weekClassNumberSet : Set<String> = []
    var weekClassNumberArray : [String] = []
    var extraClassColor : [UIColor] = [UIColor.red,UIColor.blue,UIColor.brown,UIColor.green,UIColor.gray,UIColor.orange,UIColor.cyan,UIColor.black,UIColor.magenta,UIColor.systemPink]
    var weekScheduleLabelList : [UILabel] = []
    var weekScheduleViewList : [UIView] = []
    //indicator설정
    let indicatorView = UIActivityIndicatorView()
    
    //MARK: UICreate
    func UICreate(){
        view.backgroundColor = .white
        //배경이미지
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: statusBarHeight+190)
        imageView.image = UIImage(named: "MinBackground.png")
        view.addSubview(imageView)
        //뒤로가기
        let backButton = UIButton()
        backButton.frame = CGRect(x: layoutMargin, y: statusBarHeight+10, width: 40, height: 40)
        backButton.backgroundColor = .clear
        backButton.addTarget(self, action: #selector(self.backButtonTouch(sender:)), for: .touchUpInside)
        view.addSubview(backButton)
        let backButtonImage = UIImageView()
        backButtonImage.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        backButtonImage.image = UIImage(named:"BackButton.png")
        backButton.addSubview(backButtonImage)
        //타이틀바
        let viewName = UILabel()
        viewName.frame = CGRect(x: backButton.frame.maxX+10, y: statusBarHeight+10, width: view.frame.width-layoutMargin-backButton.frame.width-20, height: navigationBarHeight)
        viewName.text = "시간표"
        viewName.font = UIFont(name: "NotoSansCJKkr-Bold", size: 30)
        viewName.textAlignment = .left
        viewName.textColor = .white
        viewName.layer.masksToBounds = false
        viewName.layer.shadowColor = UIColor.black.cgColor
        viewName.layer.shadowOffset = .zero
        viewName.layer.shadowOpacity = 0.5
        viewName.layer.shadowRadius = 7
        view.addSubview(viewName)
        //년도
        let yearBackView = UIView()
        yearBackView.frame = CGRect(x: 40, y: viewName.frame.maxY+10, width: (self.view.frame.width-100)/2, height: 30)
        yearBackView.backgroundColor = .clear
        view.addSubview(yearBackView)
        let yearLabel = UILabel()
        yearLabel.frame = CGRect(x: 0, y: 0, width: 30, height: yearBackView.frame.height)
        yearLabel.fontToFit(name:"NotoSansCJKkr-Regular",size:14)
        yearLabel.text = "년도"
        yearLabel.textAlignment = . center
        yearLabel.textColor = .white
        yearBackView.addSubview(yearLabel)
        let yearFieldBar = UIView()
        yearFieldBar.frame = CGRect(x: yearLabel.frame.maxX+5, y: 5, width: yearBackView.frame.width - yearLabel.frame.width - 10, height: yearBackView.frame.height-10)
        yearFieldBar.backgroundColor = UIColor(hex: 0x8FCBE3)
        yearBackView.addSubview(yearFieldBar)
        let yearPicker = UIPickerView()
        yearPicker.delegate = self
        yearPicker.tag = 1
        yearPickerView.delegate = self
        yearPickerView.text = self.yearPickerContent[self.yearPickerContent.count-1] //최신 년도
        yearPickerView.textColor = UIColor(hex:0x565656)
        yearPickerView.font = UIFont(name:"NotoSansCJKkr-Regular",size:12)
        yearPickerView.inputView = yearPicker
        yearPickerView.frame = CGRect(x: yearLabel.frame.maxX+5, y: 5, width: yearBackView.frame.width - yearLabel.frame.width - 10, height: yearBackView.frame.height-10)
        yearBackView.addSubview(yearPickerView)
        self.scheduleYear = self.yearPickerContent[self.yearPickerContent.count-1]
        let yearFieldPickerImage = UIImageView()
        let pickerImageHeight = yearFieldBar.frame.height-6
        yearFieldPickerImage.frame = CGRect(x: yearBackView.frame.width-pickerImageHeight-10, y: 5+yearFieldBar.frame.height/2-pickerImageHeight/2, width: pickerImageHeight, height: pickerImageHeight)
        yearFieldPickerImage.image = UIImage(named:"PickerViewButton.png")
        yearBackView.addSubview(yearFieldPickerImage)
        //학기
        let semesterBackView = UIView()
        semesterBackView.frame = CGRect(x: yearBackView.frame.maxX+10, y: viewName.frame.maxY+10, width: yearBackView.frame.width, height: yearBackView.frame.height)
        view.addSubview(semesterBackView)
        let semesterLabel = UILabel()
        semesterLabel.frame = CGRect(x: 0, y: 0, width: 30, height: semesterBackView.frame.height)
        semesterLabel.fontToFit(name:"NotoSansCJKkr-Regular",size:14)
        semesterLabel.text = "학기"
        semesterLabel.textAlignment = . center
        semesterLabel.textColor = .white
        semesterBackView.addSubview(semesterLabel)
        let semesterFieldBar = UIView()
        semesterFieldBar.frame = CGRect(x: semesterLabel.frame.maxX+5, y: 5, width: semesterBackView.frame.width - semesterLabel.frame.width - 10, height: semesterBackView.frame.height-10)
        semesterFieldBar.backgroundColor = UIColor(hex: 0x8FCBE3)
        semesterBackView.addSubview(semesterFieldBar)
        let semesterPicker = UIPickerView()
        semesterPicker.delegate = self
        semesterPicker.tag = 2
        semesterPickerView.delegate = self
        semesterPickerView.text = "1학기"
        semesterPickerView.textColor = UIColor(hex:0x565656)
        semesterPickerView.font = UIFont(name:"NotoSansCJKkr-Regular",size:12)
        semesterPickerView.inputView = semesterPicker
        semesterPickerView.frame = CGRect(x: semesterLabel.frame.maxX+5, y: 5, width: semesterBackView.frame.width - semesterLabel.frame.width - 10, height: semesterBackView.frame.height-10)
        semesterBackView.addSubview(semesterPickerView)
        let semesterFieldPickerImage = UIImageView()
        semesterFieldPickerImage.frame = CGRect(x: semesterBackView.frame.width-pickerImageHeight-10, y: 5+semesterFieldBar.frame.height/2-pickerImageHeight/2, width: pickerImageHeight, height: pickerImageHeight)
        semesterFieldPickerImage.image = UIImage(named:"PickerViewButton.png")
        semesterBackView.addSubview(semesterFieldPickerImage)
        //확인버튼
        let okButton = UIButton()
        okButton.frame = CGRect(x: 0, y: yearBackView.frame.maxY+10, width: 80, height: 30)
        okButton.center.x = self.view.center.x
        okButton.addTarget(self, action: #selector(self.okButtonTouch(sender:)), for: .touchUpInside)
        okButton.backgroundColor = UIColor.clear
        okButton.setTitle("확인", for: .normal)
        okButton.titleLabel?.font = UIFont(name:"NotoSansCJKkr-Regular",size:16)
        okButton.setTitleColor(UIColor.white, for: .normal)
        okButton.layer.borderColor = UIColor.white.cgColor
        okButton.layer.borderWidth = 2
        okButton.layer.cornerRadius = 6
        view.addSubview(okButton)
        //시간표가 올라가는 베이스뷰
        scheduleBaseView.frame = CGRect(x: 20, y: statusBarHeight + 150, width: self.view.frame.width - 40, height: self.view.frame.height - homeIndicatorHeight - statusBarHeight - 180)
        scheduleBaseView.backgroundColor = UIColor.white
        scheduleBaseView.layer.cornerRadius = 6
        scheduleBaseView.layer.shadowColor = UIColor.lightGray.cgColor
        scheduleBaseView.layer.shadowOpacity = 1
        scheduleBaseView.layer.shadowRadius = 7
        scheduleBaseView.layer.shadowOffset = .zero
        view.addSubview(scheduleBaseView)
        //시간표뷰길이
        self.scheduleWidth = scheduleBaseView.frame.width / 6
        self.scheduleHeight = 30
        //시간표 디폴트 값 설정
        for index in 0..<self.scheduleRowTitle.count {
            let label = UILabel()
            label.frame = CGRect(x: CGFloat(index)*self.scheduleWidth, y: 0, width: self.scheduleWidth, height: 40)
            if index != 0 {
                label.layer.addBorder([.left], color: UIColor.lightGray, width: 1)
            }
            label.layer.addBorder([.bottom], color: UIColor.lightGray, width: 1)
            label.text = self.scheduleRowTitle[index]
            label.textAlignment = .center
            label.font = UIFont(name:"NotoSansCJKkr-Regular",size:16)
            label.textColor = UIColor(hex:0x108DBE)
            scheduleBaseView.addSubview(label)
        }
        //시간표 뷰 생성
        scheduleScrollView.frame = CGRect(x:0,y:40,width:self.scheduleBaseView.frame.width,height:self.scheduleBaseView.frame.height - 40)
        scheduleScrollView.contentSize.height = CGFloat(self.scheduleColTitle.count) * self.scheduleHeight * 2
        //60*15
        scheduleScrollView.showsVerticalScrollIndicator = true
        scheduleScrollView.bounces = false
        scheduleBaseView.addSubview(scheduleScrollView)
        //시간대 표시
        for index in 0..<self.scheduleColTitle.count {
            let label = UILabel()
            label.frame = CGRect(x: 0, y: CGFloat(index)*scheduleHeight*2, width: self.scheduleWidth, height: self.scheduleHeight*2)
            if index != 0 {
                label.layer.addBorder([.top], color: UIColor.lightGray, width: 1)
            }
            label.text = self.scheduleColTitle[index]
            label.textAlignment = .center
            label.font = UIFont(name:"NotoSansCJKkr-Regular",size:16)
            label.textColor = UIColor(hex:0x108DBE)
            scheduleScrollView.addSubview(label)
        }
        //격자 표시
        for weekIndex in 0..<5{
            for index in 0..<self.scheduleColTitle.count*2 {
                let view = UIView()
                view.frame = CGRect(x: self.scheduleWidth+CGFloat(weekIndex)*self.scheduleWidth, y: CGFloat(index)*self.scheduleHeight, width: self.scheduleWidth, height: self.scheduleHeight)
                if index != 0 {
                    view.layer.addBorder([.top,.left], color: UIColor.lightGray, width: 1)
                }
                else{
                    view.layer.addBorder([.left], color: UIColor.lightGray, width: 1)
                }
                scheduleScrollView.addSubview(view)
            }
        }
        //indicator
        indicatorView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        indicatorView.backgroundColor = UIColor(hex: 0x231815, alpha: 0.5)
        indicatorView.style = .large
        indicatorView.color = UIColor.white
        self.view.addSubview(indicatorView)
    }
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        studentYearDataGet() //사용가능한 년도 받아오기
        self.UICreate()
    }
    //MARK: 사용가능한 년도 받아오기
    func studentYearDataGet(){
        //현재년도
        var currentYear: Int = 0
        let dateFormatter = DateFormatter() //날짜형식
        dateFormatter.dateFormat = "yyyy"
        currentYear = (dateFormatter.string(from: Date()) as NSString).integerValue
        //졸업 여부에 따라 최대 년도가 결정
        if self.studentGraduationYearString.count == 0 { //졸업 안한 상태
            let start = studentEntranceYearString.index(studentEntranceYearString.startIndex, offsetBy: 0)
            let end = studentEntranceYearString.index(studentEntranceYearString.startIndex, offsetBy: 3)
            let range = start...end
            let startYear: Int = Int(studentEntranceYearString[range]) ?? currentYear
            for year in startYear...currentYear {
                yearPickerContent.append("\(year)")
            }
        }
        else { // 졸업 한 상태
            //종료년도
            var start = studentGraduationYearString.index(studentGraduationYearString.startIndex, offsetBy: 0)
            var end = studentGraduationYearString.index(studentGraduationYearString.startIndex, offsetBy: 3)
            var range = start...end
            let endYear: Int = Int(studentEntranceYearString[range]) ?? currentYear
            //시작년도
            start = studentEntranceYearString.index(studentEntranceYearString.startIndex, offsetBy: 0)
            end = studentEntranceYearString.index(studentEntranceYearString.startIndex, offsetBy: 3)
            range = start...end
            let startYear: Int = Int(studentEntranceYearString[range]) ?? endYear
            for year in startYear...endYear {
                yearPickerContent.append("\(year)")
            }
        }
    }
    //MARK: BackButton
    @objc func backButtonTouch(sender: UIButton) {
        print("backButtonTouch")
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: okButtonTouch
        @objc func okButtonTouch(sender:UIButton){ //시간표 조회
            //받아올 시간표 파라미터 설정
            if studentResister == "휴학" || studentResister == "졸업" {
                let message_Alert = UIAlertController(title: "", message: "졸업생 및 휴학생은 이용이 불가능합니다", preferredStyle: UIAlertController.Style.alert)
                let OK_Action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                message_Alert.addAction(OK_Action)
                self.present(message_Alert, animated: true, completion: nil)
            }
            else{
                let parameters: [String: Any] = [ //해당 웹에 넘겨줄 파라미터
                    "userid": "\(self.studentID)",
                    "passwd": "\(self.studentPW)",
                    "year": "\(self.scheduleYear)",
                    "smt": "\(self.scheduleSMT)"
                ]
                indicatorView.startAnimating()
                Alamofire.request(
                    studentTimeTableInfoURL,
                    method: .post,
                    parameters: parameters).responseString { response in
                        self.indicatorView.stopAnimating()
                        if response.result.isSuccess {
                            let Sleep_responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                            if (Sleep_responseString?.contains("htblTime2"))! {
                                self.scheduleDataGet(html:Sleep_responseString! as String)
                            }
                            else{
                                let message_Alert = UIAlertController(title: "", message: "해당 시간표가 없습니다.", preferredStyle: UIAlertController.Style.alert)
                                let OK_Action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: nil)
                                message_Alert.addAction(OK_Action)
                                self.present(message_Alert, animated: true, completion: nil)
                            }
                        } else {
                            print("통신실패")
                        }
                }
            }
        }
    func scheduleDataGet(html: String){
        //데이터 초기화
        self.weekClassNumberArray = []
        self.weekClassNumberSet = []
        weekSchedule = Array(repeating: [], count: 5) //수업배열초기화
        //데이터 불러오기
        if let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            for weekIndex in 2...6 { //1교시 ~ 30교시
                for classIndex in 2...31 { //월 ~ 금
                    let str = doc.xpath("//table[@id='htblTime2']//tr[\(classIndex)]//td[\(weekIndex)]//text()")
                    var classNumber : String = "" //과목번호
                    var classDivide : String = "" //과목분반
                    var className : String = "" //과목명
                    var classLocation : String = "" //과목위치
                    for index in 0..<str.count/2 {
                        let content = str[index].text ?? ""
                        switch index {
                        case 0 :
                            //과목코드
                            var start = content.index(content.startIndex, offsetBy: 0)
                            var end = content.index(content.startIndex, offsetBy: 6)
                            var range = start..<end
                            classNumber = String(content[range])
                            //과목 분반
                            start = content.index(content.startIndex, offsetBy: 7)
                            end = content.index(content.startIndex, offsetBy: 9)
                            range = start..<end
                            classDivide = String(content[range])
                            break
                        case 1 :
                            className = content
                        case 2:
                            classLocation = content
                        default :
                            break
                        }
                    }
                    //과목번호, 과목분반, 과목명, 과목위치 값저장 완료
                    if classNumber != "" { //수업이 있음
                        var check = false //이전에 저장한 수업인지 아닌지
                        for index in 0..<weekSchedule[weekIndex-2].count {
                            if weekSchedule[weekIndex-2][index].classNumber == classNumber { //같은수업존재
                                weekSchedule[weekIndex-2][index].numberOfClass += 1
                                check = true
                                break
                            }
                        }
                        if check == false { //같은 수업 없음
                            let study = classInfo(classNumber: classNumber, classDivide: classDivide, className: className, classLocation: classLocation, classStart: classIndex-1, numberOfClass: 1)
                            self.weekSchedule[weekIndex-2].append(study)
                            self.weekClassNumberSet.insert(classNumber) //중복값을 걸러내기 위해 set사용
                        }
                    }
                }
            }
            //전체 과목 조사 완료
            for week in self.weekClassNumberSet {
                self.weekClassNumberArray.append(week) //색 참조를 위해 고정된위치가 필요해 set 대신 Array에 저장
            }
        }
        classCreate()
    }
    //MARK: 실질적인 수업뷰 생성
    func classCreate(){
        for label in self.weekScheduleLabelList {
            label.removeFromSuperview()
        }
        for view in self.weekScheduleViewList {
            view.removeFromSuperview()
        }
        for weekIndex in 0..<5 { //월 ~ 금
            for info in self.weekSchedule[weekIndex] { //1교시 ~ 30교시
                let view = UIView()
                let label = UILabel()
                label.numberOfLines = 0
                if info.classStart > 20 { //25분 수업
                    view.frame = CGRect(x: self.scheduleWidth+CGFloat(weekIndex)*self.scheduleWidth, y: 20*scheduleHeight+CGFloat(info.classStart-21)*(scheduleHeight/6*5), width: self.scheduleWidth, height: (scheduleHeight/6*5)*CGFloat(info.numberOfClass))
                }
                else{ //30분 수업
                    view.frame = CGRect(x: self.scheduleWidth+CGFloat(weekIndex)*self.scheduleWidth, y: CGFloat(info.classStart-1)*scheduleHeight, width: self.scheduleWidth, height: scheduleHeight*CGFloat(info.numberOfClass))
                }
                view.layer.addBorder([.left,.right,.top,.bottom], color: UIColor.white, width: 0.5)
                label.frame = CGRect(x:3,y:3,width:view.frame.width-6,height:view.frame.height-6)
                view.backgroundColor = UIColor(hex:0x4898C1,alpha: 0.7)
                label.text = "\(info.className)\n\(info.classLocation)"
                label.font = UIFont(name:"NotoSansCJKkr-Regular",size:10)
                label.adjustsFontSizeToFitWidth = true
                label.textColor = UIColor.white
                view.addSubview(label)
                self.scheduleScrollView.addSubview(view)
                weekScheduleViewList.append(view)
                weekScheduleLabelList.append(label)
            }
        }
    }
    //MARK: 피커뷰 설정
    func numberOfComponents(in pickerView: UIPickerView) -> Int { //내부 피커 수
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { //피커 컴포넌트 수
        if pickerView.tag == 1 { //year
             return self.yearPickerContent.count
        }
        else { //semester
             return self.semesterPickerContent.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { //피커 컴포넌트 이름
        if pickerView.tag == 1 { //year
             return self.yearPickerContent[row]
        }
        else { //semester
             return self.semesterPickerContent[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { //선택 후 실행
        if pickerView.tag == 1 { //year
            self.scheduleYear = self.yearPickerContent[row]
            self.yearPickerView.text = self.yearPickerContent[row]
        }
        else { //semester
            switch row {
            case 0 :
                self.scheduleSMT = 10
            case 1 :
                self.scheduleSMT = 11
            case 2 :
                self.scheduleSMT = 20
            case 3 :
                self.scheduleSMT = 21
            default :
                break
            }
            self.semesterPickerView.text = self.semesterPickerContent[row]
        }
        self.view.endEditing(true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
