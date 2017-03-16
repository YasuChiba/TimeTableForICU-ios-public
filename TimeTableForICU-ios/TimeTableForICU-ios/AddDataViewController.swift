//
//  AddDataViewController.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/10/30.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//
import FMDB
import UIKit
import Material
import ActionSheetPicker_3_0
import PopupDialog
import Presentr
import Hue
import TTGSnackbar

protocol AddDataVCDelegate {
    //参考:http://stackoverflow.com/questions/30971675/swift-using-popviewcontroller-and-passing-data-to-the-viewcontroller-youre-re
    func didFinishAddDataVC(controller: AddDataViewController)
}

struct tableTitle {
    var jTitle: String = ""
    var eTitle: String = ""
}

class AddDataViewController: UIViewController,UITextFieldDelegate {
    
    var pickerButton: RaisedButton!
    var schedulePickerButton: RaisedButton!
    var colorChooserButton: UIButton!
    
    var collectionView: UICollectionView!
  
    var courseTitleTF: UITextField!
    var classRoomTF: UITextField!
    var instructorTF: UITextField!
  
    var okButton: UIButton!
    
    var collectionCon : DateCollectionController?
    var lang = Language.jp
    var season="Winter"
    var year = "2016"
    var tableName="testTable"
    var tableKey = 0
    
    var period = 11
    var selectedIndex = 0
    private var numPeriods : [Int]=[]   //これに直接アクセスだめ
    var tableCellColor = "ffffff"
    private var Data:[SyllabusEntity]!
    private var titleArray:[tableTitle]=[]
    
    private var DBm:DatabaseManager!
    private var DBSyllabusM:DataBaseSyllabusManager!
    private var DBTableM:DataBaseTableManager!
    
    var delegate: AddDataVCDelegate! = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        DBm = DatabaseManager()
        DBSyllabusM=DataBaseSyllabusManager(DBm:DBm,season:season,year:year)
        DBTableM=DataBaseTableManager(DBm:DBm,tableKey: tableKey)

      
        collectionCon = DateCollectionController(view : self)
        collectionView.dataSource=collectionCon
        collectionView.delegate=collectionCon
        collectionView.isScrollEnabled=true
        collectionView.showsVerticalScrollIndicator = false
        
        
        self.addPeriodData(data: Int(period))

        
        let firstSyllabusEntity = SyllabusEntity()   //空のデータを先頭に入れる
        Data=DBSyllabusM.loadDataFromSyllabus(periodNot90: period)
        Data.insert(firstSyllabusEntity, at: 0)
        
        for data in Data{
            var tmp = tableTitle()
            tmp.eTitle = data.eTitle
            tmp.jTitle = data.jTitle
            titleArray.append(tmp)
        }
        
