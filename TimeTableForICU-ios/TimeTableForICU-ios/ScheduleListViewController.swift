//
//  ScheduleListViewController.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/15.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import UIKit
import Material
class ScheduleListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    fileprivate var tableController:ScheduleListTableController!
    fileprivate var DBm:DatabaseManager!
    fileprivate var DBTableM:DataBaseTableManager!
    fileprivate var DBScheduleTableM:DataBaseScheduleTableManager!
    
    fileprivate var scheduleData: [ScheduleListDataEntity]=[]
    fileprivate var lang:Language!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLeftBarButtonWithImage(Icon.menu!)
        self.title = "Schedule List"
        
        DBm=DatabaseManager()
        DBTableM=DataBaseTableManager(DBm: DBm,tableKey: 0)
        DBScheduleTableM = DataBaseScheduleTableManager(DBm:DBm)
        
        lang =  Language.init(lang: UserDefaultManager.loadDefaultLanguage())
        
        self.setData()
        tableController = ScheduleListTableController(viewCon: self)
        tableView.dataSource = tableController
        tableView.separatorColor = UIColor.clear
        
        GAUtility.sendScreenTracking(screenName: .scheduleList)

        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    

}


//データ扱う系
extension ScheduleListViewController{
    
    func setData(){   //ここでデータの加工（dateをStringになおしたり）もしてる
        var formatter = CustomDateFormatter()
        formatter.dateFormat = "M/d" //表示形式を設定
        scheduleData = []
        let currentTableKey = UserDefaultManager.loadCurrentTableKey()

        let allData = DBScheduleTableM.loadAllDataWithSortByDueDate(tableKey:currentTableKey)
        for data in allData{

            var dataent = ScheduleListDataEntity()
            dataent.setDate(date:formatter.dateToString(date: data.dueDate))
            dataent.setMemo(memo: data.memo)
            dataent.setId(id: data.id)

            if data.typeOfSchedule.rawValue == 0{
                dataent.setScheduleType(scheduleType: "Assignment")
            }else{
                dataent.setScheduleType(scheduleType: "Test")
            }
            
            if lang == .jp{
                 dataent.setCourseTitle(courseTitle: DBTableM.loadClassName(classKey: data.classKey, tableKey: data.tableKey).0)
            }else{
                 dataent.setCourseTitle(courseTitle: DBTableM.loadClassName(classKey: data.classKey, tableKey: data.tableKey).1)
            }
            
            scheduleData.append(dataent)
        }
    }
    func getData()->[ScheduleListDataEntity]{
        return scheduleData
    }
    
    
    
    

    
    
    
    
}


class ScheduleListDataEntity{
    private var date:String!
    private var courseTitle:String!
    private var scheduleType:String!
    private var memo:String!
    private var id:Int!   //schedule tableのrowId
    
    init(date:String,courseTitle:String,scheduleType:String,memo:String,id:Int) {
        self.date = date
        self.courseTitle = courseTitle
        self.scheduleType = scheduleType
        self.memo = memo
        self.id = id
    }
    init() {
        
    }
    func setDate(date:String){
        self.date=date
    }
    func setCourseTitle(courseTitle:String){
        self.courseTitle = courseTitle
    }
    func setScheduleType(scheduleType:String){
        self.scheduleType = scheduleType
    }
    func setMemo(memo:String){
        self.memo = memo
    }
    func setId(id:Int){
        self.id = id
    }
    
    func getDate()->String{
        return date
    }
    func getCourseTitle()->String{
        return courseTitle
    }
    func getScheduleType()->String{
        return scheduleType
    }
    func getMemo()->String{
        return memo
    }
    func getId()->Int{
        return id
    }
}





























