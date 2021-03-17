import Foundation
import UIKit

//동아리파싱
struct ClubInfo: Decodable {
    let club: [club] //클럽정보를 담고 있는 배열
}
struct club: Decodable {
    let depart: String //분야 1:문예1, 2:문예2, 3:봉사 4:종교, 5:체육, 6:학술1, 7:학술2
    let name: String //이름
    let banner: String //배너 경로
    let poster: String //포스터 경로
}
