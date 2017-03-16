//
//  TopRightBorderButton.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/12/12.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import UIKit
import SnapKit

class TopRightBorderButton: UIView {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var topBorder: UIView!
    @IBOutlet weak var rightBorder: UIView!
  
    var isConnectWithNextButton = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    // Storyboard/xib から初期化はここから
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    
    override func updateConstraints() {
        // 制約を更新するコードをここに書きます。
        // また、レイアウトを実行するsetNeedsLayout, layoutIfNeededは呼んではいけません。
        // setNeedsDisplayも同じく呼んではいけません。
        
        // superは最後に呼びます。
        print("")
        print("")
        print("toprightBorderBUtton   update COnstrains called")
        print("")
        print("")

        button.snp.updateConstraints{ (make) -> Void in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.right.equalTo(0)
            make.left.equalTo(0)
        }
        rightBorder.snp.updateConstraints{(make) -> Void in
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        
        
        
        super.updateConstraints()
    }
    private func initialize(){
        // カスタムViewのサイズを自分自身と同じサイズにする
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TopRightBorderButton", bundle: bundle)
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
        
        button.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(0)
        }
    }


}
