//
//  GAUtility.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/15.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import Foundation


enum GAScreenName:String{
    
    case mainTable = "MainTable"
    case leftMenu = "LeftMenu"
    case scheduleList = "scheduleList"
    case addData = "addData"
    case modifyData = "modifyData"
  
}
enum GAEventCategory:String{
    case category = "category"
    case classInfo = "ClassInfo"
}
enum GAEventAction:String{
    case action = "action"
    case addedClassInfo = "AddedClassInfo"
}
class GAUtility{
    
    

    static func GASetUp(){
        // トラッカーの作成
        let tracker = GAI.sharedInstance()
        tracker?.tracker(withTrackingId: "***")
        //オプション：例外情報を自動的にGoogleへ送信する
        tracker?.trackUncaughtExceptions = true  // report uncaught exceptions
        //コンソールにデバッグ情報を表示する
      //  tracker?.logger.logLevel = GAILogLevel.verbose  // remove before app release
        //データの送信間隔
        tracker?.dispatchInterval = 2

    }
    
    static func sendScreenTracking(screenName: GAScreenName) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: screenName.rawValue)
        tracker?.send(GAIDictionaryBuilder.createScreenView().build() as [NSObject: AnyObject])
        tracker?.set(kGAIScreenName, value: nil)
    }
    
    static func sendEventTracking(category:GAEventCategory,action:GAEventAction,label:String){
        
        //トラッカーの定義
        let tracker = GAI.sharedInstance().defaultTracker
        
        //イベントトラッキング
        let EventBuilder = GAIDictionaryBuilder.createEvent(withCategory: category.rawValue, action: action.rawValue, label: label, value: nil).build() as [NSObject:AnyObject]
        
        tracker?.send(EventBuilder)
        
        
    }
    
}
