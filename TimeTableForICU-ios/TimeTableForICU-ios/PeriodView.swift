//
//  PeriodView.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/12/09.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import UIKit
import SnapKit


class PeriodView: UIView {
    
    @IBOutlet weak var label1: TopRightBorderLabel!
    @IBOutlet weak var label2: TopRightBorderLabel!
    @IBOutlet weak var label3: TopRightBorderLabel!
    @IBOutlet weak var labelL: TopRightBorderLabel!
    @IBOutlet weak var label4: TopRightBorderLabel!
    @IBOutlet weak var label5: TopRightBorderLabel!
    @IBOutlet weak var label6: TopRightBorderLabel!
    @IBOutlet weak var label7: TopRightBorderLabel!
    @IBOutlet weak var label8: TopRightBorderLabel!
    
    var isPeriod8Visible = true

    override init(frame: CGRect) {
        super.init(frame: frame)
      //  comminInit()
    }
    
    // Storyboard/xib から初期化はここから
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       // comminInit()
    }
    
    override func awakeFromNib() {
        comminInit()
        
    }
    func showPeriod8(show :Bool){
        isPeriod8Visible = show
        self.setNeedsLayout()
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let width = self.bounds.width
        let height = self.bounds.height
        var eachHeight=CGFloat(0)
        if isPeriod8Visible{
            eachHeight=(height-40)/8
        }else{
            eachHeight=(height-40)/7
        }

        var labelArray:[TopRightBorderLabel]=[label1,label2,label3,label4,label5,label6,label7,label8]
     
        labelL.label.backgroundColor=UIColor.gray
        labelL.label.text="L"
        labelL.label.textAlignment = .center
        
        
        var i=1
        for tmp in labelArray{
            tmp.label.text=String(i)
            tmp.label.textAlignment = .center
            i+=1
        }
        
        labelL.snp.updateConstraints { (make) -> Void in
            make.top.equalTo(eachHeight*3)
            make.right.equalTo(0)
            make.size.equalTo(CGSize(width: width, height: 40))
        }
        
        var sum=CGFloat(0)
        for i in 0..<labelArray.count{
            labelArray[i].snp.updateConstraints{(make)->Void in
                sum = eachHeight*CGFloat(i)
                if i>2{
                    sum+=40
                }
                make.top.equalTo(sum)
                make.right.equalTo(0)
                make.size.equalTo(CGSize(width: width, height: eachHeight))
            }
        }
       
        
        if isPeriod8Visible{
            label8.isHidden=false
           

        }else{
            label8.isHidden=true
           

        }

       
    }
    // xibからカスタムViewを読み込んで準備する
    private func comminInit() {
      
        print("")
        print("")
        print("")
        print("--------------------period view loaded--------------")
        print("")
        print("")
        print("")
        print("")


        // MyCustomView.xib からカスタムViewをロードする
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PeriodView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
        print("period view working")
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
    
    
  }
