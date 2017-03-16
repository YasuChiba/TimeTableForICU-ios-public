//
//  TableDataEntity.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/12/01.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import Foundation



class TableDataEntity{
    
  
    private var _period = 11

    private var _classKey = -10
    private var _rgno = -11
    private var _jTitle=""
    private var _eTitle=""
    private var _classRoom=""
    private var _teacher=""
    private var _initialize = -1
    private var _L4 = -1
    private var _sy_id = -1          //使ってない
    private var _color=""
    private var _textColor=""
    
    
    var period:Int{
        get{
            return _period
        }
        set(newVal){
            _period = newVal
        }
    }
    
    var classKey:Int{
        get{
            return _classKey
        }
        set(newVal){
            _classKey=newVal
        }
    }
    
    var rgno:Int{
        get{
            return _rgno
        }
        set(newVal){
            _rgno=newVal
        }
    }

    
    var eTitle:String{
        get{
            return _eTitle
        }
        set(newVal){
            _eTitle=newVal
        }
    }
    
    
    var jTitle:String{
        get{
            return _jTitle
        }
        set(newVal){
            _jTitle=newVal
        }
    }
    
    var classRoom:String{
        get{
            return _classRoom
        }
        set(newVal){
            _classRoom=newVal
        }
    }
    var teacher:String{
        get{
            return _teacher
        }
        set(newVal){
            _teacher=newVal
        }
    }

    var initialize:Int{
        get{
            return _initialize
        }
        set(newVal){
            _initialize=newVal
        }
    }
    var L4:Int{
        get{
            return _L4
        }
        set(newVal){
            _L4=newVal
        }
    }
    var sy_id:Int{
        get{
            return _sy_id
        }
        set(newVal){
            _sy_id=newVal
        }
    }
   
    var color:String{
        get{
            return _color
        }
        set(newVal){
            _color=newVal
        }
    }
    var textColor:String{
        get{
            return _textColor
        }
        set(newVal){
            _textColor=newVal
        }
    }
    


    
    
    
    
    
}
