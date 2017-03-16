//
//  CircleView.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/12/31.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    var colorString = "c6ffff"
    var selected = false
    
    private var ovalLayer = CAShapeLayer()
    
   
    override func draw(_ rect: CGRect) {
       
        ovalLayer.removeFromSuperlayer()
        
        var size=CGFloat(10)
        if self.width>=self.height{
            size = self.height
        }else{
            size = self.width
        }
        
        
        ovalLayer.strokeColor = UIColor.black.cgColor
        ovalLayer.fillColor = UIColor(hex:colorString).cgColor
        if selected{
            ovalLayer.lineWidth = 2.5
        }else{
            ovalLayer.lineWidth = 0.5
        }
        ovalLayer.path = UIBezierPath(ovalIn:CGRect(x:0,y:0,width:size,height:size)).cgPath
        self.layer.addSublayer(ovalLayer)
        
        
    }
}
