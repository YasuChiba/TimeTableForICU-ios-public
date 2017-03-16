//
//  AddDataTestViewControllerExtensionForTutorial.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/03/17.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import Foundation
import Instructions

extension AddDataTestViewController : CoachMarksControllerDataSource{
    
    func numberOfCoachMarks(for coachMarksController: CoachMarksController) -> Int {
        return 4
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkAt index: Int) -> CoachMark {
        var coachmark : CoachMark
        
        switch (index) {
        case 0:
            coachmark = coachMarksController.helper.makeCoachMark(for: self.syllabusChooseButton)
        case 1:
            coachmark = coachMarksController.helper.makeCoachMark(for: self.scheduleAddIconButton)
        case 2:
            let indexPath = IndexPath.init(row: 0, section: 0)
            coachmark = coachMarksController.helper.makeCoachMark(for:tableView.cellForRow(at: indexPath))
        case 3:
            coachmark = coachMarksController.helper.makeCoachMark(for: self.okButton)
        default:
            coachmark = coachMarksController.helper.makeCoachMark()

        }
        return coachmark
    }
    
    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsAt index: Int, madeFrom coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        
        let coachViews = coachMarksController.helper.makeDefaultCoachViews(withArrow: true, arrowOrientation: coachMark.arrowOrientation)

        switch(index){
        case 0:
            coachViews.bodyView.hintLabel.text = "シラバスから選択する場合はここをタップ"
            coachViews.bodyView.nextLabel.text = "OK!"
        case 1:
            coachViews.bodyView.hintLabel.text = "時間を追加する時はここをタップ"
            coachViews.bodyView.nextLabel.text = "OK!"
        case 2:
            coachViews.bodyView.hintLabel.text = "行を左にスライドでその時間を削除"
            coachViews.bodyView.nextLabel.text = "OK!"
        case 3:
            coachViews.bodyView.hintLabel.text = "最後はここをタップで登録"
            coachViews.bodyView.nextLabel.text = "OK!"
        default:
            coachViews.bodyView.hintLabel.text = ""
            coachViews.bodyView.nextLabel.text = ""
            
        }
        return (bodyView: coachViews.bodyView, arrowView: coachViews.arrowView)
        
    }
}
