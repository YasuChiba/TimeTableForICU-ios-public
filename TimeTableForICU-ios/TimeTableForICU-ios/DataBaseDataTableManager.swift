//
//  DataBaseDataTableManager.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/03.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import Foundation
import FMDB

enum DataTableColumnName:String{
    case id = "_id"
    case classKey = "ClassKey"
    case tableKey = "TableKey"
    case typeOfData = "TypeOfData"
    case addedDate = "AddedDate"
    case data = "data"
}
class DataBaseDataTableManager: ProtocolForEachDBm{
    
    var DBm:DatabaseManager
    var tableName = "dataTable"
    
    let formatter :CustomDateFormatter
    
    
    
    init(DBm:DatabaseManager){
        
        self.DBm=DBm

        formatter = CustomDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd" //表示形式を設定

    }
    
    
    
    func loadDataWithSortByAddedDate(classKey:Int)->[DataTableDataListByDate]{
        let returnVal = DataTableModel()
        let results = DBm.loadData(tableNameInDB: tableName, whereColName: DataTableColumnName.classKey.rawValue, whereColVal: String(classKey))
        while(results.next()){
            let Data=self.setToDataEntity(results:results)
            returnVal.setData(data: Data)
        }
        
        
        return returnVal.getAllData().sorted(by: sortByDate)
    }
    func loadDataWithSortByAddedDate(classKey:Int,type:DataTableType)->[DataTableDataListByDate]{
        
        let returnVal = DataTableModel()
       
        let results = DBm.loadData(tableNameInDB: tableName, whereColName1: DataTableColumnName.classKey.rawValue, whereColName2:DataTableColumnName.typeOfData.rawValue,whereColVal1: String(classKey),whereColVal2:String(type.rawValue))
        while(results.next()){
            let Data=self.setToDataEntity(results:results)
            returnVal.setData(data: Data)
        }
        
        
        return returnVal.getAllData().sorted(by: sortByDate)
    }
    
    func loadDataWithDate(classKey:Int,date:Date)->DataTableDataListByDate{
        let returnVal = DataTableDataListByDate()
    
        let results = DBm.loadData(tableNameInDB: tableName, whereColName1: DataTableColumnName.classKey.rawValue, whereColName2:DataTableColumnName.addedDate.rawValue,whereColVal1: String(classKey),whereColVal2:formatter.dateToString(date: date))
        
        returnVal.setDate(date: date)
        if results.next(){
            let Data=self.setToDataEntity(results:results)
            returnVal.setData(data: Data)
        }
       
        return returnVal
    }
    
    
    func sortByDate(this:DataTableDataListByDate, that:DataTableDataListByDate) -> Bool {
        return this.getDate().compare(that.getDate()) == ComparisonResult.orderedAscending
    }
    
    
    
    //Delete
    
    func deleteDataByRowId(rowId:Int)->Bool{
        let  deleteReturnVal = DBm.deleteData(tableNameInDB: tableName, rowName: DataTableColumnName.id.rawValue, rowVal: String(rowId))
        
        return deleteReturnVal
    }
    
    func deleteDataByDate(date:Date,classKey:Int)->Bool{
        var dateString = formatter.dateToString(date: date)
        dateString = "'" + dateString + "'"
    
        let returnVal = DBm.deleteData(tableNameInDB: tableName, rowName1: DataTableColumnName.addedDate.rawValue, rowVal1: dateString, rowName2:DataTableColumnName.classKey.rawValue,rowVal2:String(classKey))
    
        return returnVal
    }
    
    
    
    
    func deleteDataByTableKey(tableKey:Int)->Bool{
        let  deleteReturnVal = DBm.deleteData(tableNameInDB: tableName, rowName: DataTableColumnName.tableKey.rawValue, rowVal: String(tableKey))
        
        return deleteReturnVal
    }
    
    
    
    
    func deleteDataByClassKey(classKey:Int)->Bool{
        let  deleteReturnVal = DBm.deleteData(tableNameInDB: tableName, rowName: DataTableColumnName.classKey.rawValue, rowVal: String(classKey))
        
        return deleteReturnVal

    }
    
    
    
    func deleteDataByIdentifier(identifier:String)->Bool{   //写真のデータ消すのに使おう
        let delVal = "\"" + identifier + "\""
        let  deleteReturnVal = DBm.deleteData(tableNameInDB: tableName, rowName: DataTableColumnName.data.rawValue, rowVal: delVal)
        
        return deleteReturnVal
    }
    
    
    
    
    
    func setData(classKey:Int,tableKey:Int,type:DataTableType,addedDate:Date,data:String){
        let insertSQL =
            "INSERT INTO \(tableName) (\(DataTableColumnName.addedDate.rawValue),\(DataTableColumnName.classKey.rawValue),\(DataTableColumnName.data.rawValue),\(DataTableColumnName.tableKey.rawValue),\(DataTableColumnName.typeOfData.rawValue))" +
        " VALUES (:a,:b,:c,:d,:e)"
        
        let params = ["a": formatter.dateToString(date: addedDate),
                      "b": String(classKey),
                      "c":data,
                      "d":String(tableKey),
                      "e":String(type.rawValue)]
        let _ = DBm.insertData(query: insertSQL, params: params)
    }
    
    
    private func setToDataEntity(results:FMResultSet)->DataTableEntity{
        let Data = DataTableEntity()
        
        Data.id = Int(results.int(forColumnIndex: 0))
        Data.classKey = Int(results.int(forColumnIndex: 1))
        Data.tableKey = Int(results.int(forColumnIndex: 2))
        Data.typeOfData = DataTableType.init(type: Int(results.int(forColumnIndex: 3)))
        Data.addedDate = formatter.stringToDate(dateString: results.string(forColumnIndex: 4))
        Data.data = results.string(forColumnIndex: 5)
   
        return Data
    }
}
