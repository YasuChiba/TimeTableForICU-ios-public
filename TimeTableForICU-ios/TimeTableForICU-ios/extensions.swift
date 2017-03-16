//
//  extensions.swift
//  timetable1
//
//  Created by 彌平千葉 on 2016/10/24.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import Foundation
import UIKit
import Photos


extension String {
    
    private var ns: NSString {
        return (self as NSString)
    }
    
    public func substring(from index: Int) -> String {
        return ns.substring(from: index)
    }
    
    public func substring(to index: Int) -> String {
        return ns.substring(to: index)
    }
    
    public func substring(with range: NSRange) -> String {
        return ns.substring(with: range)
    }
    
    public var lastPathComponent: String {
        return ns.lastPathComponent
    }
    
    public var pathExtension: String {
        return ns.pathExtension
    }
    
    public var deletingLastPathComponent: String {
        return ns.deletingLastPathComponent
    }
    
    public var deletingPathExtension: String {
        return ns.deletingPathExtension
    }
    
    public var pathComponents: [String] {
        return ns.pathComponents
    }
    
    public func appendingPathComponent(_ str: String) -> String {
        return ns.appendingPathComponent(str)
    }
    
    public func appendingPathExtension(_ str: String) -> String? {
        return ns.appendingPathExtension(str)
    }
}



extension CGRect {
    static func Make(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) -> CGRect {
        return CGRect.init(x: x, y: y, width: w, height: h)
    }
    static var Zero: CGRect {
        get {
            return CGRect.init(x: 0, y: 0, width: 0, height: 0)
        }
    }
}



extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        var border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRectMake(0, 0, UIScreen.main.bounds.height, thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRectMake(0, self.frame.height - thickness, UIScreen.main.bounds.width, thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRectMake(0, 0, thickness, self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRectMake(self.frame.width - thickness,  0, thickness, self.frame.height)
            
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }

    
}

public extension UICollectionView {
    
    public func adaptBeautifulGrid(numberOfGridsPerRow: Int, gridLineSpace space: CGFloat) {
        let inset = UIEdgeInsets(
            top: space, left: space, bottom: space, right: space
        )
        adaptBeautifulGrid(numberOfGridsPerRow: numberOfGridsPerRow, gridLineSpace: space, sectionInset: inset)
    }
    
    public func adaptBeautifulGrid(numberOfGridsPerRow: Int, gridLineSpace space: CGFloat, sectionInset inset: UIEdgeInsets) {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        guard numberOfGridsPerRow > 0 else {
            return
        }
        let isScrollDirectionVertical = layout.scrollDirection == .vertical
        var length = isScrollDirectionVertical ? self.frame.width : self.frame.height
        length -= space * CGFloat(numberOfGridsPerRow - 1)
        length -= isScrollDirectionVertical ? (inset.left + inset.right) : (inset.top + inset.bottom)
        let side = length / CGFloat(numberOfGridsPerRow)
        guard side > 0.0 else {
            return
        }
        layout.itemSize = CGSize(width: side, height: side)
        layout.minimumLineSpacing = space
        layout.minimumInteritemSpacing = space
        layout.sectionInset = inset
        layout.invalidateLayout()
    }
    
}


