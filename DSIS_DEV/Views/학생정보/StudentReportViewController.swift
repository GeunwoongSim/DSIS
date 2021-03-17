import Foundation
import UIKit
import Alamofire
import Kanna

class StudentReportViewController : UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    //카테고리
    let studentReportMenuString: [String] = ["전체성적표", "일부성적표", "이수구분별","누계성적표"]
    var reportRadioButton: [UIButton] = [] //category Button
    var reportRadioImage: [UIImageView] = [] //categoryButton의 라디오 이미지
    
    //성적표
    let reportTitleString : [[String]] = [["년도","학기","교과목명","이수구분","학점","성적"],["년도","학기","교과목명","이수구분","학점","성적"],[],["년도","학기","신청학점","취득학점","누계성적"]]
    let reportTitleScale :[[CGFloat]] = [[2,2,6,4,2,2],[2,2,6,4,2,2],[],[3,3,4,4,4]] //비율
    let reportBaseView = UIView() //성적표가 올라가는 베이스 뷰
    let reportScrollView = UIScrollView() //실제 성적표가 올라가는 스크롤뷰
    var yearPickerContent : [String] = []
    let semesterPickerContent : [String] = ["1학기","여름계절학기","2학기","겨울계절학기"]
    let yearPickerView = UITextField() //년도를 선택하는 뷰
    let semesterPickerView = UITextField() //학기를 선택하는 뷰
    var contentWidthValue : CGFloat = 0
    
    //Data
    //student Info
    var studentEntranceYearString: String = "" //입학년도
    var studentGraduationYearString: String = "" //졸업년도
    var studentID: String = "" //학번
    var studentPW: String = "" //비밀번호
    var reportCategory: Int = 1
    var reportYear: String = "2016"
    var reportSMT: Int = 10
    
    //indicator설정
    let indicatorView = UIActivityIndicatorView()
    
    //MARK: UICreate
    func UICreate(){
        self.view.backgroundColor = UIColor.white
        contentWidthValue = (self.view.frame.width - 40) / 18
        //배경 이미지
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: statusBarHeight+250)
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
        viewName.text = "성적표"
        viewName.font = UIFont(name: "NotoSansCJKkr-Bold", size: 30)
        viewName.textAlignment = .left
        viewName.textColor = .white
        viewName.layer.masksToBounds = false
        viewName.layer.shadowColor = UIColor.black.cgColor
        viewName.layer.shadowOffset = .zero
        viewName.layer.shadowOpacity = 0.5
        viewName.layer.shadowRadius = 7
        view.addSubview(viewName)
        //성적표 구분
        var viewMinX : CGFloat = 0
        for viewIndex in 0..<studentReportMenuString.count {
            if viewIndex == 2{
                let radioImage = UIImageView()
                self.reportRadioImage.append(radioImage)
                continue
            }
            let reportMenu = UIButton()
            reportRadioButton.append(reportMenu)
            reportMenu.addTarget(self, action: #selector(self.reportMenuButtonTouch(sender: )), for: .touchUpInside)
            reportMenu.tag = viewIndex+1
            reportMenu.frame = CGRect(x: 20+viewMinX*(self.view.frame.width-40)/3, y: viewName.frame.maxY+10, width: (self.view.frame.width-40)/3, height: 40)
            reportMenu.backgroundColor = .clear
            view.addSubview(reportMenu)
            let radioImage = UIImageView()
            self.reportRadioImage.append(radioImage)
            radioImage.image = viewIndex == 0 ? UIImage(named:"RadioButtonFull.png") : UIImage(named:"RadioButtonBlank.png")
            radioImage.frame = CGRect(x: 5, y: 10, width: 20, height: 20)
            reportMenu.addSubview(radioImage)
            let radioTitle = UILabel()
            radioTitle.frame = CGRect(x: radioImage.frame.maxX+5, y: 0, width: reportMenu.frame.width-30, height: reportMenu.frame.height)
            radioTitle.text = self.studentReportMenuString[viewIndex]
            radioTitle.textAlignment = .center
            radioTitle.textColor = UIColor(hex:0xF9F7F7)
            radioTitle.fontToFit(name:"NotoSansCJKkr-Regular",size:14)
            reportMenu.addSubview(radioTitle)
            viewMinX += 1
        }
        //년도
        let yearBackView = UIView()
        yearBackView.frame = CGRect(x: 40, y: reportRadioButton[0].frame.maxY+10, width: (self.view.frame.width-100)/2, height: 30)
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
        yearPickerView.isEnabled = false
        yearPickerView.text = ""
        yearPickerView.textColor = UIColor(hex:0x565656)
        yearPickerView.font = UIFont(name:"NotoSansCJKkr-Regular",size:12)
        yearPickerView.inputView = yearPicker
        yearPickerView.frame = CGRect(x: yearLabel.frame.maxX+5, y: 5, width: yearBackView.frame.width - yearLabel.frame.width - 10, height: yearBackView.frame.height-10)
        yearBackView.addSubview(yearPickerView)
        let yearFieldPickerImage = UIImageView()
        let pickerImageHeight = yearFieldBar.frame.height-6
        yearFieldPickerImage.frame = CGRect(x: yearBackView.frame.width-pickerImageHeight-10, y: 5+yearFieldBar.frame.height/2-pickerImageHeight/2, width: pickerImageHeight, height: pickerImageHeight)
        yearFieldPickerImage.image = UIImage(named:"PickerViewButton.png")
        yearBackView.addSubview(yearFieldPickerImage)
        //학기
        let semesterBackView = UIView()
        semesterBackView.frame = CGRect(x: yearBackView.frame.maxX+10, y: reportRadioButton[0].frame.maxY+10, width: yearBackView.frame.width, height: yearBackView.frame.height)
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
        semesterPickerView.isEnabled = false
        semesterPickerView.text = ""
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
        //성적표가 올라가는 흰 배경
        reportBaseView.frame = CGRect(x: 20, y: statusBarHeight + 200, width: self.view.frame.width - 40, height: self.view.frame.height - homeIndicatorHeight - statusBarHeight - 220)
        reportBaseView.backgroundColor = UIColor.white
        reportBaseView.layer.shadowColor = UIColor.lightGray.cgColor
        reportBaseView.layer.shadowOpacity = 1
        reportBaseView.layer.shadowRadius = 7
        reportBaseView.layer.shadowOffset = .zero
        reportBaseView.layer.cornerRadius = 5
        view.addSubview(reportBaseView)
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
        self.studentYearDataGet()//학생 정보 받아오기
        self.UICreate()
    }
    //MARK: BackButton
    @objc func backButtonTouch(sender: UIButton) {
        print("backButtonTouch")
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: 조회가능 년도 받아오기
    func studentYearDataGet(){ //일부성적표에서 조회가능한 년도 데이터 가져오기
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
    //MARK: okButtonTouch
    @objc func okButtonTouch(sender:UIButton){ //성적 조회
        for view in self.reportScrollView.subviews {
            view.removeFromSuperview()
        }
        for view in self.reportBaseView.subviews {
            view.removeFromSuperview()
        }
        var titleMinX : CGFloat = 0
        for titleIndex in 0..<self.reportTitleString[self.reportCategory-1].count {
            let label = UILabel()
            label.frame = CGRect(x: titleMinX, y: 0, width: self.reportTitleScale[self.reportCategory-1][titleIndex]*contentWidthValue, height: 50)
            titleMinX += self.reportTitleScale[self.reportCategory-1][titleIndex]*contentWidthValue
            label.text = self.reportTitleString[self.reportCategory-1][titleIndex]
            label.textAlignment = .center
            label.font = UIFont(name: "NotoSansCJKkr-Regular", size: 14)
            label.textColor = UIColor(hex:0x268BB7)
            if titleIndex != 0 {
                label.layer.addBorder([.bottom,.left], color: UIColor.lightGray, width: 1)
            }
            else{
                label.layer.addBorder([.bottom], color: UIColor.lightGray, width: 1)
            }
            self.reportBaseView.addSubview(label)
        }
        //성적표가 올라가는 스크롤뷰
        reportScrollView.frame = CGRect(x: 0, y: 50, width: reportBaseView.frame.width, height: reportBaseView.frame.height - 50)
        reportScrollView.showsVerticalScrollIndicator = false
        reportScrollView.contentSize.height = 2*view.frame.height
        reportBaseView.addSubview(reportScrollView)
        //받아올 성적표 파라미터 설정
        let parameters: [String: Any] = [ //해당 웹에 넘겨줄 파라미터
            "userid": "\(self.studentID)",
            "passwd": "\(self.studentPW)",
            "mode": "\(self.reportCategory)",
            "year": "\(self.reportYear)",
            "smt": "\(self.reportSMT)"
        ]
        indicatorView.startAnimating()
        Alamofire.request(
            studentAchievementInfoURL,
            method: .post,
            parameters: parameters).responseString { response in
                self.indicatorView.stopAnimating()
                if response.result.isSuccess {
                    let Sleep_responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                    switch self.reportCategory {
                    case 1 : // 전체성적
                        self.allReportDataGet(html: Sleep_responseString! as String)
                    case 2 : // 일부성적
                        self.partReportDataGet(html: Sleep_responseString! as String)
                    case 3 : // 이수구구분별성적
                        break
                    case 4 : // 누계성적
                        self.accumulateReportDataGet(html: Sleep_responseString! as String)
                    default :
                        break
                    }
                } else {
                    print("통신실패")
                }
        }
    }
    //MARK: 누계성적표
    func accumulateReportDataGet(html: String) {
        if let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            let test = doc.xpath("//table[@id='dgList1']//tr//td")
            DispatchQueue.main.async {
                var viewNumber: CGFloat = 0
                var viewYear: String = "" //년도
                var viewSemester: String = "" //학기
                var viewProposal: String = "" //신청학점
                var viewAcquire: String = "" //취득학점
                var viewAvg: String = "" //평점
                for testIndex in 6..<test.count {
                    let text = test[testIndex].text ?? ""
                    switch testIndex % 6 {
                        case 0: //년도
                            viewYear = text
                        case 1: //학기
                            viewSemester = text
                        case 2: //신청학점
                            viewProposal = text
                        case 3: //취득학점
                            viewAcquire = text
                        case 4: //이수구분
                            viewAvg = text
                        case 5: //비고
                            //상세 성적표 올라가는 뷰
                            let reportView = UIView()
                            reportView.frame = CGRect(x: 0, y: viewNumber*40, width: self.reportScrollView.frame.width, height: 40)
                            reportView.layer.addBorder([.bottom], color: UIColor.lightGray, width: 1)
                            self.reportScrollView.addSubview(reportView)
                            //상세 성적표 년도
                            let reportYear = UILabel()
                            reportYear.frame = CGRect(x: 0, y: 0, width: self.contentWidthValue*3, height: reportView.frame.height)
                            reportYear.text = viewYear
                            reportYear.textAlignment = .center
                            reportYear.font = UIFont(name:"NotoSansCJKkr-Regular",size:12)
                            reportYear.adjustsFontSizeToFitWidth = true
                            reportYear.textColor = UIColor.black
                            reportView.addSubview(reportYear)
                            //상세 성적표 학기
                            let reportSemester = UILabel()
                            reportSemester.frame = CGRect(x: reportYear.frame.maxX, y: 0, width: self.contentWidthValue*3, height: reportView.frame.height)
                            reportSemester.text = viewSemester
                            reportSemester.textAlignment = .center
                            reportSemester.font = UIFont(name:"NotoSansCJKkr-Regular",size:12)
                            reportSemester.textColor = UIColor.black
                            reportSemester.adjustsFontSizeToFitWidth = true
                            reportSemester.numberOfLines = 2
                            reportView.addSubview(reportSemester)
                            //상세 성적표 신청학점
                            let reportProposal = UILabel()
                            reportProposal.frame = CGRect(x: reportSemester.frame.maxX, y: 0, width: self.contentWidthValue*4, height: reportView.frame.height)
                            reportProposal.text = viewProposal
                            reportProposal.textAlignment = .center
                            reportProposal.font = UIFont(name:"NotoSansCJKkr-Regular",size:12)
                            reportProposal.textColor = UIColor.black
                            reportProposal.adjustsFontSizeToFitWidth = true
                            reportView.addSubview(reportProposal)
                            //상세 성적표 취득학점
                            let reportAcquire = UILabel()
                            reportAcquire.frame = CGRect(x: reportProposal.frame.maxX, y: 0, width: self.contentWidthValue*4, height: reportView.frame.height)
                            reportAcquire.text = viewAcquire
                            reportAcquire.textAlignment = .center
                            reportAcquire.font = UIFont(name:"NotoSansCJKkr-Regular",size:12)
                            reportAcquire.textColor = UIColor.black
                            reportAcquire.adjustsFontSizeToFitWidth = true
                            reportView.addSubview(reportAcquire)
                            //상세 성적표 평점
                            let reportAvg = UILabel()
                            reportAvg.frame = CGRect(x: reportAcquire.frame.maxX, y: 0, width: self.contentWidthValue*4, height: reportView.frame.height)
                            reportAvg.text = viewAvg
                            reportAvg.textAlignment = .center
                            reportAvg.font = UIFont(name:"NotoSansCJKkr-Regular",size:12)
                            reportAvg.textColor = UIColor.black
                            reportView.addSubview(reportAvg)
                            viewNumber = viewNumber + 1
                        default :
                            break
                        }
                    }
                    self.reportScrollView.contentSize.height = viewNumber*40
                }
        }
    }
    //MARK: 학기성적표
    func partReportDataGet(html: String){
        if let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            let test = doc.xpath("//table[@id='dgList1']//tr//td")
            DispatchQueue.main.async {
                var viewNumber: CGFloat = 0
                var viewYear: String = "" //년도
                var viewSemester: String = "" //학기
                var viewName: String = "" //수업명
                var viewDiv: String = "" //이수구분
                var viewPoint: String = "" //학점
                var viewResult: String = "" //성적
                for testIndex in 10..<test.count {
                    let text = test[testIndex].text ?? ""
                    switch testIndex % 10 {
                    case 0: //년도
                        viewYear = text
                    case 1: //학기
                        viewSemester = text
                    case 2: //과목코드
                        break
                    case 3: //수업명
                        viewName = text
                    case 4: //이수구분
                        viewDiv = text
                    case 5: //학점
                        viewPoint = text
                    case 6: //성적
                        viewResult = text
                    case 7: //평점
                        break
                    case 8: //평점*학점
                        break
                    case 9: //비고
                        //상세 성적표 올라가는 뷰
                        let reportView = UIView()
                        reportView.frame = CGRect(x: 0, y: viewNumber*40, width: self.reportScrollView.frame.width, height: 40)
                        reportView.layer.addBorder([.bottom], color: UIColor.lightGray, width: 1)
                        self.reportScrollView.addSubview(reportView)
                        //상세 성적표 년도
                        let reportYear = UILabel()
                        reportYear.frame = CGRect(x: 0, y: 0, width: self.contentWidthValue*2, height: reportView.frame.height)
                        reportYear.text = viewYear
                        reportYear.textAlignment = .center
                        reportYear.font = UIFont(name:"NotoSansCJKkr-Regular",size:12)
                        reportYear.textColor = UIColor.black
                        reportView.addSubview(reportYear)
                        //상세 성적표 학기
                        let reportSemester = UILabel()
                        reportSemester.frame = CGRect(x: reportYear.frame.maxX, y: 0, width: self.contentWidthValue*2, height: reportView.frame.height)
                        reportSemester.text = viewSemester
                        reportSemester.textAlignment = .center
                        reportSemester.font = UIFont(name:"NotoSansCJKkr-Regular",size:12)
                        reportSemester.textColor = UIColor.black
                        reportSemester.adjustsFontSizeToFitWidth = true
                        reportView.addSubview(reportSemester)
                        //상세 성적표 교과목명
                        let reportName = UILabel()
                        reportName.frame = CGRect(x: reportSemester.frame.maxX, y: 0, width: self.contentWidthValue*6, height: reportView.frame.height)
                        reportName.text = viewName
                        reportName.textAlignment = .center
                        reportName.font = UIFont(name:"NotoSansCJKkr-Regular",size:12)
                        reportName.textColor = UIColor.black
                        reportName.adjustsFontSizeToFitWidth = true
                        reportView.addSubview(reportName)
                        //상세 성적표 이수구분
                        let reportDiv = UILabel()
                        reportDiv.frame = CGRect(x: reportName.frame.maxX, y: 0, width: self.contentWidthValue*4, height: reportView.frame.height)
                        reportDiv.text = viewDiv
                        reportDiv.textAlignment = .center
                        reportDiv.font = UIFont(name:"NotoSansCJKkr-Regular",size:12)
                        reportDiv.textColor = UIColor.black
                        reportDiv.adjustsFontSizeToFitWidth = true
                        reportView.addSubview(reportDiv)
                        //상세 성적표 학점
                        let reportPoint = UILabel()
                        reportPoint.frame = CGRect(x: reportDiv.frame.maxX, y: 0, width: self.contentWidthValue*2, height: reportView.frame.height)
                        reportPoint.text = viewPoint
                        reportPoint.textAlignment = .center
                        reportPoint.font = UIFont(name:"NotoSansCJKkr-Regular",size:12)
                        reportPoint.textColor = UIColor.black
                        reportView.addSubview(reportPoint)
                        //상세 성적표 성적
                        let reportResult = UILabel()
                        reportResult.frame = CGRect(x: reportPoint.frame.maxX, y: 0, width: self.contentWidthValue*2, height: reportView.frame.height)
                        reportResult.text = viewResult
                        reportResult.textAlignment = .center
                        reportResult.font = UIFont(name:"NotoSansCJKkr-Regular",size:12)
                        reportResult.textColor = UIColor.black
                        reportView.addSubview(reportResult)
                        //뷰 개수 늘리기
                        viewNumber = viewNumber + 1
                    default :
                        break
                    }
                }
                self.reportScrollView.contentSize.height = viewNumber*40
            }
        }
    }
    //MARK: 전체성정표
    func allReportDataGet(html: String){
        if let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            let test = doc.xpath("//table[@id='dgList1']//tr//td") //장학정보 접근
            DispatchQueue.main.async {
                var viewNumber: CGFloat = 0
                var viewYear: String = "" //년도
                var viewSemester: String = "" //학기
                var viewName: String = "" //수업명
                var viewDiv: String = "" //이수구분
                var viewPoint: String = "" //학점
                var viewResult: String = "" //성적
                for testIndex in 8..<test.count {
                    let text = test[testIndex].text ?? ""
                    switch testIndex % 8 {
                    case 0: //년도
                        viewYear = text
                    case 1: //학기
                        viewSemester = text
                    case 2: //과목코드
                        break
                    case 3: //수업명
                        viewName = text
                    case 4: //이수구분
                        viewDiv = text
                    case 5: //학점
                        viewPoint = text
                    case 6: //성적
                        viewResult = text
                    case 7: //비고
                        //상세 성적표 올라가는 뷰
                        let reportView = UIView()
                        reportView.frame = CGRect(x: 0, y: viewNumber*40, width: self.reportScrollView.frame.width, height: 40)
                        reportView.layer.addBorder([.bottom], color: UIColor.lightGray, width: 1)
                        self.reportScrollView.addSubview(reportView)
                        //상세 성적표 년도
                        let reportYear = UILabel()
                        reportYear.frame = CGRect(x: 0, y: 0, width: self.contentWidthValue*2, height: reportView.frame.height)
                        reportYear.text = viewYear
                        reportYear.textAlignment = .center
                        reportYear.font = UIFont(name:"NotoSansCJKkr-Regular",size:12)
                        reportYear.textColor = UIColor.black
                        reportView.addSubview(reportYear)
                        //상세 성적표 학기
                        let reportSemester = UILabel()
                        reportSemester.frame = CGRect(x: reportYear.frame.maxX, y: 0, width: self.contentWidthValue*2, height: reportView.frame.height)
                        reportSemester.text = viewSemester
                        reportSemester.textAlignment = .center
                        reportSemester.font = UIFont(name:"NotoSansCJKkr-Regular",size:12)
                        reportSemester.textColor = UIColor.black
                        reportSemester.numberOfLines = 2
                        reportSemester.adjustsFontSizeToFitWidth = true
                        reportView.addSubview(reportSemester)
                        //상세 성적표 교과목명
                        let reportName = UILabel()
                        reportName.frame = CGRect(x: reportSemester.frame.maxX, y: 0, width: self.contentWidthValue*6, height: reportView.frame.height)
                        reportName.text = viewName
                        reportName.textAlignment = .center
                        reportName.font = UIFont(name:"NotoSansCJKkr-Regular",size:12)
                        reportName.textColor = UIColor.black
                        reportName.adjustsFontSizeToFitWidth = true
                        reportView.addSubview(reportName)
                        //상세 성적표 이수구분
                        let reportDiv = UILabel()
                        reportDiv.frame = CGRect(x: reportName.frame.maxX, y: 0, width: self.contentWidthValue*4, height: reportView.frame.height)
                        reportDiv.text = viewDiv
                        reportDiv.textAlignment = .center
                        reportDiv.font = UIFont(name:"NotoSansCJKkr-Regular",size:12)
                        reportDiv.textColor = UIColor.black
                        reportDiv.adjustsFontSizeToFitWidth = true
                        reportView.addSubview(reportDiv)
                        //상세 성적표 학점
                        let reportPoint = UILabel()
                        reportPoint.frame = CGRect(x: reportDiv.frame.maxX, y: 0, width: self.contentWidthValue*2, height: reportView.frame.height)
                        reportPoint.text = viewPoint
                        reportPoint.textAlignment = .center
                        reportPoint.font = UIFont(name:"NotoSansCJKkr-Regular",size:12)
                        reportPoint.textColor = UIColor.black
                        reportView.addSubview(reportPoint)
                        //상세 성적표 성적
                        let reportResult = UILabel()
                        reportResult.frame = CGRect(x: reportPoint.frame.maxX, y: 0, width: self.contentWidthValue*2, height: reportView.frame.height)
                        reportResult.text = viewResult
                        reportResult.textAlignment = .center
                        reportResult.font = UIFont(name:"NotoSansCJKkr-Regular",size:12)
                        reportResult.textColor = UIColor.black
                        reportView.addSubview(reportResult)
                        //뷰 개수 늘리기
                        viewNumber = viewNumber + 1
                    default :
                        break
                    }
                }
                self.reportScrollView.contentSize.height = viewNumber*40
            }
        }
    }
    //MARK: 성적표 카테고리 클릭
    @objc func reportMenuButtonTouch(sender:UIButton){
        for image in self.reportRadioImage {
            image.image = UIImage(named:"RadioButtonBlank")
        }
        self.reportRadioImage[sender.tag-1].image = UIImage(named:"RadioButtonFull")
        self.reportCategory = sender.tag
        if sender.tag == 2 {
            self.yearPickerView.isEnabled = true
            self.semesterPickerView.isEnabled = true
            self.yearPickerView.text = self.yearPickerContent[self.yearPickerContent.count-1] //최신 년도
            self.semesterPickerView.text = self.semesterPickerContent[0] //1학기
            self.reportYear = self.yearPickerContent[self.yearPickerContent.count-1]
            self.reportSMT = 10
        }
        else{
            self.yearPickerView.isEnabled = false
            self.semesterPickerView.isEnabled = false
            self.yearPickerView.text = ""
            self.semesterPickerView.text = ""
        }
    }
    //MARK: 피커뷰 데이터 생성
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
            self.reportYear = self.yearPickerContent[row]
            self.yearPickerView.text = self.yearPickerContent[row]
        }
        else { //semester
            switch row {
            case 0 :
                self.reportSMT = 10
            case 1 :
                self.reportSMT = 11
            case 2 :
                self.reportSMT = 20
            case 3 :
                self.reportSMT = 21
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
