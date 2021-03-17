import Foundation
import UIKit

class MapHomeViewController: MenuHomeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //핀이미지 설정
        self.pinImageString = "MapIcon"
        
        let searchButton = UIButton() //지도 검색
        searchButton.frame = CGRect(x: view.frame.width - 80, y: view.frame.height - homeIndicatorHeight - 80, width: 60, height: 60)
        searchButton.setImage(UIImage(named:"MapSearchIcon.png"), for: .normal)
        searchButton.addTarget(self, action: #selector(self.searchButtonTouch(sender:)), for: .touchUpInside)
        self.view.addSubview(searchButton)
    }
    override func menuButtonTouch(sender: UIButton) {
        print("교내지도에서 메뉴 클릭")
        let vc = MapViewController()
        vc.mapData.mapMode = sender.tag
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func searchButtonTouch(sender:UIButton){
        print("지도검색버튼클릭")
        let vc = SearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}
