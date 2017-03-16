//
//  ClassInfoAddScheduleViewController.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/04.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

protocol ClassInfoAddScheduleViewDelegate{
    func addScheduleViewDidTappedOKButton(memo:String,dueDate:Date,scheduleType:ScheduleTableType)
}
class ClassInfoAddScheduleViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var duePickerButton: UIButton!
    @IBOutlet weak var typePickerButton: UIButton!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var okButton: UIButton!
    
    var delegate:ClassInfoAddScheduleViewDelegate! = nil
    
    var scheduleType:ScheduleTableType = .assignment
    var dueDate:Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        duePickerButton.tag = 0
        typePickerButton.tag = 1
        
        duePickerButton.addTarget(self, action: #selector(self.pickerButtonTapped(_:)), for: .touchUpInside)
        typePickerButton.addTarget(self, action: #selector(self.pickerButtonTapped(_:)), for: .touchUpInside)
        
        okButton.addTarget(self, action: #selector(self.okButtonTapped(_:)), for: .touchUpInside)

        
        
        setDueDate(date: dueDate)
        setScheduleType(type: scheduleType)

        initialKeyBoardSetup()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func initialKeyBoardSetup(){
        
        //キーボード隠すボタンを追加する処理　参考　http://a244.hateblo.jp/entry/2016/02/16/004545
        // 仮のサイズでツールバー生成
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.done,target:self,action:#selector(self.commitButtonTapped))
     
        kbToolBar.items = [spacer, commitButton]
        
        
        memoTextView.inputAccessoryView = kbToolBar
    }
    
    
    func commitButtonTapped (){
        self.view.endEditing(true)
    }
    
    
    
    
    private func setDueDate(date:Date){
        
        let formatter = CustomDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd" //表示形式を設定
        duePickerButton.setTitle(formatter.dateToString(date: date), for: .normal)
        
        self.dueDate = date
    }
    private func setScheduleType(type:ScheduleTableType){
        typePickerButton.setTitle(String(describing: type), for: .normal)
        self.scheduleType = type
    }
    
    
    
    func pickerButtonTapped(_ sender:UIButton){
        switch sender.tag {
        case 0:
            
            let datePicker = ActionSheetDatePicker(title: "Due Date:", datePickerMode: UIDatePickerMode.date, selectedDate: Date(), doneBlock: {
                picker, value, index in
                self.setDueDate(date: value as! Date)
                return
            }, cancel: { ActionStringCancelBlock in return }, origin: sender.superview!.superview)
            datePicker?.show()
            
        case 1:
            let pickertext = ActionSheetStringPicker(title:"select",
                                                     rows:["assignment","test"],
                                                     initialSelection:0,
                                                     doneBlock:{(picker, selectedIndex, selectedValue) in
                                                        switch selectedIndex{
                                                        case 0:
                                                            self.setScheduleType(type: .assignment)
                                                        case 1:
                                                            self.setScheduleType(type: .test)
                                                        default:
                                                            break
                                                        }
            },
                cancel:{picker in
            },
                origin:typePickerButton)
            pickertext?.show()
        default:
            break
        }
    }
    func okButtonTapped(_ sender:UIButton){
        delegate.addScheduleViewDidTappedOKButton(memo: memoTextView.text,dueDate:dueDate,scheduleType:scheduleType)
        
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
