//
//  DataBaseManagerUpperClass.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/12/02.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import Foundation
import FMDB

class DataBaseManagerUpperClass{
    
  //  private let dbFileName = "DB_for_timetable_test5.db"
    private let dbFileName = "DB_for_timetable.db"

    private let dbName = "DB_for_timetable_15.db"
    var database:FMDatabase!
   

    
    init() {
        setSqlite()
        openDatabase()
    }
    
    deinit{
        closeDatabase()
    }
    
    
    private func setPath()->(String){
        // /Documentsまでのパスを取得
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)
        // <Application>/Documents/test.db というパスを生成
        
        let _path = paths[0].appendingPathComponent(dbFileName)
        return _path
    }
    
    private func setSqlite(){
        if FileManager.default.fileExists(atPath: setPath()) == false {
            //ファイルがない場合はコピー
            let defaltDBPath :String = Bundle.main.path(forResource: dbName, ofType:nil)!
            
            //  let resourcePath = Bundle.main.resourceURL!.absoluteString
            
            // let defaltDBPath = resourcePath.appending("DB_for_timetable_12.db")
            
            
            
            do{
                try FileManager.default.copyItem(atPath: defaltDBPath, toPath: setPath())
                if FileManager.default.fileExists(atPath: setPath()) == false {
                    //error
                    print("Copy error = " + defaltDBPath)
                }else{
                    print("DB file OK")
                }
                
            }catch let error as NSError {
                print("setSqlite      Error: \(error.domain)")
            }
        }
        
    }

    
    private func openDatabase() {
        database = FMDatabase(path: setPath())
        
        /* Open database read-only. */
        
        if (!database.open()){
            print("Could not open database.")
            
        } else {
            print("database open")
        }
    }
    
    private func closeDatabase() {
        if (database != nil) {
            print("close database")
            database.close()
        }
    }
    

    
    
}
