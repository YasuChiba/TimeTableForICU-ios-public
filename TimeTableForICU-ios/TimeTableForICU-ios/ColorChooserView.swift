//
//  ColorChooserView.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/02.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import UIKit

class ColorChooserView: UIView{
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

    
    var delegate:FinishChoosingColorDelegate! = nil

   
    override init(frame: CGRect) {
        super.init(frame: frame)
        comminInit()
    }
    
    // Storyboard/xib から初期化はここから
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        comminInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
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
        
      
        view1.selected = true

    }

    
    private func comminInit() {
        
        // MyCustomView.xib からカスタムViewをロードする
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ColorChooserView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
        
        // カスタムViewのサイズを自分自身と同じサイズにする
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                      options:NSLayoutFormatOptions(rawValue: 0),
                                                      metrics:nil,
                                                      views: bindings))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                      options:NSLayoutFormatOptions(rawValue: 0),
                                                      metrics:nil,
                                                      views: bindings))
        
        
    }
    
    
    func viewTapped(_ sender : UITapGestureRecognizer){
        let view = sender.view as! CircleView
        for tmp in viewArray{
            tmp.selected = false
        }
        view.selected = true

        for tmp in viewArray{
            tmp.setNeedsDisplay()
        }
        delegate.didFinishChoosing(colorCode: view.colorString)
    }


    func setChoosedColor(colorString:String){
        for tmp in viewArray{
            tmp.selected = false
        }
        
        for tmp in viewArray{
            if tmp.colorString == colorString{
                tmp.selected = true
                delegate.didFinishChoosing(colorCode: tmp.colorString)
                break
            }
        }
    }

}
