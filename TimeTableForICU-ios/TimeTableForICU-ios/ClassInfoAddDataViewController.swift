//
//  ClassInfoAddDataViewController.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/06.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import Foundation
import UIKit
import ActionSheetPicker_3_0

protocol ClassInfoAddDataViewDelegate{
    func addDataViewDidTappedOKButton(memo:String,addedDate:Date)
}

class ClassInfoAddDataViewController: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var datePickerButton: UIButton!
    
    @IBOutlet weak var memoTextView: UITextView!
    
    @IBOutlet weak var okButton: UIButton!
    
    var date = Date()
    
    var delegate:ClassInfoAddDataViewDelegate! = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePickerButton.addTarget(self, action: #selector(self.pickerButtonTapped), for: .touchUpInside)
        
        okButton.addTarget(self, action: #selector(self.okButtonTapped), for: .touchUpInside)
        
        
        
        
        setDate(date: date)
        
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
    
    
    
    
    private func setDate(date:Date){
        
        let formatter = CustomDateFormatter()
        formatter.dateFormat = "yyyy/MM/dd" //表示形式を設定
        datePickerButton.setTitle(formatter.dateToString(date: date), for: .normal)
        
        self.date = date
    }
    
    func pickerButtonTapped(){
        let datePicker = ActionSheetDatePicker(title: "Date:", datePickerMode: UIDatePickerMode.date, selectedDate: Date(), doneBlock: {
            picker, value, index in
            self.setDate(date: value as! Date)
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: datePickerButton)
        datePicker?.show()
        
        
    }
    
    func okButtonTapped(){
        delegate.addDataViewDidTappedOKButton(memo: memoTextView.text, addedDate: date)
        self.dismiss(animated: true, completion: nil)

    }
    
}
