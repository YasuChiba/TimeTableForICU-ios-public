//
//  ViewController.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/10/30.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import UIKit
import Material
import SlideMenuControllerSwift
import Presentr
import Instructions

protocol backVCdelegate {
    //参考:http://stackoverflow.com/questions/30971675/swift-using-popviewcontroller-and-passing-data-to-the-viewcontroller-youre-re
    func didFinishProcesses()
  
}

class ViewController: UIViewController ,AddDataVCDelegate,TableSettingsVCDelegate,backVCdelegate{
    @IBOutlet weak var MarginLabel: UILabel!
    @IBOutlet weak var periodView: PeriodView!
    @IBOutlet weak var customTableView: CustomTableView!
    
    @IBOutlet weak var columnM: TableColumnView!
    @IBOutlet weak var columnTue: TableColumnView!
    @IBOutlet weak var columnWed: TableColumnView!
    @IBOutlet weak var columnThu: TableColumnView!
    @IBOutlet weak var columnFri: TableColumnView!
    @IBOutlet weak var columnSat: TableColumnView!
    var weekColumn:[TableColumnView]!
    
    @IBOutlet weak var satWeek: UILabel!
    
    @IBOutlet weak var barButton: UIBarButtonItem!
    
    
    var i=0
    var p=0
    var DBm:DatabaseManager!
    var DBTableM:DataBaseTableManager!
    var DBTableListM:DataBaseTableListManager!
    var tableName = "testTable"
    var currentTableKey = 1
    
    let coachMarksController = CoachMarksController()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DBm=DatabaseManager()
        DBTableListM = DataBaseTableListManager(DBm: DBm)

        self.addLeftBarButtonWithImage(Icon.menu!)
        
        barButton.target = self
        barButton.action = #selector(self.barButtonTouched(sender:))

        if UserDefaultManager.loadIsFirstLaunch(){
            
            //keyの初期化　いらないっちゃいらない
            UserDefaultManager.saveDefaultLanguage(lang: Language.jp.rawValue)
            UserDefaultManager.saveIsEnable8Period(false)
            UserDefaultManager.saveIsEnableSaturday(false)
            UserDefaultManager.saveFontSize(10)
            
            self.addInitialTable(closure:{(currentTableKey:Int,tableName:String)->() in
                UserDefaultManager.saveCurrentTableKey(tableKey: currentTableKey)
                UserDefaultManager.saveIsFinishInitialSettings(finish: true)
                self.loadTableData()
                self.coachMarksController.dataSource = self
                self.coachMarksController.startOn(self)
            })

        }

    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool){
        
        GAUtility.sendScreenTracking(screenName: .mainTable)
        
    }
    
    override func viewDidLayoutSubviews() {
        
        if UserDefaultManager.loadIsFinishInitialSettings(){
            loadTableData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.coachMarksController.stop(immediately: true)
    }
    
    func didFinishAddDataVC(controller: AddDataViewController) {    //addDataから戻ってきたときにやる処理
        loadTableData()                                         //addDataつかってないから使ってないんじゃね？？？
        self.view.setNeedsLayout()
        print("addData finished")
    }
    
    
    //TableSettingsVCDelegate　の実装
    func didFinishTableSettingsVC(controller : TableSettingsViewController){
        loadTableData()
        print("finish tableSettings")
    }
    func titleChanged(tableName: String) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: tableName, style: .plain, target: nil, action: nil)
    }
    
    //backVCDelegate Protocolの実装
    func didFinishProcesses(){
        loadTableData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    
    func loadTableData(){
        currentTableKey = UserDefaultManager.loadCurrentTableKey()
        let fontSize = UserDefaultManager.loadFontSize()
        DBTableM=DataBaseTableManager(DBm: DBm,tableKey : currentTableKey)
        
        self.title = DBTableListM.loadOneData(tableKey: UserDefaultManager.loadCurrentTableKey()).tableName
        
        
        let is8period = UserDefaultManager.loadIsEnable8Period()
        let isSat = UserDefaultManager.loadIsEnableSaturday()
        
        print("8peiod  :\(is8period)")
        weekColumn=[columnM,columnTue,columnWed,columnThu,columnFri,columnSat]
        for tmp in weekColumn{
            tmp.showPeriod8(show: is8period)
            tmp.l4Available(l4: false)
            tmp.setNeedsLayout()
        }
        periodView.showPeriod8(show:is8period)
        var columnNum = 1
        for column in weekColumn{
            let tableDataArray = DBTableM.loadTableDataByEachColumn(week:columnWeek(rawValue : columnNum)!)
            column.week = columnWeek(rawValue : columnNum)!
            column.setData(tableData: tableDataArray,viewCon: self,fontSize:fontSize)
            columnNum+=1
        }
        
        if !isSat{
            columnSat.isHidden = true
            satWeek.isHidden = true
        }else{
            columnSat.isHidden = false
            satWeek.isHidden = false
        }
    }
    
    func tableButtonTouched(sender : UIButton){
        let tableData=DBTableM.loadTableData(id: sender.tag)
        
        if tableData.initialize == TableStatus.tableInitialized.rawValue{
            /*
            let storyboard = UIStoryboard(name: "AddDataViewController", bundle: nil)
            let nextVC :AddDataViewController = storyboard.instantiateViewController(withIdentifier: "AddDataViewController") as! AddDataViewController
            nextVC.period=sender.tag
            nextVC.tableKey = self.currentTableKey
            nextVC.delegate = self
            navigationController?.pushViewController(nextVC, animated: true)
            */
            let storyboard = UIStoryboard(name: "AddDataTestViewController", bundle: nil)
            let nextVC :AddDataTestViewController = storyboard.instantiateViewController(withIdentifier: "AddDataTestViewController") as! AddDataTestViewController
            
            nextVC.period=sender.tag
            nextVC.tableKey = self.currentTableKey
            nextVC.delegate = self
            navigationController?.pushViewController(nextVC, animated: true)
           
            
        }else{
            let storyboard = UIStoryboard(name: "ClassInfoViewController", bundle: nil)
            let nextVC :ClassInfoViewController = storyboard.instantiateViewController(withIdentifier: "ClassInfoViewController") as! ClassInfoViewController
            nextVC.period=sender.tag
            nextVC.tableKey = self.currentTableKey
            nextVC.delegate = self
            navigationController?.pushViewController(nextVC, animated: true)
            
           
            
        }

    }
    
    //右上のボタン　barbuttonの処理
    func barButtonTouched(sender : UIBarButtonItem){
        let storyboard = UIStoryboard(name: "TableSettingsViewController", bundle: nil)
        let nextVC :TableSettingsViewController = storyboard.instantiateViewController(withIdentifier: "TableSettingsViewController") as! TableSettingsViewController
        nextVC.delegate = self
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    func addInitialTable(closure:@escaping (Int,String)->() ){
        let customType = PresentationType.custom(width: .default, height:.custom(size: 230), center: .center)
        let presenter: Presentr = {
            let presenter = Presentr(presentationType: customType)
            presenter.keyboardTranslationType = .none
            presenter.dismissOnTap = false
            return presenter
        }()
        
        let controller = CreateNewTableViewController()
        
        controller.setProcessBeforeDismiss(closure:{(currentTableKey:Int,tableName:String)->() in
           closure(currentTableKey,tableName)
        })
        
        customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
    }
    
    
}


