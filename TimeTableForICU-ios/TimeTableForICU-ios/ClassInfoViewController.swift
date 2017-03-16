//
//  ClassInfoViewController.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/12/05.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import Foundation
import UIKit
import Presentr
import DropDown

//http://qiita.com/mishimay/items/754dec7ffe5f202b780c    可変のscrollview　の参考

class ClassInfoViewController: UIViewController,ClassInfoAddScheduleViewDelegate,ClassInfoAddDataViewDelegate,backVCdelegate{
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var scheduleStringLabel: UILabel!
    
    @IBOutlet weak var barButton: UIBarButtonItem!
    
    var tableController:ClassInfoTableController!
    var dropDown:DropDown!
    var delegate : backVCdelegate!
    var period=11
    var tableName="testTable"
    var tableKey = 0
    var classKey = 0
    var lang = Language.jp

    var DBm:DatabaseManager!
    var DBTableM:DataBaseTableManager!
    var DBDataTableM:DataBaseDataTableManager!
    var DBScheduleTableM:DataBaseScheduleTableManager!
    
    var DataList:[DataTableDataListByDate] = []           //Memoの方
    var ScheduleDataList:[ScheduleDataEntity] = []          //Scheduleの方
  //  var DBMySyllabusM:DataBaseMySyllabusManager!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSettings()
        setInitDatas()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(_ animated: Bool) {
       delegate.didFinishProcesses()
    }
    
    private func initSettings(){
        DBm=DatabaseManager()
        DBTableM=DataBaseTableManager(DBm: DBm,tableKey: tableKey)
        DBDataTableM = DataBaseDataTableManager(DBm:DBm)
        DBScheduleTableM = DataBaseScheduleTableManager(DBm:DBm)
        
        tableController = ClassInfoTableController(view:self)
        tableView.delegate = tableController
        tableView.dataSource = tableController
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //headerにカスタムビュー使う準備　参考　http://qiita.com/KikurageChan/items/e1847b54535df393d893
        let xib = UINib(nibName: "ClassInfoTableHeaderView", bundle: nil)
        tableView.register(xib, forHeaderFooterViewReuseIdentifier: "ClassInfoTableHeaderView")
        
        
        courseTitleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)

        lang = Language.init(lang: UserDefaultManager.loadDefaultLanguage())
        
        courseTitleLabel.adjustsFontSizeToFitWidth = true
        scheduleStringLabel.lineBreakMode = .byWordWrapping

        
        //barButtonの設定
        barButton.target = self
        barButton.action = #selector(self.barButtonTapped(sender:))
   
