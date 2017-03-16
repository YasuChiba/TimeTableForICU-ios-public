//
//  TableSettingsViewController.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/12/31.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import UIKit
import Presentr
import ActionSheetPicker_3_0

protocol TableSettingsVCDelegate {
    //参考:http://stackoverflow.com/questions/30971675/swift-using-popviewcontroller-and-passing-data-to-the-viewcontroller-youre-re
    func didFinishTableSettingsVC(controller: TableSettingsViewController)
    func titleChanged(tableName:String)
}

class TableSettingsViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableAddButton: UIButton!
    @IBOutlet weak var satSwitch: UISwitch!
    @IBOutlet weak var period8Switch: UISwitch!
    @IBOutlet weak var syllabusLangSegment: UISegmentedControl!
    @IBOutlet weak var fontSizeButton: UIButton!
    
    
    var tableviewCon:TableSettingsTableController!
    
    var tableListDataArray = [TableListDataEntity]()
    var DBm:DatabaseManager!
    var DBTableListM:DataBaseTableListManager!
    var delegate: TableSettingsVCDelegate! = nil
    
    var fontSize = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableviewCon = TableSettingsTableController(view:self)
        tableView.dataSource = tableviewCon
        tableView.delegate = tableviewCon
        
        
        DBm = DatabaseManager()
        DBTableListM = DataBaseTableListManager(DBm:DBm)
        loadTableListData()
    
        
        
        //スイッチ等の初期化
        let sat = UserDefaultManager.loadIsEnableSaturday()
        satSwitch.setOn(sat, animated: true)
        let period8 = UserDefaultManager.loadIsEnable8Period()
        period8Switch.setOn(period8, animated: true)
        syllabusLangSegment.selectedSegmentIndex = UserDefaultManager.loadDefaultLanguage()
        fontSize = UserDefaultManager.loadFontSize()
        fontSizeButton.setTitle(String(fontSize), for: .normal)
        
        satSwitch.tag = 0
        period8Switch.tag = 1

        satSwitch.addTarget(self, action: #selector(settingsSwithChanged(sender:)), for: UIControlEvents.valueChanged)
        period8Switch.addTarget(self, action: #selector(settingsSwithChanged(sender:)), for: .valueChanged)
        syllabusLangSegment.addTarget(self, action: #selector(settingsSegmentChanged(sender:)), for: .valueChanged)
        
        fontSizeButton.addTarget(self, action: #selector(self.fontSizePickerTapped), for: .touchUpInside)
        
        tableAddButton.addTarget(self, action: #selector(self.settingsAddTable(sender:)), for: .touchUpInside)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        delegate.didFinishTableSettingsVC(controller: self)
    }
    
    
    
    func loadTableListData(){
        tableListDataArray = DBTableListM.loadAllData()
        tableView.reloadData()
    }
    
    func setCurrentTable(tableKey:Int,tableName:String){
        UserDefaultManager.saveCurrentTableKey(tableKey: tableKey)
        delegate.titleChanged(tableName: tableName)
    }
    
    
    func getData()->[TableListDataEntity]{
        return tableListDataArray
    }
    func setData(data :[TableListDataEntity]){
        self.tableListDataArray=data
    }
    
    func deleteData(dataIndex : IndexPath){
        DBTableListM.deletFromTableListWithDropTable(tableKey: tableListDataArray[dataIndex.row].tableKey)
        
        let currentKey = UserDefaultManager.loadCurrentTableKey()
        let deletingKey = tableListDataArray[dataIndex.row].tableKey
        
        tableListDataArray.remove(at: dataIndex.row)
        if currentKey == deletingKey{
            setCurrentTable(tableKey: (tableListDataArray.last?.tableKey)!,tableName:(tableListDataArray.last?.tableName)!)
        }
        tableView.deleteRows(at: [dataIndex], with: UITableViewRowAnimation.right)
        
    }
    
    
    
    
    
    //switch  button  Functions
    
    

    func settingsSwithChanged(sender:UISwitch){
        print("switch changed")
        
        switch sender.tag {
        case 0:
            UserDefaultManager.saveIsEnableSaturday(sender.isOn)
        case 1:
            UserDefaultManager.saveIsEnable8Period(sender.isOn)
        default:
            break
        }
        
      
    }
    func settingsSegmentChanged(sender:UISegmentedControl){

        switch sender.selectedSegmentIndex {
        case 0:
            UserDefaultManager.saveDefaultLanguage(lang: 0)
        case 1:
            UserDefaultManager.saveDefaultLanguage(lang: 1)
        default:
            break
        }
        
    }
    
    func settingsAddTable(sender : UIButton){
        let customType = PresentationType.custom(width: .default, height:.custom(size: 230), center: .center)
        let presenter: Presentr = {
            let presenter = Presentr(presentationType: customType)
            presenter.keyboardTranslationType = .none
            return presenter
        }()
        
        let controller = CreateNewTableViewController()
        
        controller.setProcessBeforeDismiss(closure:{(currentTableKey:Int,tableName:String)->() in
            self.setCurrentTable(tableKey: currentTableKey,tableName:tableName)
            self.loadTableListData()
        })
        
        customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
    }
    
    
    func fontSizePickerTapped(){
        let pickertext = ActionSheetStringPicker(title:"select",
                                                 rows:[5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20],
                                                 initialSelection:fontSize-5,
                                                 doneBlock:{(picker, selectedIndex, selectedValue) in
                                                    self.fontSizeButton.setTitle(String(describing: selectedValue!), for: .normal)
                                                    UserDefaultManager.saveFontSize(selectedValue as! Int)

                                                    
        },   //好きな処理を書く
            cancel:{picker in
                
        },   //好きな処理を書く
            origin:fontSizeButton)
        
        pickertext?.show()    //にゅって出る

    }



}
