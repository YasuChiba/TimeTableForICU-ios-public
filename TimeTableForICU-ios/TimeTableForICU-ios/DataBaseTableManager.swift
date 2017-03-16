//
//  DataBaseTableManager.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/12/02.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import Foundation
import FMDB
class DataBaseTableManager: ProtocolForEachDBm{
    
    var DBm:DatabaseManager
    var tableName:String?
    var tableKey = 0
    
    init(DBm:DatabaseManager,tableKey:Int){
        
        self.DBm=DBm
        self.tableKey = tableKey
        self.tableName = getTableName(tableKey: tableKey)
    }
    
    private func getTableName(tableKey:Int)->String{
        return "tableName"+String(tableKey)
    }
    
    //MARK : loadData
    func loadTableData(id:Int)->TableDataEntity{
        var Data:TableDataEntity!
        let results = DBm.loadData(tableNameInDB: tableName! , whereColName:"id",whereColVal: "\'\(String(id))\'")
        if results.next(){
            Data = self.setTableDataEntity(results:results)
        }
        
        print(Data)
        
        return Data
    }
    
    func loadTableDataByEachColumn(week: columnWeek)->[TableDataEntity]{
        let columnNum = week.rawValue
        var tableDataArray:[TableDataEntity]=[]
        for periodNum in 1..<9{
            let tableData = self.loadTableData(id: periodNum*10+columnNum)
            tableDataArray.append(tableData)
        }
        return tableDataArray
    }
    
    func loadTableDataByEachClass(classKey:Int)->[TableDataEntity]{
        var tableDataArray:[TableDataEntity]=[]
        let results = DBm.loadData(tableNameInDB: tableName! , whereColName:"classKey",whereColVal: "\'\(String(classKey))\'")
        while(results.next()){
            let Data=self.setTableDataEntity(results:results)
            tableDataArray.append(Data)
        }
        return tableDataArray
    }
    func loadPeriodDataByEachClass(classKey:Int) ->[Int]{
        var returnVal:[Int] = []
        
        let datas = self.loadTableDataByEachClass(classKey: classKey)
        for tmp in datas{
            returnVal.append(tmp.period)
        }
        
        return returnVal
    }
    

    func loadClassName(classKey:Int,tableKey:Int)->(String,String){
        let tableName = getTableName(tableKey: tableKey)
        var tableDataArray:[TableDataEntity]=[]
        let results = DBm.loadData(tableNameInDB: tableName , whereColName:"classKey",whereColVal: "\'\(String(classKey))\'")
        if results.next(){
            let Data=self.setTableDataEntity(results:results)
            return (Data.jTitle,Data.eTitle)
        }
        return ("","")
    }

    private func setTableDataEntity(results:FMResultSet)->TableDataEntity{
        let Data=TableDataEntity()
        
        Data.period = Int(results.int(forColumnIndex: 1))
        Data.classKey = Int(results.int(forColumnIndex: 2))
        Data.jTitle = results.string(forColumnIndex:3)
        Data.eTitle = results.string(forColumnIndex:4)
        Data.classRoom = results.string(forColumnIndex:5)
        Data.teacher = results.string(forColumnIndex: 6)
        Data.initialize = Int(results.int(forColumnIndex: 7))
        Data.L4=Int(results.int(forColumnIndex:8))
        Data.sy_id=Int(results.int(forColumnIndex:9))
        Data.color = results.string(forColumnIndex: 10)
        Data.textColor = results.string(forColumnIndex: 11)
        Data.rgno = Int(results.int(forColumnIndex: 12))
        return Data
    }

    
    
    //MARK : UPDATE
    
    func updateTableData(data:TableDataEntity,period:Int,classKey:Int)->(success:Bool,classKey:Int){
        
        let sql = "UPDATE \(tableName!) SET classKey = :classKey,Jtitle = :Jtitle, Etitle = :Etitle,classroom =:classroom, teacher =:teacher, initialize = :initialize, L4 = :L4, sy_id = :sy_id, color = :color, textColor =:textColor, rgno =:rgno WHERE id = :ID;"
        
        print("table update sql   \(sql)")
        let params = ["classKey" : classKey,
                      "Jtitle" : data.jTitle,
                      "Etitle" : data.eTitle,
                      "classroom": data.classRoom,
                      "teacher": data.teacher,
                      "initialize":data.initialize,
                      "L4": data.L4,
                      "sy_id" : data.sy_id,
                      "color":data.color,
                      "textColor":data.textColor,
                      "ID":String(period),
                      "rgno":String(data.rgno)] as [String : Any]
        
        return (success:DBm.upadateData(query: sql, params: params),classKey:classKey)
    }
    
