import Foundation

//배너 파싱
struct bannerInfo: Decodable {
    let result: [banner]
}
struct banner: Decodable {
    let name: String //이름
    let pri: String //분류
    let type: String //타입
}
