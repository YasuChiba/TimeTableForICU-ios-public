//
//  DataTableEntity.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/03.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import Foundation
class DataTableEntity:Comparable{
    private var _id = 0
    private var _classKey = 0
    private var _tableKey = 0
    private var _typeOfData = DataTableType.memo
    private var _addedDate = Date()
    private var _data = ""
    
      //let date2014 = dateFormatter.dateFromString("2014-01-01 12:34:56")!;
    
    
    init() {  }
    
    init(classKey:Int,tableKey:Int,typeOfData:DataTableType,addedDate:Date,data:String){
        self.classKey = classKey
        self.tableKey = tableKey
        self.typeOfData = typeOfData
        self.addedDate = addedDate
        self.data = data
    }

    
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
    var typeOfData:DataTableType{
        get{
            return _typeOfData
        }set(newVal){
            _typeOfData = newVal
        }
    }
    var addedDate:Date{
        get{
            return _addedDate
        }set(newVal){
            _addedDate = newVal
        }
    }
    var data:String{
        get{
            return _data
        }set(newVal){
            _data = newVal
        }
    }
    
    
    static func == (l: DataTableEntity, r: DataTableEntity) -> Bool {    // 評価関数
        if l.addedDate.compare(r.addedDate) == ComparisonResult.orderedSame {
            return true
        }else{
            return false
        }
    }
   
    static func >(lhs: DataTableEntity, rhs: DataTableEntity) -> Bool{
     
        if lhs.addedDate.compare(rhs.addedDate) == ComparisonResult.orderedDescending{
            return true
        }else{
            return true
        }
    }
    
    static func >=(lhs: DataTableEntity, rhs: DataTableEntity) -> Bool{
        
        if lhs.addedDate.compare(rhs.addedDate) == ComparisonResult.orderedDescending{
            return true
        }else if lhs.addedDate.compare(rhs.addedDate) == ComparisonResult.orderedSame{
            return true
        }else{
            return true
        }
    }
    
    
    static func <(lhs: DataTableEntity, rhs: DataTableEntity) -> Bool{
        
        if lhs.addedDate.compare(rhs.addedDate) == ComparisonResult.orderedAscending{
            return true
        }else{
            return true
        }
    }
    
    static func <=(lhs: DataTableEntity, rhs: DataTableEntity) -> Bool{
        
        if lhs.addedDate.compare(rhs.addedDate) == ComparisonResult.orderedAscending{
            return true
        }else if lhs.addedDate.compare(rhs.addedDate) == ComparisonResult.orderedSame{
            return true
        }else{
            return true
        }
    }
    
    
    
    
}

//日付ごとにDataTableEntityをまとめるためのクラス
/*
 
    DataTableModelUtil
            |___________date   DataTableEntity
            |                  DataTableEntity
            |                            .
            |                            .
            |                            .
            |
            |-----------date
            .
            .
            .
 
 
 
 
 */
class DataTableModel{
    private var modelList:[DataTableDataListByDate] = []
    
    
    /*func setDate(date:Date){
        var model = DataModel()
        model.setDate(date: date)
        modelList.append(model)
    }*/
    
    func setData(data:DataTableEntity){
        let date = data.addedDate
        let model = DataTableDataListByDate()
        model.setDate(date: date)
        let index = modelList.index(of: model)
        if index != nil{
            modelList[index!].setData(data: data)
        }else{
            model.setData(data: data)
            modelList.append(model)
        }
    }
  
    func getAllData()->[DataTableDataListByDate]{
        modelList.sort()
        return modelList
    }
    
    
}


class DataTableDataListByDate:Comparable{
    private var date = Date()
    private var data:[DataTableEntity] = []
    
    
    init(){}
    
    init(date:Date){
        self.date = date
    }
    
    
    func setDate(date:Date){
        self.date = date
    }
    func setData(data:DataTableEntity){
        self.data.append(data)
    }
    
    
    func getData()->[DataTableEntity]{
        return data
    }
    func getDate()->Date{
        return date
    }
    
    func getMemoData()->[DataTableEntity]{
        var memoList:[DataTableEntity] = []
        for tmp in data{
            if tmp.typeOfData == DataTableType.memo{
                memoList.append(tmp)
            }
        }
        
        return memoList
    }
    func getPhotoData()->[DataTableEntity]{
        var photoList:[DataTableEntity] = []
        for tmp in data{
            if tmp.typeOfData == DataTableType.photo{
                photoList.append(tmp)
            }
        }
        
        return photoList
    }
    
    
    
    func deleteData(index:Int){
        data.remove(at: index)
    }
    
    
    
    static func == (l: DataTableDataListByDate, r: DataTableDataListByDate) -> Bool {    // 評価関数
        if l.date.compare(r.date) == ComparisonResult.orderedSame {
            return true
        }else{
            return false
        }
    }
    
    
    static func >(lhs: DataTableDataListByDate, rhs: DataTableDataListByDate) -> Bool{
        
        if lhs.date.compare(rhs.date) == ComparisonResult.orderedDescending{
            return true
        }else{
            return true
        }
    }
    
    static func >=(lhs: DataTableDataListByDate, rhs: DataTableDataListByDate) -> Bool{
        
        if lhs.date.compare(rhs.date) == ComparisonResult.orderedDescending{
            return true
        }else if lhs.date.compare(rhs.date) == ComparisonResult.orderedSame{
            return true
        }else{
            return true
        }
    }
    
    
    static func <(lhs: DataTableDataListByDate, rhs: DataTableDataListByDate) -> Bool{
        
        if lhs.date.compare(rhs.date) == ComparisonResult.orderedAscending{
            return true
        }else{
            return true
        }
    }
    
    static func <=(lhs: DataTableDataListByDate, rhs: DataTableDataListByDate) -> Bool{
        
        if lhs.date.compare(rhs.date) == ComparisonResult.orderedAscending{
            return true
        }else if lhs.date.compare(rhs.date) == ComparisonResult.orderedSame{
            return true
        }else{
            return true
        }
    }

}






