//
//  StudentScholarshipViewController.swift
//  DSIS_DEV
//
//  Created by 심근웅 on 2020/07/23.
//  Copyright © 2020 Underside. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kanna

class StudentScholarshipViewController : UIViewController {
    //MARK: Value & Data
    //student Info
    var studentID: String = ""
    var studentPW: String = ""
    //Data
    var priceSum: Int = 0
    //UI
    let scholarshipSumLabel = UILabel()
    let scholarshipScrollView = UIScrollView()
    let scholarshipString : [String] = ["수혜일자","구분","장학금액"]
    //indicator설정
    let indicatorView = UIActivityIndicatorView()
    
    //MARK: UICreate
    func UICreate(){
        view.backgroundColor = .white
        //배경이미지
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: statusBarHeight+180)
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
        viewName.text = "장학정보"
        viewName.font = UIFont(name: "NotoSansCJKkr-Bold", size: 30)
        viewName.textAlignment = .left
        viewName.textColor = .white
        viewName.layer.masksToBounds = false
        viewName.layer.shadowColor = UIColor.black.cgColor
        viewName.layer.shadowOffset = .zero
        viewName.layer.shadowOpacity = 0.5
        viewName.layer.shadowRadius = 7
        view.addSubview(viewName)
        //장학금 총액
        scholarshipSumLabel.frame = CGRect(x: 40, y: viewName.frame.maxY, width: self.view.frame.width - 80, height: 60)
        scholarshipSumLabel.text = "장학금액 합계 :"
        scholarshipSumLabel.font = UIFont(name: "NotoSansCJKkr-Bold", size: 16)
        scholarshipSumLabel.adjustsFontSizeToFitWidth = true
        scholarshipSumLabel.textAlignment = .left
        scholarshipSumLabel.textColor = .white
        view.addSubview(scholarshipSumLabel)
        //장학금 틀 작성
        let scholarshipBackground = UIView()
        scholarshipBackground.frame = CGRect(x: 20, y: scholarshipSumLabel.frame.maxY, width: self.view.frame.width - 40, height: self.view.frame.height - statusBarHeight - 150 - homeIndicatorHeight)
        scholarshipBackground.backgroundColor = UIColor.white
        scholarshipBackground.layer.shadowColor = UIColor.lightGray.cgColor
        scholarshipBackground.layer.shadowOpacity = 1
        scholarshipBackground.layer.shadowRadius = 7
        scholarshipBackground.layer.shadowOffset = .zero
        scholarshipBackground.layer.cornerRadius = 5
        view.addSubview(scholarshipBackground)
        //장학금 제목
        for viewIndex in 0..<scholarshipString.count {
            let viewLabel : UILabel = UILabel()
            viewLabel.frame = CGRect(x: scholarshipBackground.frame.width/3 * CGFloat(viewIndex), y: 0, width: scholarshipBackground.frame.width/3, height: imageView.frame.height - scholarshipSumLabel.frame.maxY)
            viewLabel.text = self.scholarshipString[viewIndex]
            viewLabel.textAlignment = .center
            viewLabel.textColor = UIColor(hex:0x37BCE8)
            viewLabel.font = UIFont(name: "NotoSansCJKkr-Regular", size: 14)
            viewLabel.layer.addBorder([.bottom], color: UIColor.lightGray, width: 1)
            if viewIndex != scholarshipString.count-1 {
                viewLabel.layer.addBorder([.right], color: UIColor.lightGray, width: 1)
            }
            scholarshipBackground.addSubview(viewLabel)
        }
        let scrollViewMinY : CGFloat = imageView.frame.height - scholarshipSumLabel.frame.maxY
        //장학정보 스크롤뷰
        scholarshipScrollView.frame = CGRect(x: 0, y: scrollViewMinY, width: viewWidthStandard*18, height: scholarshipBackground.frame.height - scrollViewMinY)
        scholarshipScrollView.showsVerticalScrollIndicator = false
        scholarshipBackground.addSubview(scholarshipScrollView)
        //indicator
        indicatorView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        indicatorView.backgroundColor = UIColor(hex: 0x231815, alpha: 0.5)
        indicatorView.style = .large
        indicatorView.color = UIColor.white
        self.view.addSubview(indicatorView)
        //장학정보 받아와서 뿌려줌
        studentInfoRequest()
    }
    //MARK: BackButton
    @objc func backButtonTouch(sender: UIButton) {
        print("backButtonTouch")
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UICreate()
    }
    //MARK: 장학정보 받아오기
    func studentInfoRequest() {
        let parameters: [String: Any] = [ //해당 웹에 넘겨줄 파라미터
            "userid": "\(self.studentID)",
            "passwd": "\(self.studentPW)"
        ]
        indicatorView.startAnimating()
        Alamofire.request(
            studentScholarshipInfoURL,
            method: .post,
            parameters: parameters).responseString { response in
                self.indicatorView.stopAnimating()
                if response.result.isSuccess {
                    let Sleep_responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue )
                        self.userDataGet(html: Sleep_responseString! as String)
                } else {
                    print("통신실패")
                }
        }
    }
    func userDataGet(html: String) {
        let baseViewH : CGFloat = 50
        if let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
            let test = doc.xpath("//table[@id='Table8']//tr//td") //장학정보 접근
            DispatchQueue.main.async {
                if test.count >= 8 { //내용이 있음
                    if (test[7].text?.contains("장학 사정 중입니다"))! {
                        self.scholarshipSumLabel.text = "장학금액 합계 : \(test[7].text ?? "")"
                    }
                    else {
                        var viewNumber: CGFloat = 0
                        var viewYear: String = ""
                        var viewSemester: String = ""
                        var viewCategory: String = ""
                        var viewName: String = ""
                        var viewDay: String = ""
                        var viewPrice: String = ""
                        for testIndex in 7..<test.count-2 {
                            let text = test[testIndex].text ?? ""
                            switch testIndex%7 {
                            case 0:
                                viewYear = text
                            case 1:
                                viewSemester = text
                            case 2:
                                viewCategory = text
                            case 3:
                                viewName = text
                            case 4:
                                viewDay = text
                            case 6 :
                                viewPrice = text
                                //상세 장학내역 뷰
                                let scholarshipView = UIView()
                                scholarshipView.frame = CGRect(x: 0, y: viewNumber*baseViewH, width: viewWidthStandard*18, height: baseViewH)
                                scholarshipView.layer.addBorder([.bottom], color: UIColor.lightGray, width: 1)
                                self.scholarshipScrollView.addSubview(scholarshipView)
                                //밑줄
                                let scholarshipSubView = UIView()
                                scholarshipSubView.frame = CGRect(x: 0, y: 0, width: scholarshipView.frame.width, height: baseViewH/2)
                                scholarshipSubView.layer.addBorder([.bottom], color: UIColor.lightGray, width: 1)
                                scholarshipView.addSubview(scholarshipSubView)
                                //Semester
                                let semesterLabel = UILabel()
                                semesterLabel.frame = CGRect(x: 0, y: 0, width: scholarshipView.frame.width/3, height: baseViewH/2)
                                semesterLabel.font = UIFont(name:"NotoSansCJKkr-Regular",size:14)
                                semesterLabel.textAlignment = .center
                                semesterLabel.textColor = UIColor(hex:0x565656)
                                semesterLabel.text = "\(viewYear) \(viewSemester)"
                                scholarshipView.addSubview(semesterLabel)
                                //Name
                                let nameLabel = UILabel()
                                nameLabel.frame = CGRect(x: semesterLabel.frame.maxX, y: 0, width: scholarshipView.frame.width/3*2, height: baseViewH/2)
                                nameLabel.font = UIFont(name:"NotoSansCJKkr-Regular",size:14)
                                nameLabel.textAlignment = .center
                                nameLabel.textColor = UIColor(hex:0x565656)
                                nameLabel.text = viewName
                                nameLabel.adjustsFontSizeToFitWidth = true
                                scholarshipView.addSubview(nameLabel)
                                //Day
                                let dayLabel = UILabel()
                                dayLabel.frame = CGRect(x: 0, y: baseViewH/2, width: scholarshipView.frame.width/3, height: baseViewH/2)
                                dayLabel.font = UIFont(name:"NotoSansCJKkr-Regular",size:14)
                                dayLabel.textAlignment = .center
                                dayLabel.textColor = UIColor(hex:0x565656)
                                dayLabel.text = viewDay
                                scholarshipView.addSubview(dayLabel)
                                //Category
                                let categoryLabel = UILabel()
                                categoryLabel.frame = CGRect(x: dayLabel.frame.maxX, y: baseViewH/2, width: scholarshipView.frame.width/3, height: baseViewH/2)
                                categoryLabel.font = UIFont(name:"NotoSansCJKkr-Regular",size:14)
                                categoryLabel.textAlignment = .center
                                categoryLabel.textColor = UIColor(hex:0x565656)
                                categoryLabel.text = viewCategory
                                scholarshipView.addSubview(categoryLabel)
                                //Price
                                let priceLabel = UILabel()
                                priceLabel.frame = CGRect(x: categoryLabel.frame.maxX, y: baseViewH/2, width: scholarshipView.frame.width/3, height: baseViewH/2)
                                priceLabel.font = UIFont(name:"NotoSansCJKkr-Regular",size:14)
                                priceLabel.textAlignment = .center
                                priceLabel.textColor = UIColor(hex:0x565656)
                                priceLabel.text = viewPrice
                                scholarshipView.addSubview(priceLabel)
                                //View개수 증가
                                viewNumber = viewNumber+1
                            default:
                                break
                            }
                        }
                        self.scholarshipScrollView.contentSize.height = viewNumber*baseViewH
                        self.scholarshipSumLabel.text = "장학금액 합계 : \(test[test.count-1].text ?? "0")"
                    }
                }
                else{ //내용이 없음
                    self.scholarshipSumLabel.text = "장학금액 합계 : 장학금이 없습니다."
                }
            }
        }
    }
}
