//
//  ClassInfoTableHeaderView.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/03.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import UIKit
import Material



protocol TableViewHeaderDelegate {
    func didTappTableViewHeaderButton(header: ClassInfoTableHeaderView)
    func didTappTableViewPhotoButton(header:ClassInfoTableHeaderView)
}


class ClassInfoTableHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var headerButton: UIButton!
    
    @IBOutlet weak var buttonForPhoto: UIButton!
    
    
    var delegate:TableViewHeaderDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        comminInit()
    }
    
    
    private func comminInit() {
        
        headerButton.addTarget(self, action: #selector(self.buttonTapped), for: .touchUpInside)
        headerButton.setImage(Icon.add, for: .normal)
        headerButton.setTitle("", for: .normal)
        
        buttonForPhoto.addTarget(self, action: #selector(self.photoButtonTapped), for: .touchUpInside)
        buttonForPhoto.setImage(Icon.photoCamera, for: .normal)
        buttonForPhoto.setTitle("", for: .normal)
    }
    
    func buttonTapped(){
        delegate.didTappTableViewHeaderButton(header: self)
    }
    func photoButtonTapped(){
        delegate.didTappTableViewPhotoButton(header: self)
    }

}
