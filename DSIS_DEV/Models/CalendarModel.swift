import Foundation
import UIKit
//학사일정파싱
struct calendarInfo: Decodable {
    let calendar_result: [calendarData]
}
struct calendarData: Decodable {
    let date: String // 날짜
    let schedule: String // 일정
}
