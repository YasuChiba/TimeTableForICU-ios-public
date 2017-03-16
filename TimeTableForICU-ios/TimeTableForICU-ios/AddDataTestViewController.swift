//
//  AddDataTestViewController.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/02.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import UIKit
import Material
import Presentr
import TTGSnackbar
import ActionSheetPicker_3_0
import Instructions

//cellでtextfiled使うやつの参考　http://an.hatenablog.jp/entry/2015/10/04/015712

/*
 struct tableTitle {
    var jTitle: String = ""
    var eTitle: String = ""
 }
 */

protocol FinishChoosingColorDelegate{
    //参考:http://stackoverflow.com/questions/30971675/swift-using-popviewcontroller-and-passing-data-to-the-viewcontroller-youre-re
    func didFinishChoosing(colorCode:String)
}

class AddDataTestViewController: UIViewController,UITextFieldDelegate,FinishChoosingColorDelegate {
    //このクラスはデータを追加するときとmodifyする時どっちでも使う。　名前はそれに合うように変えよう・・

    @IBOutlet weak var titleTF: TextField!
    @IBOutlet weak var teacherTF: TextField!
    
    @IBOutlet weak var okButton: UIButton!
    
    @IBOutlet weak var syllabusChooseButton: UIButton!
    @IBOutlet weak var scheduleAddIconButton: UIButton!
    
    @IBOutlet weak var colorChooserView: ColorChooserView!
    
    @IBOutlet weak var tableView: UITableView!

    var lang = Language.jp
    var season="Winter"
    var year = "2016"
    var tableName="testTable"
    var tableKey = 0
    
    var period = 11
    var selectedIndex = 0
    private var scheduleDataArray : [AddDataEntity] = []   //これに直接アクセスだめ
    var tableCellColor = "ffffff"
    private var syllabusData:[SyllabusEntity]!
    private var syllabusTitleArray:[tableTitle]=[]
    
    private var DBm:DatabaseManager!
    private var DBSyllabusM:DataBaseSyllabusManager!
    private var DBTableM:DataBaseTableManager!
    private var DBTableListM:DataBaseTableListManager!
    
    var tableViewCon : AddDataTestTableController!
    
    var delegate:backVCdelegate! = nil
    
    var isAddData = true   //addDataかmodifyDataか判断するフラグ
    var classKeyForModifyData = 0
    var colorStringForModifyData = "ffffff"
    var scheduleDataArrayForModifyData:[AddDataEntity] = []    //最初に代入しておいてokButtonが押されたら、消されたperiodを把握するのに使う

    let coachMarksController = CoachMarksController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSettings()
        setUpViews()
        
