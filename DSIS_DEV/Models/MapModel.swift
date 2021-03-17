import Foundation
import UIKit

struct MapModel {
    var mapMode : Int = 0 // 0:승학, 1:부민, 2:구덕
    let mapModeString: [String] = ["hadan", "bumin", "guduk"]
    let mapTitleList: [String] = ["승학캠퍼스 교내지도", "부민캠퍼스 교내지도", "구덕캠퍼스 교내지도"]
    let mapImageList: [String] = ["SHMap.png", "BMMap.png", "GDMap.png"]
    let mapNumberCount: [Int] = [18, 6, 15] //18개, 6개, 15개
    let buildingName: [[String]] = [ //건물이름
        ["S01. 대학본부 및 인문과학대학(A)", "S02. 학생회관(Q)", "S03. 공과대학 1호관(P1)", "S04. 공과대학 2호관(P2)", "S05. 공과대학 3호관(P3)", "S06. 공과대학 5호관(P5)", "S07. 예술체육대학(G)", "S08. 교수회관(W)", "S09. 생명자원 및 건강과학대학(M)", "S10. 한림도서관(B)", "S11. 자연과학대학(E)", "S12. 공과대학 4호관(P4)", "S13. 창업관", "S14. 산학연구관(SM)", "S15. 한림생활관", "S16. 학군단(DE)", "S17. (가칭)예술대학", "S18. (가칭)예술대학"],
        ["B01. 박물관(BM)", "B02. 법과대학(LS)", "B03. 평생교육원(BE)", "B04. 종합강의동(BA~BD)", "B05. 국제관", "◆. 한림생활관 부민관"],
        ["G01. 석당기념관(GE)", "G02. 의과대학 강의동(S1)", "G03. 의과대학(S2)", "G04. 의과대학 기초의학동(S3)", "G05. (구)사회과학대학(GA)", "G06. 제2학생회관(CF)", "G07. 미술관(CN)", "G08. 음악관(CD)", "G09. 구덕도서관(GG)", "G10. 대강당 석당홀(CB)", "G11. 예술대학(CA)", "G12. 예술대학 실습동(CAD)", "♣. 동아대학교 의료원", "♠. 심뇌혈관 질환센터", "◆. 동아대학교 의료원(신관)"]
    ]
    let buildingNumber: [[String]] = [ //건물번호
        ["a", "q", "p1", "p2", "p3", "rs", "g", "w", "m", "bb", "e", "p4", "", "", "", "", "", ""],
        ["", "ls", "be", "ba", "", ""],
        ["ge", "s1", "s2", "s3", "ga", "cf", "", "", "gg", "cb", "", "", "", "", ""]
    ]
    let buildingImage: [[Int]] = [ //건물층수
        [16, 7, 6, 6, 6, 10, 7, 7, 6, 6, 6, 8, 0, 0, 0, 0, 0, 0],
        [0, 7, 7, 13, 0, 0],
        [4, 4, 6, 3, 9, 5, 0, 0, 2, 4, 0, 0, 0, 0, 0]
    ]
    let buildingSupport: [[Bool]] = [ //건물지도 유무
        [true, true, true, true, true, true, true, true, true, true, true, true, false, false, false, false, false, false],
        [false, true, true, true, false, false],
        [true, true, true, true, true, true, false, false, true, true, false, false, false, false, false]
    ]
}
