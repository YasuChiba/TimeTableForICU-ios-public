//
//  ClassInfoTableCell.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/03.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import UIKit

class ClassInfoTableScheduleCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        comminInit()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
    private func comminInit() {
        // カスタムViewをロードする
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ClassInfoTableScheduleCell", bundle: bundle)
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
