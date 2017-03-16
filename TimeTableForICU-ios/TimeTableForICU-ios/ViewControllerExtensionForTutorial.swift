//
//  ViewControllerExtensionForTutorial.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/03/16.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import Foundation
import UIKit
import Instructions

extension ViewController:CoachMarksControllerDataSource{
    
    
    

    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 3
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        
        var coachmark : CoachMark
        switch(index){
        case 0:
            let rightBarButton = self.navigationItem.rightBarButtonItem! as UIBarButtonItem
            let viewRight = rightBarButton.value(forKey: "view") as! UIView
            coachmark = coachMarksController.helper.makeCoachMark(for: viewRight)
            // coachmark.horizontalMargin = 5
        case 1:
            let leftBarButton = self.navigationItem.leftBarButtonItem! as UIBarButtonItem
            let viewLeft = leftBarButton.value(forKey: "view") as! UIView
            coachmark = coachMarksController.helper.makeCoachMark(for: viewLeft)

        case 2:
            coachmark = coachMarksController.helper.makeCoachMark(for: self.columnM.button1)

        default:
            coachmark = coachMarksController.helper.makeCoachMark()
            
        }
        return coachmark
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)
        
        
        
        switch(index){
        case 0:
            coachViews.bodyView.hintLabel.text = "設定"
            coachViews.bodyView.nextLabel.text = "OK!"
        case 1:
            coachViews.bodyView.hintLabel.text = "メニュー"
            coachViews.bodyView.nextLabel.text = "OK!"
        case 2:
            coachViews.bodyView.hintLabel.text = "クラスを追加する時はセルをタップ"
            coachViews.bodyView.nextLabel.text = "OK!"
        default:
            coachViews.bodyView.hintLabel.text = ""
            coachViews.bodyView.nextLabel.text = ""

        }
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)

    }
  
}



extension ViewController:CoachMarksControllerDelegate{
  
  
  
}
