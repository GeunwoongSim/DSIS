import Foundation
import UIKit

class ThisStopIsHomeViewController : MenuHomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //핀이미지 설정
        self.pinImageString = "THISSTOPISIcon"
    }
    override func menuButtonTouch(sender: UIButton) {
        let vc = ThisStopIsViewController()
        vc.mode = sender.tag
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