    func updateTableDataByClassWithCreateNewClass(data:[TableDataEntity],numPeriods:[Int]){  //classKeyが存在しない、新しいclassを登録する用
        let classKey = self.getLastClassKeyWithIncrement()
        
        for i in 0..<numPeriods.count{
            var L4=TableStatus.notL4.rawValue
            let tmp1:Int=numPeriods[i]/10
            var num = numPeriods[i]
            if tmp1 == 9 {                         //ろんふぉーの時、table1の４０番第に入れるための処理。剰余つかって判定。9が来たら４に変える　そしてtable1の要素のL4に１を代入する。
                num = 40+numPeriods[i]%10
                L4=TableStatus.L4.rawValue
            }
            data[i].L4 = L4
            self.updateTableData(data: data[i], period: num,classKey: classKey)
        }
    }
    
    func updateTableDataByClassWithOverrideCurrentClass(data:[TableDataEntity],numPeriods:[Int],classKey:Int){//すでにclassKeyが存在するクラスのデータを上書きする用
        for i in 0..<numPeriods.count{
            var L4=TableStatus.notL4.rawValue
            let tmp1:Int=numPeriods[i]/10
            var num = numPeriods[i]
            if tmp1 == 9 {                         //ろんふぉーの時、table1の４０番第に入れるための処理。剰余つかって判定。9が来たら４に変える　そしてtable1の要素のL4に１を代入する。
                num = 40+numPeriods[i]%10
                L4=TableStatus.L4.rawValue
            }
            data[i].L4 = L4
            self.updateTableData(data: data[i], period: num,classKey: classKey)
        }
    }
    
    //Drop
    
    
    func dropTableWithDeleteScheduleAndDataData()->Bool{
        let returnVal = DBm.dropTable(tableNameInDB: tableName!)
        let DBDataTableM = DataBaseDataTableManager(DBm: DBm)
        _ = DBDataTableM.deleteDataByTableKey(tableKey: tableKey)
        let DBScheduleTableM = DataBaseScheduleTableManager(DBm:DBm)
        _ = DBScheduleTableM.deleteDataByTableKey(tableKey: tableKey)
        
        return returnVal
    }
    
   
    
    
    //Initialize
    
    
    func initializeTableOnePeriod(periodId : Int){
        var data:TableDataEntity = TableDataEntity()
        data.classKey = TableStatus.initialClassKey.rawValue
        data.classRoom = ""
        data.color = ""
        data.eTitle = ""
        data.initialize = TableStatus.tableInitialized.rawValue
        data.jTitle = ""
        data.L4 = TableStatus.notL4.rawValue
        data.sy_id = TableStatus.initialSy_id.rawValue
        data.teacher = ""
        data.textColor = ""
        data.rgno = TableStatus.initRgno.rawValue
        updateTableData(data: data, period: periodId,classKey:TableStatus.initialClassKey.rawValue)
    }
    func initializeTableByPeriodList(periodNums :[Int]){
        for tmp in periodNums{
            self.initializeTableOnePeriod(periodId: tmp)
        }
    }
    
    func initializeTableOneClassWithDeleteScheduleAndDataData(classKey : Int){
        let data = self.loadTableDataByEachClass(classKey: classKey)
        let DBDataTableM = DataBaseDataTableManager(DBm:DBm)
        let DBScheduleTableM = DataBaseScheduleTableManager(DBm:DBm)
        
        let photoData = DBDataTableM.loadDataWithSortByAddedDate(classKey: classKey, type: .photo)
        
        _ = DBDataTableM.deleteDataByClassKey(classKey:classKey)
        _ = DBScheduleTableM.deleteDataByClassKey(classKey:classKey)
        
        for tmp in data{
            self.initializeTableOnePeriod(periodId: tmp.period)
        }
        for tmp in photoData{
            for t in tmp.getData(){
                CameraAndFileIOUtils.deleteImage(identifier: t.data, completion: {})
            }
        }
    }
    
    func initilizeTableAll(){
        for i in 1..<7{
            for j in 1..<10{
                let period = j*10+i
                initializeTableOnePeriod(periodId: period)

            }
        }
    }
    
    
    
    func chackInitializeByPeriod(periodList:[Int])->[Int]{   //not initialized なコマを返す
        var returnVal:[Int] = []
        print("chekInitialize by period \(periodList)")
        for tmp in periodList {
            if tmp/10 == 9{
                let data = self.loadTableData(id: tmp-50)
                if data.initialize == TableStatus.tableNotInitialized.rawValue{
                    returnVal.append(tmp)
                }
            }else{
                let data = self.loadTableData(id: tmp)
                if data.initialize == TableStatus.tableNotInitialized.rawValue{
                    returnVal.append(tmp)
                }
            }
           
        }
        return returnVal
    }
    
    
    
    
    
    
    
    
    
    
    private func getLastClassKeyWithIncrement()->Int{
        var returnVal = 0
        if (UserDefaults.standard.object(forKey: "lastClassKey") != nil) {
            returnVal = UserDefaults.standard.integer(forKey: "lastClassKey")
        }
        UserDefaults.standard.set(returnVal+1, forKey: "lastClassKey")
        UserDefaults.standard.synchronize()

        return returnVal
    }
    
    
    
    
    
    
}
