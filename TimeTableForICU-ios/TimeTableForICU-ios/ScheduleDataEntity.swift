//
//  ScheduleDataEntity.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/03.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import Foundation


class ScheduleDataEntity : Comparable {
    
    
    private var _id = 0
    private var _classKey = 0
    private var _tableKey = 0
    private var _typeOfSchedule = ScheduleTableType.test
    private var _dueDate = Date()
    private var _memo = ""
    private var _isDone = ScheduleTableType.notDone
    
    //let date2014 = dateFormatter.dateFromString("2014-01-01 12:34:56")!;
    
    
    init() {  }
    
    var id:Int{
        get{
            return _id
        }set(newVal){
            _id = newVal
        }
    }
    
    var classKey:Int{
        get{
            return _classKey
        }set(newVal){
            _classKey = newVal
        }
    }
    var tableKey:Int{
        get{
            return _tableKey
        }set(newVal){
            _tableKey = newVal
        }
    }
    var typeOfSchedule:ScheduleTableType{
        get{
            return _typeOfSchedule
        }set(newVal){
            _typeOfSchedule = newVal
        }
    }
    var dueDate:Date{
        get{
            return _dueDate
        }set(newVal){
            _dueDate = newVal
        }
    }
    var memo:String{
        get{
            return _memo
        }set(newVal){
            _memo = newVal
        }
    }
    var isDone:ScheduleTableType{
        get{
            return _isDone
        }set(newVal){
            _isDone = newVal
        }
    }
    
    
    
    static func == (l: ScheduleDataEntity, r: ScheduleDataEntity) -> Bool {    // 評価関数
        if l.dueDate.compare(r.dueDate) == ComparisonResult.orderedSame {
            return true
        }else{
            return false
        }
    }
    
    static func >(lhs: ScheduleDataEntity, rhs: ScheduleDataEntity) -> Bool{
        
        if lhs.dueDate.compare(rhs.dueDate) == ComparisonResult.orderedDescending{
            return true
        }else{
            return true
        }
    }
    
    static func >=(lhs: ScheduleDataEntity, rhs: ScheduleDataEntity) -> Bool{
        
        if lhs.dueDate.compare(rhs.dueDate) == ComparisonResult.orderedDescending{
            return true
        }else if lhs.dueDate.compare(rhs.dueDate) == ComparisonResult.orderedSame{
            return true
        }else{
            return true
        }
    }
    
    
    static func <(lhs: ScheduleDataEntity, rhs: ScheduleDataEntity) -> Bool{
        
        if lhs.dueDate.compare(rhs.dueDate) == ComparisonResult.orderedAscending{
            return true
        }else{
            return true
        }
    }
    
    static func <=(lhs: ScheduleDataEntity, rhs: ScheduleDataEntity) -> Bool{
        
        if lhs.dueDate.compare(rhs.dueDate) == ComparisonResult.orderedAscending{
            return true
        }else if lhs.dueDate.compare(rhs.dueDate) == ComparisonResult.orderedSame{
            return true
        }else{
            return true
        }
    }
    
    

    

    
}