        dropDown = DropDown()
        dropDown.anchorView = barButton
        dropDown.dataSource = ["Modify", "Delete"]
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            switch index{
            case 0:
                self.barButtonModifyTapped()
            case 1:
                self.barButtonDeleteTapped()
            default:
                break
            }
        }

        
        
        
    }
    private func setInitDatas(){
        let tableData=DBTableM.loadTableData(id: period)
        
        
        classKey = tableData.classKey
        
        if lang == .en{
            courseTitleLabel.text = tableData.eTitle
        }else{
            courseTitleLabel.text = tableData.jTitle
        }

        teacherLabel.text = tableData.teacher
        scheduleStringLabel.text = DevideScheduleString.scheduleNumArrayToInitialStringWithSort(scheduleNumArray: DBTableM.loadPeriodDataByEachClass(classKey: classKey))
        
        
        loadDatas()
        
    }
    func loadDatas(){
        loadDataData()
        loadScheduleData()
    }
    func loadDataData(){
        DataList = DBDataTableM.loadDataWithSortByAddedDate(classKey: classKey)
    }
    func loadScheduleData(){
        ScheduleDataList = DBScheduleTableM.loadDataWithSortByDueDate(classKey: classKey)
    }
    
    
    
    //データを扱う系
    
    
    func getDataData()->[DataTableDataListByDate]{   //Memoの方
        
        return DataList
    }
    func getScheduleData()->[ScheduleDataEntity]{
        return ScheduleDataList
    }
 
    
    func deleteDataData(index: IndexPath){     //Memoの方
        for tmp in DataList[index.row].getPhotoData(){
            self.deleteImage(identifier: tmp.data)
        }
        
        let date = DataList[index.row].getDate()
        _ = DBDataTableM.deleteDataByDate(date: date,classKey: classKey)
        DataList.remove(at: index.row)
        tableView.deleteRows(at: [index], with: .right)
    }
    
    func deleteScheduleData(index:IndexPath){
        let data = ScheduleDataList[index.row]
        _ = DBScheduleTableM.deleteDataByRowId(rowId: data.id)
        ScheduleDataList.remove(at: index.row)
        tableView.deleteRows(at: [index], with: UITableViewRowAnimation.right)
    }
    
    /*
    func addDataData(data:String,typeOfData:DataTableType){//一時的にtableViewにデータを表示するために配列にappendするメソッド。コレ以外にもDataBaseに登録する処理が必要

        let index = DataList.index(where: {tmp in
            let val = CustomDateFormatter.dateToString(date: tmp.getDate()) == CustomDateFormatter.dateToString(date: Date())
            return val
        })
        if index == nil{
            var dataList = DataTableDataListByDate(date:Date())
            let d = DataTableEntity(classKey:classKey,tableKey:tableKey,typeOfData:typeOfData,addedDate:Date(),data:data)
            dataList.setData(data: d)
            DataList.append(dataList)
            
        }else{
            let d = DataTableEntity(classKey:classKey,tableKey:tableKey,typeOfData:typeOfData,addedDate:Date(),data:data)
            DataList[index!].setData(data: d)
        }
    }
 */
    
    func showAddScheduleView(){
     //   let customType = PresentationType.custom(width: .default, height:.custom(size: 230), center: .center)
        let presenter: Presentr = {
            let presenter = Presentr(presentationType: .popup)
            return presenter
        }()
        presenter.keyboardTranslationType = .compress
        let controller = ClassInfoAddScheduleViewController()
       controller.delegate = self
        
        customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
    
    }
    func showAddDataView(){
        let presenter: Presentr = {
            let presenter = Presentr(presentationType: .popup)
            return presenter
        }()
        presenter.keyboardTranslationType = .compress
        let controller = ClassInfoAddDataViewController()
       
        controller.delegate = self
       
        customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)

    }
    
    //AddScheduleView の　delegate
    func addScheduleViewDidTappedOKButton(memo: String, dueDate: Date, scheduleType: ScheduleTableType) {
        
        DBScheduleTableM.setData(classKey: classKey, tableKey: tableKey, type: scheduleType, dueDate: dueDate, memo: memo, isDone: .notDone)
        
        
        ScheduleDataList = DBScheduleTableM.loadDataWithSortByDueDate(classKey: classKey)  //これどうだろう　処理を重くしてそう
        tableView.reloadData()
        
        
    }
    //ADdDataViewのdelegate
    func addDataViewDidTappedOKButton(memo: String, addedDate: Date) {
        
        DBDataTableM.setData(classKey: classKey, tableKey: tableKey, type: .memo, addedDate: addedDate, data: memo)
        
        DataList = DBDataTableM.loadDataWithSortByAddedDate(classKey: classKey)

        tableView.reloadData()
        
    }
    
    //barBUttonのアクション達
    func barButtonTapped(sender:UIBarButtonItem){
        dropDown.show()
    }
    func barButtonModifyTapped(){
        print("modify tapped")
        let storyboard = UIStoryboard(name: "AddDataTestViewController", bundle: nil)
        let nextVC :AddDataTestViewController = storyboard.instantiateViewController(withIdentifier: "AddDataTestViewController") as! AddDataTestViewController
        
        nextVC.isAddData = false
        nextVC.period=11
        nextVC.tableKey = tableKey
        nextVC.delegate = self
        nextVC.classKeyForModifyData = classKey
        
        let classData = DBTableM.loadTableDataByEachClass(classKey: classKey)
        var dataList:[AddDataEntity] = []
        for tmp in classData{
            dataList.append(AddDataEntity(tmp.period,classRoom: tmp.classRoom))
        }
        dataList.sort(by: {(obj1,obj2)->Bool in
            let this = obj1.scheduleNum
            let that = obj2.scheduleNum
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
        nextVC.setScheduleDataForFirstTimeModifyData(data: dataList)
        
        
        navigationController?.pushViewController(nextVC, animated: true)
        
    }
    func barButtonDeleteTapped(){
        print("delete tapped")
        let title = "All data will be deleted."
        let body = "Are you sure?"
        
        let controller = Presentr.alertViewController(title: title, body: body)
        
        let deleteAction = AlertAction(title: "OK", style: .destructive) {
            self.DBTableM.initializeTableOneClassWithDeleteScheduleAndDataData(classKey: self.classKey)
            self.delegate.didFinishProcesses()
            self.navigationController?.popViewController(animated: true)
        }
        let okAction = AlertAction(title: "Cancel", style: .cancel){
        }
        
        controller.addAction(deleteAction)
        controller.addAction(okAction)
        
        let presenter: Presentr = {
            let presenter = Presentr(presentationType: .alert)
            return presenter
        }()
        presenter.presentationType = .alert
        customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
     
        
        
    }
    
    func didFinishProcesses(){
        delegate.didFinishProcesses()
        self.setInitDatas()
    }

    
    /*
    func testButtonTapped(){
        print("tapped")
        let date = Date()
        
        DBDataTableM.setData(classKey: classKey, tableKey: tableKey, type: .memo, addedDate: date, data: "test data")
        
        DBScheduleTableM.setData(classKey: classKey, tableKey: tableKey, type: .assignment, dueDate: date, memo: "testMemo", isDone: .notDone)
        
    }*/
}
