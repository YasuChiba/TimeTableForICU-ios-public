//
//  DateCollectionCon.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/11/25.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import Foundation
import UIKit



class DateCollectionController:NSObject,UICollectionViewDataSource,UICollectionViewDelegate{
  
    var text:String!
  
    var num = 10
    var count=1
    var viewCon : AddDataViewController
    var isHeaderFirstTime = true
    var isFooterFirstTime = true

  
  
  
    init(view: AddDataViewController) {
        viewCon=view
    }
  
    func changeText(text : String){
        self.text=text
    }
    func changeNumData(num : Int){
        self.num=num
    }
  
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
    
        return viewCon.getPeriodData().count
    }
  
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CollectionCustomCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath as     IndexPath) as! CollectionCustomCell
        
        
        cell.label?.text = DevideScheduleString.devideScheduleNumToInitialArray(scheduleNumArray: viewCon.getPeriodData())[indexPath.row]
        
        cell.label.adjustsFontSizeToFitWidth = true
            
        cell.label?.tag = indexPath.row
        



        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        lpgr.minimumPressDuration = 0.5
  
     //   cell.label?.addGestureRecognizer(lpgr)
        cell.addGestureRecognizer(lpgr)
        
    
    
        return cell
    }
  
  // セクションの数
    private func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
  
  // 表示するセルの数
    private func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewCon.getPeriodData().count
    }
  
    
    //セクションを返すメソッド
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        
        if (kind == "UICollectionElementKindSectionHeader") {
            //ヘッダーの場合
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath as IndexPath) as! AddDataHeaderView
            

            if isHeaderFirstTime{       //こうしないと、登録する時間が０個の時schedulePickerButtonに登録出来なくてエラーで落ちる
                viewCon.pickerButton = headerView.pickerButton
                viewCon.schedulePickerButton = headerView.schedulePickerButton
                viewCon.courseTitleTF = headerView.courseTitleTF
                viewCon.classRoomTF = headerView.classRoomTF
                viewCon.instructorTF = headerView.instructorTF
                viewCon.colorChooserButton = headerView.colorChooserButton
                
                viewCon.courseTitleTF.delegate = viewCon
                viewCon.classRoomTF.delegate = viewCon
                viewCon.instructorTF.delegate = viewCon

                
                viewCon.pickerButton.setTitle("choose from syllabus", for: .normal)
                viewCon.schedulePickerButton.setTitle(DevideScheduleString.devideScheduleNumToInitialArray(scheduleNumArray: viewCon.getPeriodData()[0]), for: .normal)
                viewCon.colorChooserButton.titleLabel?.text = ""
                viewCon.colorChooserButton.backgroundColor = UIColor(hex:"ffffff")
                isHeaderFirstTime = false
            }
            
            
            return headerView
            
            
        } else {
            
            //フッターの場合
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "FooterView", for: indexPath as IndexPath) as! AddDataFooterView
           
            if isFooterFirstTime{
                viewCon.okButton = footerView.okButton
                isFooterFirstTime = false
            }
           
            return footerView
 
        }
    }
    
  
  
  
  
  
    func handleLongPress(gestureRecognizer : UILongPressGestureRecognizer){
    
        if (gestureRecognizer.state != UIGestureRecognizerState.ended){
            return
        }
    
        let p = gestureRecognizer.location(in: viewCon.collectionView)
    
        if let ind : IndexPath = (viewCon.collectionView?.indexPathForItem(at: p))! as IndexPath?{
      
            
            print("long pres \(count) : \(ind.row) ")
            count+=1
            
      //      let cell = viewCon.collectionView.cellForItem(at: ind) as! CollectionCustomCell
      
            viewCon.deleteSchedule(dataSubscript: ind.row)
         //   var data = viewCon.getPeriodData()
        //    viewCon.collectionView.deleteItems(at: [ind])
        }
    
    }
}

  
