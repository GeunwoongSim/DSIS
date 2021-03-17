import Foundation
import UIKit

struct DevInfo : Decodable {
    let member_result: [member_result]
}
struct member_result : Decodable {
    let group_num : String //기수(999 == 서포터즈)
    let name : String //이름
    let postion : String //분류(developer, design ...)
    let team : String //학교, 과, 학번 (ex: 동아대학교 컴퓨터공학과 ₩10)
    let period : String //활동기간 yyyy.mm ~ yyyy.mm
}

