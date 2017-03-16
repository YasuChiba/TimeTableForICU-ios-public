//
//  TableSettingsTableController.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/12/31.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import Foundation
import UIKit
class TableSettingsTableController:NSObject,UITableViewDataSource,UITableViewDelegate{
    
    var viewCon:TableSettingsViewController
    
    
    
    init(view: TableSettingsViewController) {
        viewCon=view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewCon.getData().count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableCustomCell
        cell.label1.text = (viewCon.getData())[indexPath.row].tableName
        cell.label2.text = String((viewCon.getData())[indexPath.row].tableYear) + (viewCon.getData())[indexPath.row].tableSeason.rawValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        viewCon.setCurrentTable(tableKey: viewCon.getData()[indexPath.row].tableKey,tableName:viewCon.getData()[indexPath.row].tableName)
        
        
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete", handler:{(action,index)in
            if self.viewCon.getData().count != 1{
                self.viewCon.deleteData(dataIndex: indexPath)
                print("delete button tpped at index :\(indexPath.row)")
            }
        })
        return [delete]
    }
    
}
