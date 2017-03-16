//
//  Enums.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/12/16.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import Foundation


enum TableStatus : Int {
    case tableInitialized = 0
    case tableNotInitialized=3
    case notL4 = 1
    case L4 = 2
    case initialSy_id = -1
    case initialClassKey = -10
    case initRgno = -11
    case notInitRgno = -12
}
enum columnWeek : Int{
    case mon = 1
    case tue = 2
    case wed = 3
    case thu = 4
    case fri = 5
    case sat = 6
}
enum Language : Int{
    case en = 1
    case jp = 0
    
    init(lang:Int){
        if lang == 0{
            self = .jp
        }else if lang == 1{
            self = .en
        }else{
            self = .jp
        }
    }
}

enum TableSeason :String{
    case winter = "Winter"
    case spring = "Spring"
    case autumn = "Autumn"
    
    init(season : String) {
        if season == "Winter" {
            self = .winter
        } else if season == "Spring" {
            self = .spring
        } else {
            self = .autumn
        }
    }
}

enum DataTableType:Int{    //Memoとかのやつ
    case memo = 0
    case photo = 1
    
    init(type : Int) {
        if type == 0 {
            self = .memo
        }else if type == 1{
            self = .photo
        }
        else{
            self = .memo
        }
    }
}

enum ScheduleTableType:Int{
    case assignment = 0
    case test = 1
    
    case done = -1
    case notDone = -2
    
    init(type : Int) {
        if type == 0 {
            self = .assignment
        }else if type == 1{
            self = .test
        }else if type == -1 {
            self = .done
        }else if type == -2{
            self = .notDone
        }else{
            self = .test
        }
    }
    
}

