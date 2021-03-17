import Foundation
import UIKit

class CafeHomeViewController: MenuHomeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //핀이미지 설정
        self.pinImageString = "CafeIcon"
    }
    override func menuButtonTouch(sender: UIButton) {
        print("교내식당에서 메뉴 클릭")
        let vc = CafeViewController()
        vc.cafeData.cafeMode = sender.tag
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}
