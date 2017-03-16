//
//  TableListDataEntity.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/12/23.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import Foundation


class TableListDataEntity{
    
    private var _tableKey = -1
    private var _tableName = ""
    private var _tableSeason = TableSeason.spring
    private var _tableYear = 2016
    
    
    var tableKey:Int{
        get{
            return _tableKey
        }
        set(newVal){
            _tableKey=newVal
        }
    }
    var tableName:String{
        get{
            return _tableName
        }
        set(newVal){
            _tableName=newVal
        }
    }

    var tableSeason:TableSeason{
        get{
            return _tableSeason
        }
        set(newVal){
            _tableSeason=newVal
        }
    }
    
    var tableYear:Int{
        get{
            return _tableYear
        }
        set(newVal){
            _tableYear = newVal
        }
    }
    
}
