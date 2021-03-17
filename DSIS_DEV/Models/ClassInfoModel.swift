//
//  ClassInfoModel.swift
//  DSIS_DEV
//
//  Created by 심근웅 on 2020/07/22.
//  Copyright © 2020 Underside. All rights reserved.
//

import Foundation
import UIKit

struct classInfo {
    var classNumber : String = "" //과목코드
    var classDivide : String = "" //분반
    var className : String = "" //수업명
    var classLocation : String = "" //수업 위치
    var classStart : Int = 0 //시작교시
    var numberOfClass : Int = 0 //연속 몇 교시인지
}
