//
//  AddDataTestTableController.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/02.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import Foundation
import UIKit


class AddDataTestTableController : NSObject,UITableViewDataSource,UITableViewDelegate,AddDataCustomCellDelegate{
    
    var viewCon:AddDataTestViewController
    
    init(viewCon:AddDataTestViewController){
        self.viewCon = viewCon
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewCon.getScheduleData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AddDataTestTableCustomCell

        cell.periodLabel?.text = DevideScheduleString.devideScheduleNumToInitialArray(scheduleNumArray: viewCon.getScheduleData()[indexPath.row].scheduleNum)
        cell.classRoomTF.text = viewCon.getScheduleData()[indexPath.row].classRoom
        
        cell.tag = indexPath.row
        cell.delegate = self
        return cell
    }

    

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete", handler:{(action,index)in
            if self.viewCon.getScheduleData().count != 1{
                self.viewCon.deleteScheduleData(index: indexPath)
                print("delete button tpped at index :\(indexPath.row)")
            }
        })
        return [delete]
    }

    
    
    
    
    
    // MARK: - AddDataCustomCellDelegateの実装
    func textFieldDidEndEditing(cell: AddDataTestTableCustomCell, value: String) -> () {
        cell.classRoomTF.resignFirstResponder()

        let path = viewCon.tableView.indexPathForRow(at: cell.convert(cell.bounds.origin, to: viewCon.tableView))
        
        if path != nil{
            viewCon.editPeriodClassRoomData(index: (path?.row)!, classRoomText: value)
        }
    }
    
    
}
