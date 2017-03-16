//
//  DevideScheduleString.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/11/29.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import Foundation

class DevideScheduleString{
  
//  public static func devideScheduleStringToStringArray(schedule_string: String)->[String]{
//    
//    return schedule_string.components(separatedBy: " ")
//    
//  }
    //
    
    
    
    public static func devideScheduleStringToIntArray(schedule_string : String)->[Int]{
        var data:[Int]=[]
    
        let array=schedule_string.components(separatedBy: " ")
    
        for d in array{
            if !d.isEmpty{
                data.append(Int(d)!)
            }
        }
    
        return data
    }
  
    public static func connectScheduleNumArray(scheduleNumArray:[Int])->String{
      var schedule_string : String
    
      schedule_string = String(scheduleNumArray[0])
      for i in 1..<scheduleNumArray.count{
          schedule_string=schedule_string+" \(String(scheduleNumArray[i]))"
      }
    
      return schedule_string
    }
    
    public static func scheduleNumArrayToInitialStringWithSort(scheduleNumArray:[Int])->String{
        var data = scheduleNumArray
        data.sort(by:{ (this:Int,that:Int)->Bool in
            
            if this%10 > that%10{
                return false
            }else if this%10 == that%10{
                if this/10>that/10{
                    return false
                }else{
                    return true
                }
            }else{
                return true
            }
        })

        data.sort(by: sortByPeriod)
        var initialString=""
        initialString = numToInitial(scheduleNum: data[0])
        
        for i in 1..<data.count{
           initialString = initialString+" \(numToInitial(scheduleNum: data[i]))"
        }
        
        return initialString
    }
    
    
    static func sortByPeriod(this:Int,that:Int)->Bool{
        if this%10 > that%10{
            return false
        }else if this%10 == that%10{
            if this/10>that/10{
                return false
            }else{
                return true
            }
        }else{
            return true
        }
    }
    

    public static func devideScheduleNumToInitialArray(scheduleNumArray:[Int])->[String]{
  
        var initialArray:[String]=[]
        for d in scheduleNumArray{
            initialArray.append(numToInitial(scheduleNum: d))
        }
        return initialArray
    }
    
    
    
    public static func devideScheduleNumToInitialArray(scheduleNumArray:Int)->String{
        return numToInitial(scheduleNum: scheduleNumArray)
    }
    
    
    /*
    public static func devideScheduleAddDataEntityToInitialArray(AddDataEntArray:[AddDataEntity])->[String]{
        
        var tmpIntArray:[Int] = []
        
        for tmp in AddDataEntArray{
            tmpIntArray.append(tmp.scheduleNum)
        }
        let returnArray:[String]=devideScheduleNumToInitialArray(scheduleNumArray: tmpIntArray)
        return returnArray
    }
    
    public static func devideScheduleAddDataEntityToInitialArray(addDataEnt:AddDataEntity)->String{
        return devideScheduleNumToInitialArray(scheduleNumArray: addDataEnt.scheduleNum)
    }
    */
    
    private static func numToInitial(scheduleNum:Int)->String{
        var week = ""
        var val:String=""
        if scheduleNum==0 {
            
        }else{
            let num = Int(scheduleNum)
            let weekNum = num % 10
            let periodNum = (num-weekNum)/10
            
            if weekNum == 1{
                week="Mon"
            }
            else if weekNum == 2{
                week="Tue"
            }
            else if weekNum == 3{
                week="Wed"
            }
            else if weekNum == 4 {
                week="Thu"
            }
            else if weekNum == 5 {
                week="Fri"
            }
            else if weekNum == 6 {
                week="Sat"
            }
            
            if periodNum == 9 {
                val=week + "/" + "*"+"4"
            }
            else {
                val=week + "/" + String(periodNum)
            }
        }

        return val
    }
}
