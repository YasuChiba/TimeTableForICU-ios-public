//
//  CustomTableView.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/12/14.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import UIKit
class CustomTableView: UIView {

    var column1:TableColumnView!
    var column2:TableColumnView!
    var column3:TableColumnView!
    var column4:TableColumnView!
    var column5:TableColumnView!
    var column6:TableColumnView!

    
    
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
        let width=self.bounds.width
        let height=self.bounds.height
        let eachWidth=width/6
        
        column1=TableColumnView()
        column2=TableColumnView()
        column3=TableColumnView()
        column4=TableColumnView()
        column5=TableColumnView()
        column6=TableColumnView()
        var columnList:[TableColumnView]=[column1,column2,column3,column4,column5,column6]
        for tmp in columnList{
            tmp.height=height
            tmp.width=eachWidth
        
            tmp.setNeedsLayout()
            addSubview(tmp)
        }

    }
    private func comminInit() {
       
        
        // MyCustomView.xib からカスタムViewをロードする
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomTableView", bundle: bundle)
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

}
