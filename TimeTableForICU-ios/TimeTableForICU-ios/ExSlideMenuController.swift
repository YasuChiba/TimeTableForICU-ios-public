//
//  ExSlideMenuController.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/10.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
class ExSlideMenuController: SlideMenuController {
    
    
    override func awakeFromNib() {
        /*
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
            self.mainViewController = controller
        }
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "LeftSideMenu") {
            self.leftViewController = controller
        }*/
        super.awakeFromNib()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
