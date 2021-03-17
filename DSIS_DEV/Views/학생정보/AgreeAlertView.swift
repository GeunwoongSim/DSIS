import Foundation
import UIKit

class AgreeAlertViewController : UIViewController {
    //MARK: Value && Data
    var agreeVersion : String = "" //개인정보처리방침 동의 버전
    var superViewController : StudentInfoMainViewController?
    //개인정보처리방침
    let personalInfoTitle : [String] = [
        "1. 개인정보의 처리목적",
        "2. 개인정보의 처리 및 보유 기간",
        "3. 처리하는 개인정보의 항목",
        "4. 개인정보의 파기",
        "5. 개인정보의 안정성 확보 조치",
        "6. 개인정보 자동 수집 장치의 설치∙운영 및 그 거부에 관한 사항",
        "7. 개인정보 처리방침 변경"]
    let personalInfoContent : [String] = [
        "1. 디스이즈는 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며, 이용 목적이 변경되는 경우에는 개인정보 보호법 제 18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.\n\n - 학생정보 로그인 서비스 제공  : 동아대학교 학생정보 로그인 서비스 제공에 따른 로그인 세션 유지 기능을 목적으로 개인정보 자동 수집 장치(쿠키)를 활용하여 개인정보를 처리합니다.",
        "1. 디스이즈는 법령에 따른 개인정보 보유.이용기간 또는 정보주체로부터 개인정보를 수집시에 동의받은 개인정보 보유.이용기간 내에서 개인정보를 처리.보유합니다.\n2. 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.\n\n - 학생정보 로그인 서비스 제공 : 학생정보 로그인 기능을 이용하여 세션을 유지한 후 정보주체가 조회하고자 하는 정보를 수집한 후 지체없이 파기(즉시 파기)",
        "1. 학생정보 로그인 서비스 - 필수항목 : 성명, 성별, 학번\n2. 학생정보 로그인 서비스 이용과정에서 아래 개인정보 항목이 자동으로 생성되어 수집 될 수 있습니다.\n\n - 성명, 성별, 학번",
        "1. 디스이즈는 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.\n2. 개인정보 파기의 절차 및 방법은 다음과 같습니다.\n\n- 파기절차  : 디스이즈는 서비스 이용에 필요한 최소한만큼만 개인정보를 유지하며, 학생정보 로그인 서비스 이용에 제약이 없게 되면 즉시 개인정보를 파기합니다.\n\n- 파기방법  : 디스이즈는 전자적 파일 형태로 기록.저장된 개인정보를 기록을 재생할 수 없도록 파기합니다.",
        "1. 디스이즈는 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다.\n\n - 기술적 조치 : 접근권한 관리, 서비스 이용에 필요한 최소한의 유지 후 지체 없이 파기\n- 관리적 조치 : 내부관리계획 수립.시행, 정기적 보안 점검 등",
        "1. 디스이즈는 이용자에게 개별적인 맞춤서비스를 제공하기 위해 이용정보를 저장하고 수시로 불러오는 ‘쿠키(cookie)’를 사용합니다.\n2. 쿠키는 웹사이트를 운영하는데 이용되는 서버(http)가 이용자의 컴퓨터 브라우저에게 보내는 소량의 정보입니다.\n\n- 쿠키의 사용 목적 : 학생정보 로그인 후 정보를 조회할 때 세션을 유지하기 위해 이용됩니다.\n- 쿠키 저장을 거부할 경우 학생정보 서비스 이용이 불가능합니다.",
        "1. 이 개인정보 처리방침은 2020. 01. 09 부터 적용됩니다."]
    let suggestionsList : [String] = [
        "아래 내용에 동의해야만 사용 가능합니다.",
        "디스이즈는 개인정보 보호법 제 30조에 따라 정보주체의 개인정보를 보호하고 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리지침을 수립․공개합니다."]
    //MARK: UICreate()
    func UICreate(){
        self.view.backgroundColor = UIColor(hex: 0x231815, alpha: 0.5)
        //baseView
        let baseView = UIView()
        baseView.frame.size = CGSize(width: self.view.frame.width - 40, height: self.view.frame.height - navigationBarHeight*2)
        baseView.center = self.view.center
        baseView.backgroundColor = UIColor(hex:0x37BCE8)
        self.view.addSubview(baseView)
        //title
        let alertTitle = UILabel()
        alertTitle.frame = CGRect(x: 20, y: 0, width: baseView.frame.width-40, height: 70)
        alertTitle.text = "디스이즈 개인정보 처리 방침"
        alertTitle.textColor = UIColor.white
        alertTitle.font = UIFont(name: "NotoSansCJKkr-Regular", size: 20)
        baseView.addSubview(alertTitle)
        //contentBase
        let contentBase = UIView()
        contentBase.frame = CGRect(x: 0, y: alertTitle.frame.maxY, width: baseView.frame.width, height: baseView.frame.height - alertTitle.frame.height)
        contentBase.backgroundColor = UIColor.white
        baseView.addSubview(contentBase)
        //동의 비동의 버튼
        let agreeButton = UIButton()
        agreeButton.frame = CGRect(x: baseView.frame.width/2+5, y: baseView.frame.height - 60, width: baseView.frame.width/2 - 15, height: 50)
        agreeButton.backgroundColor = UIColor(hex:0x37BCE8)
        agreeButton.setTitle("위 내용에 동의", for: .normal)
        agreeButton.addTarget(self, action: #selector(self.okTouch(sender:)), for: .touchUpInside)
        baseView.addSubview(agreeButton)
        let cancelButton = UIButton()
        cancelButton.frame = CGRect(x: 10, y: baseView.frame.height - 60, width: baseView.frame.width/2 - 15, height: 50)
        cancelButton.backgroundColor = UIColor(hex:0x37BCE8)
        cancelButton.setTitle("동의하지 않음", for: .normal)
        cancelButton.addTarget(self, action: #selector(self.cancelTouch(sender:)), for: .touchUpInside)
        baseView.addSubview(cancelButton)
        //기본적인 제공사항
        for index in 0..<self.suggestionsList.count {
            let label = UILabel()
            label.numberOfLines = 0
            label.text = self.suggestionsList[index]
            if index == 0{
                label.frame = CGRect(x: 20, y: 0, width: contentBase.frame.width - 40, height: 40)
                label.font = UIFont(name: "NotoSansCJKkr-Regular", size: 15)
                label.textColor = UIColor.red
                label.textAlignment = . center
            }
            else{
                label.frame = CGRect(x: 20, y: 40*CGFloat(index), width: contentBase.frame.width - 40, height: 70)
                label.font = UIFont(name: "NotoSansCJKkr-Regular", size: 12)
                label.textColor = UIColor.black
            }
            label.adjustsFontSizeToFitWidth = true
            contentBase.addSubview(label)
        }
        //개인정보처리방침
        let textViewH : CGFloat = contentBase.frame.height - 180
        let textView = UITextView()
        textView.frame = CGRect(x: 20, y: 110, width: contentBase.frame.width-40, height: textViewH)
        textView.isEditable = false
        textView.isSelectable = false
        textView.showsVerticalScrollIndicator = false
        textView.backgroundColor = UIColor.white
        textView.font = UIFont(name: "NotoSansCJKkr-Regular", size: 13)
        contentBase.addSubview(textView)
        let boldFont = UIFont(name: "NotoSansCJKkr-Bold", size: 15)
        var text : String = ""
        for index in 0..<self.personalInfoTitle.count {
            text += self.personalInfoTitle[index] + "\n\n" + self.personalInfoContent[index] + "\n\n"
        }
        let attributedStr = NSMutableAttributedString(string: text)
        for index in 0..<self.personalInfoTitle.count {
            attributedStr.addAttribute((kCTFontAttributeName as NSString) as NSAttributedString.Key, value: boldFont!, range: (text as NSString).range(of: self.personalInfoTitle[index]))
        }
        textView.attributedText = attributedStr
    }
    //MARK: 동의하지않음
    @objc func cancelTouch(sender:UIButton){
        self.dismiss(animated: false, completion: nil)
    }
    //MARK: 동의함
    @objc func okTouch(sender:UIButton){
        let plist = UserDefaults.standard
        plist.set(self.agreeVersion,forKey: "동의")
        self.dismiss(animated: false, completion: nil)
    }
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UICreate()
    }
}
