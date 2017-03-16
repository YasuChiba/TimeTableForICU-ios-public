//
//  SyllabusEntity.swift
//  timetable1
//
//  Created by 彌平千葉 on 2016/10/29.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import Foundation


class SyllabusEntity{
    
    private var _rgno = -11
    private var _eTitle = ""
    private var _jTitle = ""
    private var _title = ""
    private var _schedule = ""
    private var _scheduleString = ""
    private var _room = ""
    private var _instructor = ""
    
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
    var title:String{
        get{
            return _title
        }
        set(newVal){
            _title=newVal
        }
    }

    var schedule:String{
        get{
            return _schedule
        }
        set(newVal){
            _schedule=newVal
        }
    }

    var scheduleString:String{
        get{
            return _scheduleString
        }
        set(newVal){
            _scheduleString=newVal
        }
    }

    var room:String{
        get{
            return _room
        }
        set(newVal){
            _room=newVal
        }
    }


    var instructor:String{
        get{
            return _instructor
        }
        set(newVal){
            _instructor=newVal
        }
    }

    
    
    
    
}
