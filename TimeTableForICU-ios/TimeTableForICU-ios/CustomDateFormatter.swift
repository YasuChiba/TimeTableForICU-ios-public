//
//  CustomDateFormatter.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/07.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import Foundation

class CustomDateFormatter{
    
    var dateFormat = "yyyy/MM/dd"
    
    func dateToString(date:Date)->String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = dateFormat

        return formatter.string(from: date)
    }
    
    func stringToDate(dateString:String)->Date{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = dateFormat

        return formatter.date(from: dateString)!
    }
    
}
