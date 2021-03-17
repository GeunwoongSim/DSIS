import Foundation
import UIKit

//강의실검색 파싱
struct RoomSearchInfo: Decodable {
    let result_class_list: [RoomInfo]
}
struct RoomInfo: Decodable {
    let id: String // 개수
    let name: String // 건물명
    let location: String //건물번호
}
