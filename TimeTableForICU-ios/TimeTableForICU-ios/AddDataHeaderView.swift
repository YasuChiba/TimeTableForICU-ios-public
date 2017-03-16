//
//  AddDataHeaderView.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/12/24.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import UIKit
import Material
class AddDataHeaderView: UICollectionReusableView {
    @IBOutlet weak var pickerButton: RaisedButton!
    @IBOutlet weak var courseTitleTF: UITextField!
    @IBOutlet weak var classRoomTF: UITextField!
    @IBOutlet weak var instructorTF: UITextField!
    @IBOutlet weak var schedulePickerButton: RaisedButton!
    @IBOutlet weak var colorChooserButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
