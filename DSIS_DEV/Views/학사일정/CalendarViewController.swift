
import Foundation
import UIKit
import Alamofire

class CalendarViewController: UIViewController {

    //MARK: 변수
    let calendarScrollView = UIScrollView() //일정이 올라가는 스크롤 뷰
    var currentYear: Int = -1 //이번년
    var currentMonth: Int = -1 //이번달
    var calendarContent: [[calendarData]] = Array(repeating: [], count: 14) //올해 1월 ~ 다음해 2월 까지
    var calendarViewList: [UIView] = []
    
    //MARK: UICreate
    private func UICreate(){
        self.view.backgroundColor = UIColor.white
        //배경이미지
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: statusBarHeight+100)
        imageView.image = UIImage(named: "MinBackground.png")
        self.view.addSubview(imageView)
        //흰배경
        let viewBack = UIView()
        viewBack.frame = CGRect(x: 0, y: imageView.frame.maxY, width: view.frame.width, height: self.view.frame.height - imageView.frame.height)
        viewBack.backgroundColor = UIColor(hex: 0xF9F7F7)
        self.view.addSubview(viewBack)
        //뒤로가기
        let backButton = UIButton()
        backButton.frame = CGRect(x: layoutMargin, y: statusBarHeight+navigationBarHeight/2, width: 40, height: 40)
        backButton.addTarget(self, action: #selector(self.backButtonTouch(sender:)), for: .touchUpInside)
        view.addSubview(backButton)
        let backButtonImage = UIImageView()
        backButtonImage.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        backButtonImage.image = UIImage(named:"BackButton.png")
        backButton.addSubview(backButtonImage)
        //타이틀바
        let viewName = UILabel()
        viewName.frame = CGRect(x: backButton.frame.maxX+10, y: 0, width: view.frame.width-2*layoutMargin-100, height: navigationBarHeight)
        viewName.center.y = backButton.center.y
        viewName.text = "학사일정"
        viewName.font = UIFont(name:"NotosansCJKkr-Bold",size:30)
        viewName.textAlignment = .center
        viewName.textColor = .white
        view.addSubview(viewName)
        //학사일정 올라가는 스크롤뷰
        calendarScrollView.frame = CGRect(x: 0, y: 0, width: viewBack.frame.width,height: viewBack.frame.height - homeIndicatorHeight)
        calendarScrollView.backgroundColor = UIColor(hex: 0xf9f7f7)
        viewBack.addSubview(calendarScrollView)
    }
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UICreate()
        //데이터 받아오기
        self.currentDateGet()
        self.calendarDataGet()
    }
    //MARK: 뒤로가기함수
    @objc func backButtonTouch(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: 년월 받아오기
    func currentDateGet(){
        let dateFormatter = DateFormatter() //날짜형식
        dateFormatter.dateFormat = "yyyy"
        self.currentYear = (dateFormatter.string(from: Date()) as NSString).integerValue
        dateFormatter.dateFormat = "MM"
        self.currentMonth = (dateFormatter.string(from: Date()) as NSString).integerValue
    }
    //MARK: 학사일정 받아오기
    func calendarDataGet(){
        Alamofire.request(calendarInfoURL).responseJSON{ (response) in
            guard let data = response.data else { return }
            do{
                let calData = try JSONDecoder().decode(calendarInfo.self, from: data)
                for calDataIndex in 0..<calData.calendar_result.count {
                    let str = calData.calendar_result[calDataIndex].date.components(separatedBy: ["-","~"]) // yyyy / mm / .. 으로 잘라짐
                    if str.count == 3 {
                        let startYear = Int(str[0]) ?? 0 //학사일정 년 : Int
                        let startMonth = Int(str[1]) ?? 0 //학사일정 월 : Int
                        if self.currentYear == startYear{
                            self.calendarContent[startMonth-1].append(calData.calendar_result[calDataIndex])
                        }
                        else{
                            self.calendarContent[startMonth+11].append(calData.calendar_result[calDataIndex])
                        }
                    }
                    else{
                        let startYear = Int(str[0]) ?? 0 //학사일정 년 : Int
                        let startMonth = Int(str[1]) ?? 0 //학사일정 월 : Int
                        let finishYear = Int(str[3]) ?? 0
                        let finishMonth = Int(str[4]) ?? 0
                        var year = startYear
                        var month = startMonth
                        while true{
                            if self.currentYear == year{
                                self.calendarContent[month-1].append(calData.calendar_result[calDataIndex])
                            }
                            else{
                                self.calendarContent[month+11].append(calData.calendar_result[calDataIndex])
                            }
                            if month == finishMonth && year == finishYear {
                                break
                            }
                            month += 1
                            if month == 13 {
                                month = 1
                                year += 1
                            }
                        }
                    
                    }
                }
                DispatchQueue.main.async {
                    //학사일정 생성 부분
                    self.calendarCreate()
                }
            } catch let jsonErr{
                print("Error = \(jsonErr)")
            }
        }
    }
    //MARK: 받아온 정보를 기반으로 뷰 생성
    func calendarCreate(){
        var calendarContentHeight : CGFloat = 30
        let calendarBackWidth : CGFloat = self.view.frame.width - 4*layoutMargin
        for index in 0..<14 {
            let count = self.calendarContent[index].count
            var viewHeight: CGFloat = CGFloat(count) * 60 //한줄당 기본수치 30으로 잡고 2줄
            let calendarBack = UIView()
            self.calendarViewList.append(calendarBack)
            //내용에 따라서 뷰의 크기 결정
            if count == 0 { //내용 없음
                viewHeight = 60
                if index == 0 { //젤 위의 뷰
                    calendarBack.frame = CGRect(x: 2*layoutMargin, y: 30, width: calendarBackWidth, height: 60+viewHeight)
                } else {
                    calendarBack.frame = CGRect(x: 2*layoutMargin, y: calendarViewList[index-1].frame.maxY + 30, width: calendarBackWidth, height: 60+viewHeight)
                }
            } else { //내용있음
                if index == 0 { //젤 위의 뷰
                    calendarBack.frame = CGRect(x: 2*layoutMargin, y: 30, width: calendarBackWidth, height: 80+viewHeight)
                } else {
                    calendarBack.frame = CGRect(x: 2*layoutMargin, y: calendarViewList[index-1].frame.maxY + 30, width: calendarBackWidth, height: 80+viewHeight)
                }
            }
            //월 표시
            let monthLabel = UILabel()
            monthLabel.frame = CGRect(x: layoutMargin, y: 10, width: calendarBack.frame.width-2*layoutMargin, height: 30)
            if index == 12 { //다음해 1월
                monthLabel.text = "\(self.currentYear+1)년 \(index-11)월"
            } else if index == 0 { //올해 1월
                monthLabel.text = "\(self.currentYear)년 \(index+1)월"
            } else if index == 13 { //다음해 2월
                monthLabel.text = "\(index-11)월"
            } else { //올해 1월 제외
                monthLabel.text = "\(index+1)월"
            }
            monthLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size:18)
            monthLabel.textColor = .black
            calendarBack.addSubview(monthLabel)
            //스크롤뷰 컨텐츠높이 설정(스크롤범위)
            calendarContentHeight = calendarContentHeight + calendarBack.frame.height + 30
            //그외 기타 설정
            calendarBack.layer.shadowRadius = 5.0
            calendarBack.layer.shadowOpacity = 0.1
            calendarBack.layer.shadowOffset = CGSize(width: 10, height: 20)
            calendarBack.layer.masksToBounds = false
            calendarBack.backgroundColor = .white
            self.calendarScrollView.addSubview(calendarBack)
            if count == 0 { //내용없음
                //학사일정 내용
                let calendarNameLabel = UILabel()
                calendarNameLabel.frame = CGRect(x: 1.5*layoutMargin, y: monthLabel.frame.maxY+10, width: calendarBack.frame.width-3*layoutMargin, height: 30)
                calendarNameLabel.text = "학사일정이 없습니다"
                calendarNameLabel.textColor = UIColor.black
                calendarNameLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 14)
                calendarBack.addSubview(calendarNameLabel)
            }
            else { //내용있음
                for contentIndex in 0..<self.calendarContent[index].count {
                    //학사일정 내용
                    let calendarNameLabel = UILabel()
                    calendarNameLabel.frame = CGRect(x: 1.5*layoutMargin, y: monthLabel.frame.maxY+CGFloat(contentIndex)*60, width: calendarBack.frame.width-3*layoutMargin, height: 30)
                    calendarNameLabel.text = "\(self.calendarContent[index][contentIndex].schedule) :"
                    calendarNameLabel.textColor = UIColor.black
                    calendarNameLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 14)
                    calendarBack.addSubview(calendarNameLabel)
                    //학사일정 기간
                    let calendarDateLabel = UILabel()
                    calendarDateLabel.frame = CGRect(x: 1.5*layoutMargin, y: monthLabel.frame.maxY+30+CGFloat(contentIndex)*60, width: calendarBack.frame.width-3*layoutMargin, height: 30)
                    calendarDateLabel.text = self.calendarContent[index][contentIndex].date
                    calendarDateLabel.textColor = UIColor.black
                    calendarDateLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 14)
                    calendarBack.addSubview(calendarDateLabel)
                }
            }
        }
        //컨텐츠 높이 적용
        self.calendarScrollView.contentSize.height = calendarContentHeight
    }
}
