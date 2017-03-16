//
//  LeftSlideMenuTableController.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/15.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import Foundation
import UIKit


enum SlideMenu:Int{
    case table = 0
    case schedule = 1
    case userPolicy = 2
}

class LeftSideMenuTableController:NSObject,UITableViewDataSource,UITableViewDelegate{
    
    var viewCon:LeftSideMenuViewController!
    var mainViewCon:UINavigationController!
    
    var title = ["Table","Schedule List","利用規約"]
    
    
    init(viewCon:LeftSideMenuViewController){
        self.viewCon = viewCon
    }
    
    
    
    
    //DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return title.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LeftSideMenuTableCell
        
        cell.titleLable.text = title[indexPath.row]
        
        return cell
    }
    
    
    
    
    
    
    func changeViewController(_ menu: SlideMenu) {
        
        
        switch menu {
        case .table:
            if viewCon.mainViewCon != nil{
                viewCon.slideMenuController()?.changeMainViewController(viewCon.mainViewCon, close: true)
            }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainView") as! ViewController
            
                let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
                
                viewCon.slideMenuController()?.changeMainViewController(nvc, close: true)
            }

         
        case .schedule:
            let storyboard = UIStoryboard(name: "ScheduleListViewController", bundle: nil)
            let scheduleListViewController = storyboard.instantiateViewController(withIdentifier: "ScheduleListViewController") as! ScheduleListViewController
            
            let nvc: UINavigationController = UINavigationController(rootViewController: scheduleListViewController)
            viewCon.slideMenuController()?.changeMainViewController(nvc, close: true)
      
        
        case .userPolicy:
            let storyboard = UIStoryboard(name: "UserPolicyViewController", bundle: nil)
            let userPolicyViewController = storyboard.instantiateViewController(withIdentifier: "UserPolicyViewController") as! UserPolicyViewController
        
            let nvc: UINavigationController = UINavigationController(rootViewController: userPolicyViewController)
            viewCon.slideMenuController()?.changeMainViewController(nvc, close: true)
        }

    }
    
    
    
    //Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let menu = SlideMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }

    }
    
    
}
