//
//  ScheduleListTableController.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/28.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import Foundation
import UIKit

class ScheduleListTableController:NSObject,UITableViewDataSource,UITableViewDelegate{
    
    
    var viewCon:ScheduleListViewController!
    
    init(viewCon:ScheduleListViewController){
        self.viewCon = viewCon
    }

    
    
    //DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewCon.getData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! ScheduleListTableCell
        let data = viewCon.getData()[indexPath.row]
        cell.setData(date: data.getDate(), courseTitle: data.getCourseTitle(), scheduleType: data.getScheduleType(), memo: data.getMemo(),scheduleTableId: data.getId())
        
        
        return cell
    }
    
    
    //Delegate
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let delete = UITableViewRowAction(style: .default, title: "Delete", handler:{(action,index)in
          //  if self.viewCon.getScheduleData().count != 1{
               // self.viewCon.deleteScheduleData(index: indexPath)
           //     print("delete button tpped at index :\(indexPath.row)")
        //    }
        })
        return [delete]
        
    }
    

}
