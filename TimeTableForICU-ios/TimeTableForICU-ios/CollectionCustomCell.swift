//
//  CollectionCustomCell.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/11/25.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import UIKit
import Material

class CollectionCustomCell : UICollectionViewCell{
  

  @IBOutlet weak var label: UILabel!
    
  override init(frame: CGRect){
 
    super.init(frame: frame)
    label = UILabel(frame: CGRect.Make(0, 0, frame.width, frame.height))
    label?.adjustsFontSizeToFitWidth = true
    self.contentView.addSubview(label!)
    
    
  }
  required init(coder aDecoder: NSCoder){
    super.init(coder: aDecoder)!
  }

  
  
}
