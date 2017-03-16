//
//  CreateNewTableViewController.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/12/31.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0


class CreateNewTableViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var seasonButton: UIButton!
    @IBOutlet weak var yearButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    
    
    private var selectedYear = 2017
    private var selectedSeason = TableSeason.spring
    
    private var closure = {(currentTableKey:Int,tableName:String)->() in}

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.seasonButton.addTarget(self, action: #selector(self.seasonPickerButtonTapped), for:.touchUpInside)
        self.yearButton.addTarget(self, action: #selector(self.yearPickerButtonTapped), for:.touchUpInside)
   
        self.okButton.addTarget(self, action: #selector(self.okButtonTapped), for: .touchUpInside)
        
        self.seasonButton.setTitle(Constants.seasonArray[0], for: .normal)
        self.yearButton.setTitle(Constants.yearArray[0], for: .normal)
        
        self.nameTF.delegate = self
        
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
    
    
    func setProcessBeforeDismiss(closure:@escaping (Int,String)->())->Void{
        self.closure = closure
    }

    
    
    //Chooser系
    
    private func seasonChoosed(selectedIndex:Int){
        selectedSeason = TableSeason.init(season: Constants.seasonArray[selectedIndex])
        seasonButton.setTitle(Constants.seasonArray[selectedIndex], for: .normal)

    }
    private func yearChoosed(selectedIndex:Int){
        selectedYear = Int(Constants.yearArray[selectedIndex])!
        yearButton.setTitle(Constants.yearArray[selectedIndex], for: .normal)
        
        print(selectedYear)
    }
    
    
    func seasonPickerButtonTapped(){
        let pickertext = ActionSheetStringPicker(title:"select",
                                                 rows:Constants.seasonArray,
                                                 initialSelection:0,
                                                 doneBlock:{(picker, selectedIndex, selectedValue) in
                                                    self.seasonChoosed(selectedIndex: selectedIndex)
                                                    
        },   //好きな処理を書く
            cancel:{picker in
        },   //好きな処理を書く
            origin:seasonButton)
        pickertext?.show()    //にゅって出る
    }
    func yearPickerButtonTapped(){
        let pickertext = ActionSheetStringPicker(title:"select",
                                                 rows:Constants.yearArray,
                                                 initialSelection:0,
                                                 doneBlock:{(picker, selectedIndex, selectedValue) in
                                                    self.yearChoosed(selectedIndex: selectedIndex)
        },   //好きな処理を書く
            cancel:{picker in
                print("hoge")
        },   //好きな処理を書く
            origin:yearButton)
        pickertext?.show()    //にゅって出る
    }

    func okButtonTapped(){
        let DBm=DatabaseManager()
        let DBTableListM = DataBaseTableListManager(DBm: DBm)
        
        let tableName = nameTF.text
        let currentTableKey = DBTableListM.insertToTableListWithCreateNewTable(tableName: tableName!, tableYear: selectedYear, tableSeason: selectedSeason)
        
        self.closure(currentTableKey,tableName!)
        self.dismiss(animated: true, completion: nil)
        
    }
}
