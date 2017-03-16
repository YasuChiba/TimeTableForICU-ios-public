//
//  TopRightBorderLabel.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/12/12.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import UIKit

class TopRightBorderLabel: UIView {

    
    @IBOutlet weak var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    // Storyboard/xib から初期化はここから
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize(){
        // カスタムViewのサイズを自分自身と同じサイズにする
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TopRightBorderLabel", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
        
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
        
        
        
        label.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(0)
        }
        
              
    }


}
