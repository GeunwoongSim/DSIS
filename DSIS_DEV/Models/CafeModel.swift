import Foundation
import UIKit

//학식파싱
struct CafeteriaInfo: Decodable { //학식파싱 전체형식
    let cafeteria_professor_sh: [BuildingMenu] //교수회관(승학)
    let cafeteria_student_sh: [BuildingMenu] //학생회관(승학)
    let cafeteria_library_sh: [BuildingMenu] //도서관(승학)
    let cafeteria_domitory_bm: [BuildingMenu] //기숙사(부민)
    let cafeteria_professor_bm: [BuildingMenu] //교수회관(부민)
    let cafeteria_student_bm: [BuildingMenu] //학생회관(부민)
    let cafeteria_domitory_sh: [BuildingMenu] //기숙사(승학)
}
struct BuildingMenu: Decodable { //학시파싱 세부형식
    let setMenu: String //세트
    let oneMenu: String //단품
    let snackMenu: String //스낵
    let date: String //날짜
}

struct CafeModel{
    var cafeMode : Int = 0 // 0: 승학 1: 부민 2: 기숙사
    let cafeModeString : [String] = ["승학 캠퍼스","부민 캠퍼스","한림 생활관"]
    let buildingName : [[String]] = [["교수회관","학생회관","도서관"],["교수회관","학생회관"],["승학기숙사","부민기숙사"]]
    let subTitleString : [[String]] = [["정식","일품","스낵"],["정식","일품","스낵"],["조식","중식","석식"]]
}
