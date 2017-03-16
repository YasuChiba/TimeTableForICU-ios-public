//
//  UserPolicyViewController.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/03/04.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import UIKit
import Material

class UserPolicyViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLeftBarButtonWithImage(Icon.menu!)

        let path = Bundle.main.path(forResource: "userPolicy", ofType: "html")!
        
        webView.loadRequest(URLRequest(url: NSURL(string: path)! as URL))

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
