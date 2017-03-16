//
//  ScheduleListTableCell.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/03/03.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import UIKit

class ScheduleListTableCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var scheduleTypeLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    
    var scheduleTableId:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setData(date:String,courseTitle:String,scheduleType:String,memo:String,scheduleTableId:Int){
        
        self.dateLabel.text = date
        self.courseTitleLabel.text = courseTitle
        self.scheduleTypeLabel.text = scheduleType
        self.memoLabel.text = memo
        self.scheduleTableId = scheduleTableId
    }

}
