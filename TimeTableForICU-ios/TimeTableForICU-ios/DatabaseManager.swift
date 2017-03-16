//
//  DatabaseManager.swift
//  timetable1
//
//  Created by 彌平千葉 on 2016/10/24.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import Foundation
import FMDB

class DatabaseManager:DataBaseManagerUpperClass {
    
 
    override init(){
        super.init()
    }
    
    
    
    func loadData(tableNameInDB:String, whereColName:String,whereColVal:String)->FMResultSet{
        
        let sql = "SELECT * FROM \(tableNameInDB) WHERE \(whereColName) = \(whereColVal);"
        print("loading query : \(sql)")
        let results = database.executeQuery(sql, withArgumentsIn:nil)
        
        return results!
    }
    func loadData(tableNameInDB:String,whereColName1:String,whereColName2:String,whereColVal1:String,whereColVal2:String)->FMResultSet{
        
        let sql = "SELECT * FROM \(tableNameInDB) WHERE \(whereColName1) = \(whereColVal1) AND \(whereColName2) = \(whereColVal2);"
        print("loading query : \(sql)")
        let results = database.executeQuery(sql, withArgumentsIn:nil)
        
        return results!
        
    }
    func loadAllData(tableNameInDB:String)->FMResultSet{
        let sql = "SELECT * FROM \(tableNameInDB);"
        print("loading query : \(sql)")
        let results = database.executeQuery(sql, withArgumentsIn:nil)
        
        return results!

    }
    
    func upadateData(query:String,params:[AnyHashable:Any]) -> Bool {
       //例 let sql = "UPDATE sample SET user_name = :NAME WHERE user_id = :ID;"
        
        var returnVal=true
        if !self.database.executeUpdate(query, withParameterDictionary: params) {
            // エラー時処理。SQL構文エラー、外部キー制約エラーなど
            print("update error")
            returnVal=false
        }else{
           
        }
        return returnVal
    }
    
    func deleteData(tableNameInDB:String, rowName:String,rowVal:String) -> Bool{
        let sql = "DELETE FROM \(tableNameInDB) WHERE \(rowName) = \(rowVal);"
        print("delete : DELETE FROM \(tableNameInDB) WHERE \(rowName) = \(rowVal);")
        var returnVal=true
        if !self.database.executeUpdate(sql, withParameterDictionary: nil) {
            // エラー時処理。SQL構文エラー、外部キー制約エラーなど
            print("delete error")
            returnVal=false
        }else{
            
        }
        return returnVal
    }
    
    
    func deleteData(tableNameInDB:String, rowName1:String,rowVal1:String,rowName2:String,rowVal2:String) -> Bool{
        let sql = "DELETE FROM \(tableNameInDB) WHERE \(rowName1) = \(rowVal1) AND \(rowName2) = \(rowVal2);"
        print(sql)
        var returnVal=true
        if !self.database.executeUpdate(sql, withParameterDictionary: nil) {
            // エラー時処理。SQL構文エラー、外部キー制約エラーなど
            print("delete error")
            returnVal=false
        }else{
            
        }
        return returnVal
    }
    
    
    
    func dropTable(tableNameInDB:String)->Bool{
        let sql = "drop table \(tableNameInDB);";
        let result = database.executeUpdate(sql, withArgumentsIn: nil)
        
        return result
    }
    
    func createTable(query:String)->Bool {
       
        let result = database.executeUpdate(query, withArgumentsIn: nil)
        var returnVal=true
        if result{
        }else{
            print("cannot make new table")
            returnVal=false
        }
        return returnVal
    }
    
    func insertData(query:String,params:[AnyHashable:Any])->(sucess:Bool,rowId:Int){
        
//        例
//        let insertSQL =
//            "INSERT INTO my_syllabus (Jtitle,Etitle,schedule,room,instructor,schedule_string)" +
//        " VALUES (:Jtitle,:Etitle,:schedule,:room,:instructor,:schedule_string)"
//        
//        let params = ["Jtitle": data.jTitle,
//                      "Etitle": data.eTitle,
//                      "schedule": data.schedule,
//                      "room": data.room,
//                      "instructor":data.instructor,
//                      "schedule_string":data.scheduleString]
//
        
        
        var returnVal=true
        var rowId = -1
        
        if !self.database.executeUpdate(query, withParameterDictionary: params) {
            // エラー時処理。SQL構文エラー、外部キー制約エラーなど
            print("insert error")
            returnVal=false
        }else{
            rowId = Int(database.lastInsertRowId())
        }
        return (returnVal,rowId)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    private func db_insertInitialTableData(tableName:String,id : Int){
        
        let query = "insert into "+tableName+"('id','classKey','Jtitle','Etitle','classroom','teacher','initialize','L4','sy_id','color','textColor','rgno') values('"+String(id)+"','-10','sample','sample','sample','sample','0','1','-1','#ffffff','#000000','-11');"
        database.executeUpdate(query, withArgumentsIn: nil)

    }
    
    
    
    //移動がめんどいからこのまま
    func db_createTable(tableName:String){
        
        let query_table = "create table "+tableName+" ('_id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'id' TEXT,'classKey' INTEGER,'Jtitle' TEXT,'Etitle' TEXT,'classroom' TEXT, 'teacher' TEXT,'initialize' INTEGER, 'L4' INTEGER,'sy_id' INTEGER,'color' TEXT,'textColor' TEXT,'rgno' INTEGER );";

        let ret = database.executeUpdate(query_table, withArgumentsIn: nil)
        if ret{
            
            for i in 1..<10{
                for j in 1..<7{
                    db_insertInitialTableData(tableName: tableName, id: i*10+j)
                }
            }
            
        }else{
            print("cannot create new db")
        }
        
    }
    /*
    func db_createDataTable(tableKey:Int){
        let tableName = "dataTable" + String(tableKey)
        
        let query = "CREATE TABLE "+tableName+" ('_id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'ClassKey' INTEGER,'IsMemo' INTEGER,'AddedDate' INTEGER,'data' TEXT);"
        let ret = database.executeUpdate(query, withArgumentsIn : nil)
        if ret{
            
        }else{
            print("cannnot create new data table")
        }
    }*/
    
}
