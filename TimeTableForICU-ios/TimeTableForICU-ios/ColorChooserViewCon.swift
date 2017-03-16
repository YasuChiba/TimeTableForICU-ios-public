//
//  ColorChooserViewCon.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/12/27.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import UIKit

class ColorChooserViewCon: UIViewController {

    @IBOutlet weak var view1: CircleView!
    @IBOutlet weak var view2: CircleView!
    @IBOutlet weak var view3: CircleView!
    @IBOutlet weak var view4: CircleView!
    @IBOutlet weak var view5: CircleView!
    @IBOutlet weak var view6: CircleView!
    @IBOutlet weak var view7: CircleView!
    @IBOutlet weak var view8: CircleView!
    @IBOutlet weak var view9: CircleView!
    @IBOutlet weak var view10: CircleView!
    @IBOutlet weak var view11: CircleView!
    @IBOutlet weak var view12: CircleView!
    
    var viewArray:[CircleView] = []
    var closure = {(colorString:String)->() in}
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewArray.append(view1)
        viewArray.append(view2)
        viewArray.append(view3)
        viewArray.append(view4)
        viewArray.append(view5)
        viewArray.append(view6)
        viewArray.append(view7)
        viewArray.append(view8)
        viewArray.append(view9)
        viewArray.append(view10)
        viewArray.append(view11)
        viewArray.append(view12)
        
        
        for tmp in viewArray{
            let gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(self.viewTapped(_:)))
            tmp.addGestureRecognizer(gestureRecognizer)
           
        }
        
        view1.colorString = "ffffff"
        view2.colorString = "ffc1c1"
        view3.colorString = "ffc1ff"
        view4.colorString = "e0c1ff"
        view5.colorString = "c1c1ff"
        view6.colorString = "c1e0ff"
        view7.colorString = "c1ffff"
        view8.colorString = "c1ffe0"
        view9.colorString = "c1ffc1"
        view10.colorString = "e0ffc1"
        view11.colorString = "ffffc1"
        view12.colorString = "ffe0c1"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setProcessBeforeDismiss(closure:@escaping (String)->())->Void{
        self.closure = closure
    }

    func viewTapped(_ sender : UITapGestureRecognizer){
        let view = sender.view as! CircleView
        self.closure(view.colorString)
        self.dismiss(animated: true, completion: nil)
    }
   
  
}
