//
//  LeftSideMenu.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/10.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import UIKit
import Instructions
import SlideMenuControllerSwift

class LeftSideMenuViewController:UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableController:LeftSideMenuTableController!
    
    var mainViewCon:UINavigationController!    //これを置くことで、時間割のロード時間をなくす。メインの時間割のインスタンスを保持し続ける
    
    let coachMarksController = CoachMarksController()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableController = LeftSideMenuTableController(viewCon:self)
        tableView.dataSource = tableController
        tableView.delegate = tableController
        tableView.separatorColor = UIColor.clear
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GAUtility.sendScreenTracking(screenName: .leftMenu)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //coachMarksController.dataSource = self
        //coachMarksController.startOn(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    //    coachMarksController.stop(immediately: true)
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
