//
//  AddDataTestTableCustomCell.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/02.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import UIKit
import Material


protocol AddDataCustomCellDelegate {
    func textFieldDidEndEditing(cell: AddDataTestTableCustomCell, value: String) -> ()
}

class AddDataTestTableCustomCell: UITableViewCell ,UITextFieldDelegate{

    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var classRoomTF: TextField!
    
    var delegate:AddDataCustomCellDelegate! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
        classRoomTF.placeholder = "Class Room"
        classRoomTF.isClearIconButtonEnabled = true
        classRoomTF.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    internal func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate.textFieldDidEndEditing(cell: self, value: textField.text!)
    }
    
    

}
