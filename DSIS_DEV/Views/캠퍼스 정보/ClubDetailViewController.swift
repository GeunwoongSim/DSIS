import Foundation
import UIKit
import Alamofire

class ClubDetailViewController : UIViewController {
    var posterName : String?
    var posterPath : String?
    //MARK: UICreate
    func UICreate(){
        self.view.backgroundColor = UIColor(hex: 0x231815, alpha: 0.5)
        let backgroundView = UIView()
        backgroundView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width - 4*layoutMargin, height: 450)
        backgroundView.center = self.view.center
        backgroundView.backgroundColor = UIColor.white
        backgroundView.layer.cornerRadius = 20
        self.view.addSubview(backgroundView)
        //동아리 이름
        let clubName = UILabel()
        clubName.frame = CGRect(x: 0, y: 10, width: backgroundView.frame.width, height: 44)
        clubName.text = posterName
        clubName.font = UIFont(name:"NotoSansCJKkr-Bold",size:20)
        clubName.textAlignment = .center
        clubName.backgroundColor = UIColor.clear
        clubName.textColor = UIColor(hex: 0x575859)
        backgroundView.addSubview(clubName)
        //동아리 정보 닫기 버튼
        let closeButton = UIButton()
        closeButton.frame = CGRect(x: backgroundView.frame.maxX-34.5, y: backgroundView.frame.minY-34.5, width: 25, height: 25)
        closeButton.setImage(UIImage(named: "CampusCircleCancel.png"), for: .normal)
        closeButton.addTarget(self, action: #selector(backButtonTouch(sender:)), for: .touchUpInside)
        self.view.addSubview(closeButton)
        //동아리 포스터
        let poster = UIImageView()
        poster.frame = CGRect(x: 10, y: clubName.frame.maxY, width: backgroundView.frame.width-2*10, height: backgroundView.frame.height - 64)
        poster.clipsToBounds = true
        poster.layer.cornerRadius = 10
        poster.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.imageDown(view: poster, url: self.posterPath!)
        backgroundView.addSubview(poster)
    }
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UICreate()
    }
    //MARK: 이미지 다운
    func imageDown(view: UIImageView, url: String) {
        guard let encoded = url.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) else {return}
        guard let urlString = URL(string: encoded) else {return}
        Alamofire.request(urlString).responseData(completionHandler: { (data) in
            guard let data = data.data else { return }
            DispatchQueue.main.async {
                view.image = UIImage(data: data)
            }
        })
    }
    //MARK: 뒤로가기버튼 함수
    @objc func backButtonTouch(sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}