        if isAddData{
            let firstSyllabusEntity = SyllabusEntity()   //空のデータを先頭に入れる  最初から何かが選択されてるように見えないように
            syllabusData=DBSyllabusM.loadDataFromSyllabus(periodNot90: period)
            syllabusData.insert(firstSyllabusEntity, at: 0)
            
            let tmpData = AddDataEntity()
            tmpData.scheduleNum = Int(period)
            setScheduleData(data: [tmpData])
            
            for data in syllabusData{
                var tmp = tableTitle()
                tmp.eTitle = data.eTitle
                tmp.jTitle = data.jTitle
                syllabusTitleArray.append(tmp)
                print(tmp.jTitle)
            }
        }else{
            let classData = DBTableM.loadTableDataByEachClass(classKey: classKeyForModifyData)
            let syllabusEntity = SyllabusEntity()         //ここでsyllabuのデータを作って入れておかないと、okButtonが押された時の処理が面倒。
            syllabusEntity.eTitle = classData[0].eTitle
            syllabusEntity.jTitle = classData[0].jTitle
            syllabusEntity.rgno = classData[0].rgno
            selectedIndex = 0
            syllabusData = [syllabusEntity]
            
            teacherTF.text = classData[0].teacher
            if lang == .jp{
                titleTF.text = classData[0].jTitle
            }else{
                titleTF.text = classData[0].eTitle
            }
            colorStringForModifyData = classData[0].color
            syllabusChooseButton.isEnabled = false
            syllabusChooseButton.isHidden = true
            
            
            tableView.reloadData()
            
        }

    }
    override func viewWillLayoutSubviews() {
       
        if !isAddData{
            titleTF.snp.updateConstraints{(make)->Void in
                make.top.equalToSuperview().offset(40)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        
        if !isAddData{
            colorChooserView.setChoosedColor(colorString:colorStringForModifyData)
            colorChooserView.layoutIfNeeded()
            GAUtility.sendScreenTracking(screenName: .modifyData)

        }else{
            GAUtility.sendScreenTracking(screenName: .addData)
        }
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaultManager.loadIsAddDataFirstShow(){
            coachMarksController.dataSource = self
            coachMarksController.startOn(self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        coachMarksController.stop(immediately: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    internal func didFinishChoosing(colorCode: String) {
        tableCellColor = colorCode
    }

    
    private func initSettings(){
        DBm = DatabaseManager()
        DBTableListM = DataBaseTableListManager(DBm:DBm)
        let tableData = DBTableListM.loadOneData(tableKey: tableKey)
        season = tableData.tableSeason.rawValue
        year = String(tableData.tableYear)
        DBSyllabusM=DataBaseSyllabusManager(DBm:DBm,season:season,year:year)
        DBTableM=DataBaseTableManager(DBm:DBm,tableKey: tableKey)
        
        
        tableViewCon = AddDataTestTableController(viewCon:self)
        tableView.dataSource = tableViewCon
        tableView.delegate = tableViewCon
        
        lang = Language.init(lang: UserDefaultManager.loadDefaultLanguage())
        
               

    }
    
    private func setUpViews(){
        
        //TextFields
        titleTF.placeholder = "Course Title"
        titleTF.isClearIconButtonEnabled = true
        titleTF.font = UIFont.boldSystemFont(ofSize: 18.0)
        titleTF.delegate = self
        

        teacherTF.placeholder = "Instructor Name"
        teacherTF.isClearIconButtonEnabled = true
        teacherTF.delegate = self
        let leftView = UIImageView()
        leftView.image = Icon.add
        //teacherTF.leftView = leftView
      //  teacherTF.leftViewMode = .always
        
              
        //Others
        scheduleAddIconButton.setImage(Icon.add, for: .normal)
        scheduleAddIconButton.setTitle("", for: .normal)
        scheduleAddIconButton.addTarget(self, action: #selector(self.schedulePickerTapped), for: .touchUpInside)
        
        syllabusChooseButton.addTarget(self, action: #selector(self.syllabusPickerButtonTapped), for: .touchUpInside)
        okButton.addTarget(self, action: #selector(self.okButtonTapped), for: .touchUpInside)
        
        colorChooserView.delegate = self
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    //Mark: データを扱う系
    
    func getScheduleData()->[AddDataEntity]{
        return scheduleDataArray
    }
    
    func setScheduleData(data :[AddDataEntity]){     //scheduleDataArrayのデータを置き換える時
        var periodsData:[Int]=[]
        for tmp in data{
            periodsData.append(tmp.scheduleNum)
        }
        let notInitList = DBTableM.chackInitializeByPeriod(periodList:periodsData)
        if notInitList.count != 0{
            var body = "Already assigned classes :"
            for tmp in notInitList {
                body = body+" " + DevideScheduleString.devideScheduleNumToInitialArray(scheduleNumArray: tmp)
            }
            body = body + " " + "Do you want to add ?"
            self.showAlertAtAddSetPeriodData(body: body, OkClosure: { ()->() in
                self.scheduleDataArray = data
                self.tableView.reloadData()
            })
        }else{
            self.scheduleDataArray = data
            self.tableView.reloadData()
        }
    }
    func addScheduleData(data: AddDataEntity){     //scheduleDataArrayにappendする時
        let notInitPeriod = DBTableM.chackInitializeByPeriod(periodList:[data.scheduleNum])
        if notInitPeriod.count != 0{
            var body = "Already assigned classes :"
            for tmp in notInitPeriod {
                body = body+" " + DevideScheduleString.devideScheduleNumToInitialArray(scheduleNumArray: tmp)
            }
            body = body + " " + "Do you want to add ?"
            self.showAlertAtAddSetPeriodData(body: body, OkClosure: { ()->() in
                self.scheduleDataArray.append(data)
                self.tableView.reloadData()
            })
        }else{
            scheduleDataArray.append(data)
            self.tableView.reloadData()
        }
    }
    
    func editPeriodClassRoomData(index:Int,classRoomText:String){
        scheduleDataArray[index].classRoom = classRoomText
    }
    private func showAlertAtAddSetPeriodData(body:String,OkClosure:@escaping ()->()){
        let controller = Presentr.alertViewController(title: "", body: body)
        let deleteAction = AlertAction(title: "Cancel", style: .cancel) {
            
        }
        let okAction = AlertAction(title: "Ok", style: .cancel){
            OkClosure()
        }
        controller.addAction(deleteAction)
        controller.addAction(okAction)
        
        let presenter: Presentr = {
            let presenter = Presentr(presentationType: .alert)
            return presenter
        }()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
            
        }
        
    }
    
    func deleteScheduleData(index : IndexPath){
        scheduleDataArray.remove(at: index.row)
        tableView.deleteRows(at: [index], with: UITableViewRowAnimation.right)
    }
    
    
    func setScheduleDataForFirstTimeModifyData(data :[AddDataEntity]){
        self.scheduleDataArray = data
        self.scheduleDataArrayForModifyData = data
    }
    
    
    
    //Picker系
    
    private func syllabusPickerChoosedSyllabus(row:Int){
        print("ROW : \(row)   ")
        selectedIndex = row
        if lang == .jp{
            titleTF.text=syllabusData[row].jTitle
        }else{
            titleTF.text=syllabusData[row].eTitle
        }
        
        teacherTF.text=syllabusData[row].instructor
        
        let schedulList = DevideScheduleString.devideScheduleStringToIntArray(schedule_string: syllabusData[row].scheduleString)
        var dataList:[AddDataEntity] = []
        for i in 0..<schedulList.count{
            dataList.append(AddDataEntity(schedulList[i],classRoom: syllabusData[row].room))
        }
        self.setScheduleData(data: dataList)

    }
    
    private func schedulePickerChoosed(rowWeek:Int,rowPeriod:Int){
        print(rowWeek)
        print(rowPeriod)
        var tmp = 0
        if rowPeriod == 4{
            tmp = 9*10+rowWeek+1
        }else if rowPeriod < 4{
            tmp = (rowPeriod+1)*10+rowWeek+1
        }else{
            tmp = (rowPeriod)*10+rowWeek+1
        }
        print("tmp :\(tmp)")
        if (tmp/10 == 4)||(tmp/10 == 9){     //numPeriodsにすでにあるかどうかの判定。絶対もっとシンプルに出来る　めんどい・・・
            
            if !scheduleDataArray.contains(AddDataEntity(40+tmp%10)) && !scheduleDataArray.contains(AddDataEntity(90+tmp%10)){
                self.addScheduleData(data: AddDataEntity(tmp))
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let snackbar = TTGSnackbar.init(message: "Already exsists", duration: .middle)
                    snackbar.show()
                }
            }
        }else if scheduleDataArray.contains(AddDataEntity(tmp)) == false{
            self.addScheduleData(data: AddDataEntity(tmp))
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let snackbar = TTGSnackbar.init(message: "Already exsists", duration: .middle)
                snackbar.show()
               
            }
        }
    }
    
    
    
    
    func syllabusPickerButtonTapped(){
        var array:[String]=[]
        if lang == .jp{
            for tmp in syllabusTitleArray{
                array.append(tmp.jTitle)
            }
        }else if lang == .en{
            for tmp in syllabusTitleArray{
                array.append(tmp.eTitle)
            }
        }
        
        let pickertext = ActionSheetStringPicker(title:"select",
                                                 rows:array,
                                                 initialSelection:0,
                                                 doneBlock:{(picker, selectedIndex, selectedValue) in
                                                    self.syllabusChooseButton.setTitle(array[selectedIndex], for: .normal)
                                                    self.syllabusPickerChoosedSyllabus(row: selectedIndex)
        },   //好きな処理を書く
            cancel:{picker in

        },   //好きな処理を書く
            origin:syllabusChooseButton)
        pickertext?.show()    //にゅって出る
    }
    func schedulePickerTapped(){
        let acp = ActionSheetMultipleStringPicker(title: "", rows: [
            Constants.weekList,
            Constants.periodList
            ], initialSelection: [0, 0], doneBlock: {
                picker, values, indexes in
                let v :[Int]=values as! [Int]
                self.schedulePickerChoosed(rowWeek: v[0],rowPeriod: v[1])
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin:scheduleAddIconButton)
        acp?.show()
    }
    
    

    
    
    
    
    func okButtonTapped(){
        var numPeriods:[Int] = []
        for tmp in getScheduleData(){
            numPeriods.append(tmp.scheduleNum)
            print("okButton tapped  schedule num = \(tmp.scheduleNum)")
        }
        let tmp=DevideScheduleString.connectScheduleNumArray(scheduleNumArray: numPeriods)
        print(tmp)
        if numPeriods.count != 0{
            
            var tableData:[TableDataEntity] = []
            for i in 0..<numPeriods.count{
                let tmp = TableDataEntity()
                tmp.classRoom = getScheduleData()[i].classRoom
                tmp.color = tableCellColor
                if lang == .jp{
                    tmp.jTitle = titleTF.text!
                    tmp.eTitle = syllabusData[selectedIndex].eTitle
                }else{
                    tmp.eTitle = titleTF.text!
                    tmp.jTitle = syllabusData[selectedIndex].jTitle
                }
                tmp.initialize = TableStatus.tableNotInitialized.rawValue
                if selectedIndex == 0 && isAddData{
                    tmp.rgno = TableStatus.notInitRgno.rawValue
                }else{
                    tmp.rgno = syllabusData[selectedIndex].rgno
                }
                tmp.teacher = teacherTF.text!
                tmp.textColor = "#000000"
                tableData.append(tmp)
            }
            if isAddData{
                DBTableM.updateTableDataByClassWithCreateNewClass(data: tableData, numPeriods: numPeriods)
                let sendingData = "year : \(year) , season : \(season) , rgno : \(tableData[0].rgno) , bgColor : \(tableData[0].color)"
                GAUtility.sendEventTracking(category:.classInfo, action: .addedClassInfo,label:sendingData)

            }else{
                DBTableM.initializeTableByPeriodList(periodNums:checkDeletedPeriod())
                DBTableM.updateTableDataByClassWithOverrideCurrentClass(data:tableData,numPeriods:numPeriods,classKey:classKeyForModifyData)
            }
            delegate.didFinishProcesses()

            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    private func checkDeletedPeriod()->[Int]{    //クラスの時間割から消された時間を抽出。
        var deletedPeriodNum:[Int] = []
        var numPeriods:[Int] = []
        for tmp in getScheduleData(){
            numPeriods.append(tmp.scheduleNum)
        }
        for tmp in scheduleDataArrayForModifyData{
            if !numPeriods.contains(tmp.scheduleNum){
                deletedPeriodNum.append(tmp.scheduleNum)
            }
        }
        return deletedPeriodNum
    }
  
    
    
    
    
    
}
