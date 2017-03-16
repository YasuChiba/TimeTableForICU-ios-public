//
//  TableCustomCell.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/12/31.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import Foundation
import UIKit

class TableCustomCell:UITableViewCell{
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    
}
