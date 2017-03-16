//
//  DataBaseScheduleTableManager.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/03.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import Foundation
import FMDB


fileprivate enum ScheduleTableColumnName:String{
    case id = "_id"
    case classKey = "ClassKey"
    case tableKey = "TableKey"
    case typeOfSchedule = "TypeOfSchedule"
    case dueDate = "DueDate"
    case memo = "Memo"
    case isDone = "isDone"
}

class DataBaseScheduleTableManager: ProtocolForEachDBm{
    
    var DBm:DatabaseManager
    var tableName = "scheduleTable"
    
    let formatter :CustomDateFormatter
    
    init(DBm:DatabaseManager){
        
        self.DBm=DBm
        
        formatter = CustomDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd" //表示形式を設定
    }
    
    
    
    func loadDataWithSortByDueDate(classKey:Int)->[ScheduleDataEntity]{
        var returnVal : [ScheduleDataEntity] = []
        let results = DBm.loadData(tableNameInDB: tableName, whereColName: ScheduleTableColumnName.classKey.rawValue, whereColVal: String(classKey))
        
        
        while(results.next()){
            let Data=self.setToDataEntity(results:results)
            returnVal.append(Data)
        }
        
    
        returnVal.sort(by: sortByDate)
       // returnVal.sort()
       
        return returnVal
    }
    
    func loadAllDataWithSortByDueDate(tableKey:Int)->[ScheduleDataEntity]{
        var returnVal : [ScheduleDataEntity] = []
        let results = DBm.loadData(tableNameInDB: tableName, whereColName: ScheduleTableColumnName.tableKey.rawValue, whereColVal: String(tableKey))
        
        while(results.next()){
            let Data=self.setToDataEntity(results:results)
            print("load all data \(Data.memo)")
            returnVal.append(Data)
        }
        returnVal.sort(by: sortByDate)
        return returnVal
    }

    func sortByDate(this:ScheduleDataEntity, that:ScheduleDataEntity) -> Bool {
        return this.dueDate.compare(that.dueDate) == ComparisonResult.orderedAscending
    }
    
    func setData(classKey:Int,tableKey:Int,type:ScheduleTableType,dueDate:Date,memo:String,isDone:ScheduleTableType){
        let insertSQL =
            "INSERT INTO \(tableName) (\(ScheduleTableColumnName.classKey),\(ScheduleTableColumnName.dueDate),\(ScheduleTableColumnName.isDone),\(ScheduleTableColumnName.memo),\(ScheduleTableColumnName.tableKey),\(ScheduleTableColumnName.typeOfSchedule))" +
        " VALUES (:a,:b,:c,:d,:e,:f)"
        
    
        let params = ["a": String(classKey),
                      "b": formatter.dateToString(date: dueDate),
                      "c":String(isDone.rawValue),
                      "d":memo,
                      "e":String(tableKey),
                      "f":String(type.rawValue)]
        let _ = DBm.insertData(query: insertSQL, params: params)
    }
    
    //Delete
    
    func deleteDataByRowId(rowId:Int)->Bool{   //Data.id がRowId　のはず
        let  deleteReturnVal = DBm.deleteData(tableNameInDB: tableName, rowName: ScheduleTableColumnName.id.rawValue, rowVal: String(rowId))
        
        return deleteReturnVal
    }
    func deleteDataByTableKey(tableKey:Int)->Bool{
        let  deleteReturnVal = DBm.deleteData(tableNameInDB: tableName, rowName: ScheduleTableColumnName.tableKey.rawValue, rowVal: String(tableKey))
        
        return deleteReturnVal

    }
    func deleteDataByClassKey(classKey:Int)->Bool{
        let  deleteReturnVal = DBm.deleteData(tableNameInDB: tableName, rowName: ScheduleTableColumnName.classKey.rawValue, rowVal: String(classKey))
        
        return deleteReturnVal
    }

    
    private func setToDataEntity(results:FMResultSet)->ScheduleDataEntity{
        let Data = ScheduleDataEntity()
        
        Data.id = Int(results.int(forColumnIndex: 0))
        Data.classKey = Int(results.int(forColumnIndex: 1))
        Data.tableKey = Int(results.int(forColumnIndex: 2))
        Data.typeOfSchedule = ScheduleTableType.init(type: Int(results.int(forColumnIndex: 3)))
        Data.dueDate = formatter.stringToDate(dateString: results.string(forColumnIndex: 4))
        Data.memo = results.string(forColumnIndex: 5)
        Data.isDone = ScheduleTableType.init(type: Int(results.int(forColumnIndex: 6)))
        
        return Data
    }

    
}
