//
//  TJViewExtensions.swift
//  TJExtension
//
//  Created by tajika on 2015/12/08.
//  Copyright © 2015年 Tajika. All rights reserved.
//

import UIKit

public enum TJViewBorderPosition {
    case top
    case right
    case bottom
    case left
}

public extension UIView {

    public func border(borderWidth: CGFloat, borderColor: UIColor?, borderRadius: CGFloat?) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor?.cgColor
        if let _ = borderRadius {
            self.layer.cornerRadius = borderRadius!
        }
        self.layer.masksToBounds = true
    }

    public func border(_ positions: [TJViewBorderPosition], borderWidth: CGFloat, borderColor: UIColor?) {
        self.layer.sublayers = nil
        if positions.contains(.top) {
            borderTop(borderWidth, borderColor: borderColor)
        }
        if positions.contains(.left) {
            borderLeft(borderWidth, borderColor: borderColor)
        }
        if positions.contains(.bottom) {
            borderBottom(borderWidth, borderColor: borderColor)
        }
        if positions.contains(.right) {
            borderRight(borderWidth, borderColor: borderColor)
        }
    }
    
    fileprivate func borderTop(_ borderWidth: CGFloat, borderColor: UIColor?) {
        let rect = CGRect(x: 0.0, y: 0.0, width: self.frame.width, height: borderWidth)
        addBorderWithRect(borderWidth, borderColor: borderColor, rect: rect)
    }

    fileprivate func borderBottom(_ borderWidth: CGFloat, borderColor: UIColor?) {
        let rect = CGRect(x: 0.0, y: self.frame.height - borderWidth, width: self.frame.width, height: borderWidth)
        addBorderWithRect(borderWidth, borderColor: borderColor, rect: rect)
    }
    
    fileprivate func borderLeft(_ borderWidth: CGFloat, borderColor: UIColor?) {
        let rect = CGRect(x: 0.0, y: 0.0, width: borderWidth, height: self.frame.height)
        addBorderWithRect(borderWidth, borderColor: borderColor, rect: rect)
    }
    
    fileprivate func borderRight(_ borderWidth: CGFloat, borderColor: UIColor?) {
        let rect = CGRect(x: self.frame.width - borderWidth, y: 0.0, width: borderWidth, height: self.frame.height)
        addBorderWithRect(borderWidth, borderColor: borderColor, rect: rect)
    }
    
    fileprivate func addBorderWithRect(_ borderWidth: CGFloat, borderColor: UIColor?, rect: CGRect) {
        let line = CALayer()
        let defaultBorderColor = UIColor.white
        var CGBorderColor: CGColor
        
        self.layer.masksToBounds = true
        
        if let _ = borderColor {
            CGBorderColor = borderColor!.cgColor
        } else {
            CGBorderColor = defaultBorderColor.cgColor
        }
        
        line.frame = rect
        line.backgroundColor = CGBorderColor
        self.layer.addSublayer(line)
        self.setNeedsDisplay()
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let _ = self.layer.borderColor {
                return UIColor(cgColor: self.layer.borderColor!)
            }
            return nil
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
        }
    }
    
}
