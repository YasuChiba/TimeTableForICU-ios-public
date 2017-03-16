//
//  DataBaseSyllabusManager.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/12/02.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import Foundation

class DataBaseSyllabusManager:ProtocolForEachDBm{
    
    var DBm:DatabaseManager
    var seasonPlusYear:String?
    
    init(DBm:DatabaseManager,season:String,year:String){
        
        self.DBm=DBm
        self.seasonPlusYear = season+year
    }
    
    

    
    
    func loadDataFromSyllabus(periodNot90:Int) -> Array<SyllabusEntity>{  //90番台はロンフォーで、４限とまとめてひっぱるから
        
        var i=0
        var Data : [SyllabusEntity] = []
        var period=periodNot90
        if(period/10==4){
            i=2
        }else{
            i=1
        }
        print("load data from syllabus season \(seasonPlusYear)")
        while(i>=1){
            let results=DBm.loadData(tableNameInDB: seasonPlusYear!, whereColName:"s\(period)" ,whereColVal: String(1))
//            let sql = "SELECT * FROM \(season!) where s\(period) = 1;"
//            let results = database.executeQuery(sql, withParameterDictionary: nil)
            
            while (results.next()) {
                // カラム名を指定して値を取得する方法
                let tmpData = SyllabusEntity()
                tmpData.rgno = Int(results.int(forColumn : "rgno"))
                tmpData.eTitle = (results.string(forColumn: "etitle"))!
                tmpData.jTitle = (results.string(forColumn: "jtitle"))!
                tmpData.instructor = (results.string(forColumn: "instructor"))!
                tmpData.room = (results.string(forColumn: "room"))!
                tmpData.schedule = (results.string(forColumn: "schedule"))!
                tmpData.scheduleString = (results.string(forColumn: "schedule_string"))!
                
                Data.append(tmpData)
            }
            i-=1
            period+=50
        }
        
        return Data
        
    }

    
    
}
