//
//  DataBaseTableListManager.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/12/23.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import Foundation


class DataBaseTableListManager:ProtocolForEachDBm{
    var DBm:DatabaseManager
  //  var tableName = "testTable"
    var databaseTableName = "tableList"
    
    init(DBm:DatabaseManager){
        self.DBm=DBm
    }

    
    //ここでのtableNameは、tableListで登録する、ユーザーの決めた名前。中ではtableName+tableKeyという形でで扱う
    func insertToTableListWithCreateNewTable(tableName:String,tableYear:Int,tableSeason:TableSeason)->Int{
        let insertSQL =
            "INSERT INTO \(databaseTableName) (tableName,tableYear,tableSeason)" +
        " VALUES (:tableName,:tableYear,:tableSeason)"
        
        let params = ["tableName": tableName,
                      "tableYear": String(tableYear),
                      "tableSeason":tableSeason.rawValue]
        let returnVal=DBm.insertData(query: insertSQL, params: params)
        
        
        DBm.db_createTable(tableName: "tableName"+String(returnVal.rowId))
      //  DBm.db_createDataTable(tableKey: returnVal.rowId)
        var DBTableM=DataBaseTableManager(DBm: DBm,tableKey: returnVal.rowId)
        DBTableM.initilizeTableAll()

        return returnVal.rowId   //tableKey をreturn
    }
    
    func deletFromTableListWithDropTable(tableKey:Int)->(Bool,Bool){
        
        let  deleteReturnVal = DBm.deleteData(tableNameInDB: databaseTableName, rowName: "tableKey", rowVal: String(tableKey))
        
        let DBTableM = DataBaseTableManager(DBm:DBm,tableKey: tableKey)
        let tableDropReturnVal = DBTableM.dropTableWithDeleteScheduleAndDataData()
       // let DBDataTableM = DataBaseDataTableManager(DBm:DBm,tableKey: tableKey)
      //  let dataTableDropReturnVal = DBDataTableM.dropTable()
        
        return (deleteReturnVal,tableDropReturnVal) //成功かどうかを返す？多分・・
    }
    
    
    func loadAllData() ->[TableListDataEntity]{
        
        var tableListDataArray = [TableListDataEntity]()
        
        let result = DBm.loadAllData(tableNameInDB: databaseTableName)
    
        while (result.next()) {
            let tableList = TableListDataEntity()
            tableList.tableKey = Int(result.int(forColumnIndex:0))
            tableList.tableName = result.string(forColumnIndex: 1)
            tableList.tableYear = Int(result.int(forColumnIndex: 2))
            tableList.tableSeason = TableSeason.init(season:result.string(forColumnIndex: 3))
            tableListDataArray.append(tableList)
        }
        
        return tableListDataArray
    }
    
    func loadOneData(tableKey :Int)->TableListDataEntity{
        
        let tableList = TableListDataEntity()
        let result = DBm.loadData(tableNameInDB: databaseTableName, whereColName: "tableKey", whereColVal: String(tableKey))
        
        if result.next() {
            tableList.tableKey = Int(result.int(forColumnIndex:0))
            tableList.tableName = result.string(forColumnIndex: 1)
            tableList.tableYear = Int(result.int(forColumnIndex: 2))
            tableList.tableSeason = TableSeason.init(season:result.string(forColumnIndex: 3))
        }
        
        return tableList

        
    }
    
}
