//
//  AddDataEntity.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/02.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import Foundation
class AddDataEntity:Equatable{
    
    private var _scheduleNum = 2016
    private var _classRoom = ""
    
    
    
    init(_ scheduleNum: Int) { self.scheduleNum = scheduleNum }
    init(_ scheduleNum: Int,classRoom:String) {
        self.scheduleNum = scheduleNum
        self.classRoom = classRoom
    }

    
    init() {  }

    
    var scheduleNum:Int{
        get{
            return _scheduleNum
        }
        set(newVal){
            _scheduleNum=newVal
        }
    }
    
    var classRoom:String{
        get{
            return _classRoom
        }
        set(newVal){
            _classRoom = newVal
        }
    }
    
    
    static func == (l: AddDataEntity, r: AddDataEntity) -> Bool {    // 評価関数
        return l.scheduleNum == r.scheduleNum
    }

    
    
    
}
