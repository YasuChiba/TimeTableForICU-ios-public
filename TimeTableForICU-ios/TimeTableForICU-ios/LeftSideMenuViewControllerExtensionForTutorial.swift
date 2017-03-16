//
//  LeftSideMenuViewControllerExtensionForTutorial.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/03/17.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import Foundation
import Instructions

extension LeftSideMenuViewController: CoachMarksControllerDataSource{
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 3
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        var coachmark : CoachMark
        switch(index){
        case 0:
            let indexPath = IndexPath.init(row: 0, section: 0)
            coachmark = coachMarksController.helper.makeCoachMark(for:tableView.cellForRow(at: indexPath))

        case 1:
            let indexPath = IndexPath.init(row: 1, section: 0)
            coachmark = coachMarksController.helper.makeCoachMark(for:tableView.cellForRow(at: indexPath))

        case 2:
            let indexPath = IndexPath.init(row: 2, section: 0)
            coachmark = coachMarksController.helper.makeCoachMark(for:tableView.cellForRow(at: indexPath))
            
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

