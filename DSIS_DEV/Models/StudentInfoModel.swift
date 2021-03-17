import Foundation
import UIKit

//개인정보처리방침 변경사항 파싱
struct personalInfoParse: Decodable {
    let now_p_info_vs: [personalInfoContent]
}
struct personalInfoContent: Decodable {
    let now_p_info_vs: String //업데이트 버전
    let update_date: String //업데이트날짜
}
