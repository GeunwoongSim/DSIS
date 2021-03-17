import Foundation
import UIKit

//도서관 정보 파싱
struct libraryInfo: Decodable {
    let result: [library_result]
}
struct library_result: Decodable {
    let Lname: String //장소명
    let Allsit: String //총좌석수
    let Usesit: String //사용좌석수
    let Restsit: String //빈좌석수
    let Persit: String //퍼센트
    let Nowtime: String //현재 시간
}