        lang = Language.init(lang: UserDefaultManager.loadDefaultLanguage())
       
      
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.pickerButton.addTarget(self, action: #selector(self.pickerButtonTapped), for:.touchUpInside)
        self.schedulePickerButton.addTarget(self, action: #selector(self.schedulePickerTapped), for: .touchUpInside)
        self.okButton.addTarget(self, action: #selector(self.okButtonTapped), for: .touchUpInside)
        self.colorChooserButton.addTarget(self, action: #selector(self.colorChooserTapped), for: .touchUpInside)
        //これらのアクションの登録は、controllerの方でheader/footerからボタンの登録をしてからでないと出来ないので、ここでやる。処理がバラバラに別れてるからわかりにくい・・・

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        // キーボードを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    func getPeriodData()->[Int]{
        return numPeriods
    }
    
    func setPeriodData(data :[Int]){     //numPeriodsのデータを置き換える時
        let notInitList = DBTableM.chackInitializeByPeriod(periodList:data)
        if notInitList.count != 0{
            var body = "Already assigned classes :"
            for tmp in notInitList {
                body = body+" " + DevideScheduleString.devideScheduleNumToInitialArray(scheduleNumArray: tmp)
            }
            body = body + " " + "Do you want to add ?"
            self.showAlertAtAddSetPeriodData(body: body, OkClosure: { ()->() in
                self.numPeriods=data
                self.collectionView.reloadData()
            })
        }else{
            self.numPeriods = data
            self.collectionView.reloadData()
        }
    }
    func addPeriodData(data: Int){     //numPeriodsにappendする時
        let notInitPeriod = DBTableM.chackInitializeByPeriod(periodList:[data])
        if notInitPeriod.count != 0{
            var body = "Already assigned classes :"
            for tmp in notInitPeriod {
                body = body+" " + DevideScheduleString.devideScheduleNumToInitialArray(scheduleNumArray: tmp)
            }
            body = body + " " + "Do you want to add ?"
            self.showAlertAtAddSetPeriodData(body: body, OkClosure: { ()->() in
                self.numPeriods.append(data)
                self.collectionView.reloadData()
            })
        }else{
            numPeriods.append(data)
            self.collectionView.reloadData()
        }
    }
    private func showAlertAtAddSetPeriodData(body:String,OkClosure:@escaping ()->()){
        let controller = Presentr.alertViewController(title: "", body: body)
        let deleteAction = AlertAction(title: "Cancel", style: .destructive) {
            
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
        customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
    }
    
    
    
    
  
    func deleteSchedule(dataSubscript : Int){
        numPeriods.remove(at: dataSubscript)
        collectionView.reloadData()
      
        print("periods : ")
        print(numPeriods)
    }
    
    
    
    
    //Picker系
  
    private func pickerChoosedSyllabus(row:Int){
        print("ROW : \(row)   ")
        selectedIndex = row
        if lang == .jp{
            courseTitleTF.text=Data[row].jTitle
        }else{
            courseTitleTF.text=Data[row].eTitle
        }
        classRoomTF.text=Data[row].room
        instructorTF.text=Data[row].instructor
        
        self.setPeriodData(data: DevideScheduleString.devideScheduleStringToIntArray(schedule_string:Data[row].scheduleString ))
       
        collectionView.reloadData()
        print(Data[row].scheduleString)
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
            if numPeriods.index(of: 40+tmp%10) == nil && numPeriods.index(of: 90+tmp%10) == nil{
                self.addPeriodData(data: tmp)
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let snackbar = TTGSnackbar.init(message: "Already exsists", duration: .short)
                    snackbar.show()
                }
            }
        }else if numPeriods.index(of: tmp) == nil{
            self.addPeriodData(data: tmp)
        }else{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let snackbar = TTGSnackbar.init(message: "Already exsists", duration: .short)
                snackbar.show()
            }
        }
    }
    
    
    
    
    func pickerButtonTapped(){
        print("tapped")
        
        var array:[String]=[]
        if lang == .jp{
            for tmp in titleArray{
                array.append(tmp.jTitle)
            }
        }else if lang == .en{
            for tmp in titleArray{
                array.append(tmp.eTitle)
            }
        }
        
        let pickertext = ActionSheetStringPicker(title:"select",
                                               rows:array,
                                               initialSelection:0,
                                               doneBlock:{(picker, selectedIndex, selectedValue) in
                                                print("hoge")
                                                self.pickerButton.setTitle(array[selectedIndex], for: .normal)
                                                self.pickerChoosedSyllabus(row: selectedIndex)
                                                },   //好きな処理を書く
            cancel:{picker in
                print("hoge")
                            },   //好きな処理を書く
            origin:pickerButton)
        pickertext?.show()    //にゅって出る
    }
    func schedulePickerTapped(){
        print("tapped")
        
        let acp = ActionSheetMultipleStringPicker(title: "", rows: [
            Constants.weekList,
            Constants.periodList
            ], initialSelection: [0, 0], doneBlock: {
                picker, values, indexes in
                let v :[Int]=values as! [Int]
                self.schedulePickerChoosed(rowWeek: v[0],rowPeriod: v[1])
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin:schedulePickerButton)
        acp?.show()
    }
    
    
    
    func colorChooserTapped(){
        let presenter: Presentr = {
            let presenter = Presentr(presentationType: .alert)
            return presenter
        }()
        
        let controller = ColorChooserViewCon()
        controller.setProcessBeforeDismiss(closure:{(colorString:String)->() in
            self.colorChooserButton.backgroundColor = UIColor(hex:colorString)
            self.tableCellColor = colorString
        })
        customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
    }

  
    func okButtonTapped(){
        let tmp=DevideScheduleString.connectScheduleNumArray(scheduleNumArray: numPeriods)
        print(tmp)
        if numPeriods.count != 0{
            //DBTableM=DataBaseTableManager(DBm:DBm,tableKey: tableKey)
            
            var tableData:[TableDataEntity] = []
            for _ in 0..<numPeriods.count{
                let tmp = TableDataEntity()
                tmp.classRoom = classRoomTF.text!
                tmp.color = tableCellColor
                if lang == .jp{
                    tmp.jTitle = courseTitleTF.text!
                    tmp.eTitle = Data[selectedIndex].eTitle
                }else{
                    tmp.eTitle = courseTitleTF.text!
                    tmp.jTitle = Data[selectedIndex].jTitle
                }
                tmp.initialize = TableStatus.tableNotInitialized.rawValue
                if selectedIndex == 0{
                    tmp.rgno = TableStatus.notInitRgno.rawValue
                }else{
                    tmp.rgno = Data[selectedIndex].rgno
                }
                tmp.teacher = instructorTF.text!
                tmp.textColor = "#000000"
                tableData.append(tmp)
            }
            DBTableM.updateTableDataByClassWithCreateNewClass(data: tableData, numPeriods: numPeriods)
            self.navigationController?.popViewController(animated: true)
            delegate.didFinishAddDataVC(controller: self)
        }
    }
  

}
