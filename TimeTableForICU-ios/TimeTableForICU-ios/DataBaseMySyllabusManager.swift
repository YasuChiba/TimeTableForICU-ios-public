//
//  DataBaseMySyllabusManager.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/12/02.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import Foundation


class DataBaseMySyllabusManager00000000:ProtocolForEachDBm{
    var DBm:DatabaseManager
    let tableName = "my_syllabus"
    
    init(DBm:DatabaseManager){
        
        self.DBm=DBm
        
    }

    
    
    func insertToMy_sy(data:SyllabusEntity,periodNums:[Int])->Int{
        
        let insertSQL =
            "INSERT INTO \(tableName) (Jtitle,Etitle,schedule,room,instructor,schedule_string)" +
        " VALUES (:Jtitle,:Etitle,:schedule,:room,:instructor,:schedule_string)"
        
        let params = ["Jtitle": data.title,
                      "Etitle": data.eTitle,   //実質なにもいれてない
                      "schedule": data.schedule,
                      "room": data.room,
                      "instructor":data.instructor,
                      "schedule_string":data.scheduleString]
        
        let returnVal=DBm.insertData(query: insertSQL, params: params)
        
        return returnVal.rowId
    }
    func loadFromMySy(msy_id : Int)-> SyllabusEntity{
        let data = SyllabusEntity()
        let results = DBm.loadData(tableNameInDB: tableName, whereColName: "id", whereColVal: String(msy_id))
        if results.next(){
            
            data.jTitle = results.string(forColumnIndex:1)
            data.eTitle = results.string(forColumnIndex: 2)
            data.schedule = results.string(forColumnIndex: 3)
            data.room = results.string(forColumnIndex: 4)
            data.instructor = results.string(forColumnIndex: 5)
            data.scheduleString = results.string(forColumnIndex: 6)
        }

        return data
    }
/*    func returnAllIdInMySy()->[Int]{
        let result = DBm.loadAllData(tableNameInDB: tableName)
        var intArray:[Int] = []
        while(result.next()){
            intArray.append(Int(result.int(forColumnIndex: 0)))
        }
        
        return intArray
    }*/
    func deleteFromMySy(msy_id : Int){
       let success = DBm.deleteData(tableNameInDB: tableName, rowName: "id", rowVal: String(msy_id))
        
    }
    

    
}
