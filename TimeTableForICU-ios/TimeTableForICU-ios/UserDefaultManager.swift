//
//  UserDefaultManager.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/12/23.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import Foundation

class UserDefaultManager: NSObject {
    class func setObject(_ object: AnyObject, forKey: String) {
        UserDefaults.standard.set(object, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    class func objectByKey(_ key: String) -> AnyObject? {
        return UserDefaults.standard.object(forKey: key) as AnyObject?
    }
    
    class func setBool(_ trueOrFalse: Bool, forKey: String) {
        UserDefaults.standard.set(trueOrFalse, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    class func boolByKey(_ key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    class func removeObjectByKey(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func deleteAllData() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
    }
    
    class func setInt(_ intNumber: Int, forKey: String) {
        UserDefaults.standard.set(intNumber, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    class func intByKey(_ key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    
    static let keyForFirstLaunch = "keyForFirstLaunch"
    static let keyForFinishInitialSettings = "keyForFinishInitialSettings"
    static let keyForAddDataFirstShow = "keyForAddDataFirstShow"
    static let keyForLanguage = "keyForLanguage"
    static let keyFor8Period = "keyFor8Period"
    static let keyForSaturday = "keyForSaturday"
    static let keyForFontSize = "keyForFontSize"
    static let keyForCurrentTableKey = "keyForCurrentTableKey"
    
    
    ///初回起動ならtrueを返す　それ以外はfalse
    class func loadIsFirstLaunch() -> Bool{
        guard let launch = objectByKey(keyForFirstLaunch) else {
            UserDefaultManager.saveFirstLaunch(false)
            return true
        }
        return launch.boolValue
    }
    class func saveFirstLaunch(_ first:Bool) {
        setBool(first, forKey: keyForFirstLaunch)
    }
    
    class func loadIsFinishInitialSettings() -> Bool{
        guard let initial = objectByKey(keyForFinishInitialSettings) else {
            saveIsFinishInitialSettings(finish: false)
            return false
        }
        return initial.boolValue
    }
    class func saveIsFinishInitialSettings(finish : Bool){
        setBool(finish, forKey: keyForFinishInitialSettings)
    }
    
    class func loadIsAddDataFirstShow() -> Bool{
        guard let first = objectByKey(keyForAddDataFirstShow) else {
            saveIsAddDataFirstShow(first: false)
            return true
        }
        return first.boolValue
    }
    class func saveIsAddDataFirstShow(first : Bool){
        setBool(first, forKey: keyForAddDataFirstShow)
    }
    
    
    //
    class func loadDefaultLanguage() -> Int{
        guard let lang = objectByKey(keyForLanguage) as? Int else {
            saveDefaultLanguage(lang: Language.jp.rawValue)
            return Language.jp.rawValue
        }
        return lang
    }
    class func saveDefaultLanguage(lang: Int){
        UserDefaultManager.setInt(lang, forKey: keyForLanguage)
    }
    
   //
    class func loadIsEnable8Period() -> Bool{
        guard let period = objectByKey(keyFor8Period) else {
            UserDefaultManager.saveIsEnable8Period(false)
            return false
        }
        return period.boolValue
    }
    class func saveIsEnable8Period(_ enable:Bool) {
        setBool(enable, forKey: keyFor8Period)
    }
    
    //
    class func loadIsEnableSaturday() -> Bool{
        guard let sat = objectByKey(keyForSaturday) else {
            UserDefaultManager.saveIsEnableSaturday(false)
            return false
        }
        return sat.boolValue
    }
    class func saveIsEnableSaturday(_ enable:Bool){
        setBool(enable, forKey: keyForSaturday)
    }
    
    
    //
    class func loadFontSize() -> Int{
        guard let size = objectByKey(keyForFontSize) as? Int else{
            saveFontSize(10)
            return 10
        }
        return size
    }
    class func saveFontSize(_ size:Int){
        setInt(size, forKey: keyForFontSize)
    }
    
    //
    class func loadCurrentTableKey() -> Int{
        guard let tablekey = objectByKey(keyForCurrentTableKey) as? Int else{
            saveCurrentTableKey(tableKey: 0)
            return 0
        }
        return tablekey
    }
    class func saveCurrentTableKey(tableKey:Int){
        setInt(tableKey, forKey: keyForCurrentTableKey)
    }

}


