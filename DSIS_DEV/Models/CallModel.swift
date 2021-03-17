import Foundation
import UIKit

//전화번호부 파싱
struct callNumberInfo: Decodable {
    let SeungHak: [callNumber] //승학 전화부
    let Bumin: [callNumber] //부민 전화부
    let Gudeuk: [callNumber] //구덕 전화부
}
struct callNumber: Decodable {
    let organization: String // 부서명
    let office: String //위치
    let number: String //번호
}
