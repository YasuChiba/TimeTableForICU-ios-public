//
//  LeftSideMenuTableCell.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/15.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import UIKit

class LeftSideMenuTableCell: UITableViewCell {
    @IBOutlet weak var titleLable: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLable.adjustsFontSizeToFitWidth = false
        titleLable.width = CGFloat(270)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
