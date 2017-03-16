//
//  ClassInfoTableController.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/03.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import Foundation
import UIKit
import SSImageBrowser

class ClassInfoTableController:NSObject,UITableViewDataSource,UITableViewDelegate,TableViewHeaderDelegate,TableViewMemoDelegate{
    
    var viewCon:ClassInfoViewController
    var formatter :CustomDateFormatter! = nil
    
    init(view: ClassInfoViewController) {
        viewCon=view
        
        formatter = CustomDateFormatter()
        formatter.dateFormat = "M/d" //表示形式を設定

    }
    
    func didTappTableViewHeaderButton(header: ClassInfoTableHeaderView){
        switch header.tag{
        case 0:
            viewCon.showAddScheduleView()
        case 1:
            viewCon.showAddDataView()
        default: break
        }
    }

    func didTappTableViewPhotoButton(header: ClassInfoTableHeaderView) {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = viewCon
    
        viewCon.present(picker, animated: true, completion: nil)
        
        
    }
    func didTappTableViewMemoImageView(identifierArray:[String],selectedImageIndex:Int,indexPath:IndexPath){
        var imageArray:[SSPhoto] = []
        
        var count = 0
        for ident in identifierArray{
            CameraAndFileIOUtils.loadImageFromIdentifier(identifier: ident, completion: {(image) in
                var ssimage = SSPhoto(image:image!)
                imageArray.append(ssimage)
                count += 1
                if count == identifierArray.count{
                    self.showBrowser(photos: imageArray,initialIndex:selectedImageIndex)
                }

            
            })
            
        }
    
    
    }
    func didLongTappTableViewMemoImageView(imageIdentifier:String,indexPath:IndexPath) {
        viewCon.deleteImageWithDeleteFromDB(indentifier: imageIdentifier, indexPath:indexPath)
    }
    
    
    
    
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {  //セクション数
        return 2
    }
  
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(40)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(30)
    }
   
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ClassInfoTableHeaderView") as! ClassInfoTableHeaderView
        

        cell.delegate = self
        switch section{
        case 0:
            cell.headerLabel.text = "Schedule"
            cell.buttonForPhoto.isHidden = true
            cell.tag = 0
        case 1:
            cell.headerLabel.text = "Memo"
            cell.buttonForPhoto.isHidden = true    //falseにすればカメラボタン
            cell.tag = 1
        default:
            break
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer: UIView = UIView()
      
        return footer

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewCon.getScheduleData().count
        case 1:
            return viewCon.getDataData().count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! ClassInfoTableScheduleCell
            
            print("print shcedule date :\(viewCon.getScheduleData()[indexPath.row].dueDate) row At :\(indexPath.row)")
            
            cell.memoLabel.text = viewCon.getScheduleData()[indexPath.row].memo
            cell.dateLabel.text = formatter.dateToString(date: viewCon.getScheduleData()[indexPath.row].dueDate)
            cell.typeLabel.text = String(describing: viewCon.getScheduleData()[indexPath.row].typeOfSchedule)
            return cell
        case 1:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as! ClassInfoTableMemoCell
            cell.indexPath = indexPath
            cell.delegate = self
            cell.dateLabel.text = formatter.dateToString(date: viewCon.getDataData()[indexPath.row].getDate())
            
            var labelText = ""
            
            
            for tmp in viewCon.getDataData()[indexPath.row].getMemoData(){
                labelText = labelText + "\n" + tmp.data
            }
            cell.memoLabel.text = labelText
            
            /*
            let photoList = viewCon.getDataData()[indexPath.row].getPhotoData()
            /*
            if photoList.count == 0{
                cell.photoStackView.isHidden = true
            }else{
                cell.photoStackView.isHidden = false
            }*/
            var photoIdentList:[String] = []
            for tmp in photoList{
                photoIdentList.append(tmp.data)
            }
            cell.setPhotoData(indentifiers:photoIdentList)
 */
            cell.photoBaseView.isHidden = true
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! ClassInfoTableScheduleCell
            return cell
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section{
        case 0:
            return true
        case 1:
            return true
        default :
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .default, title: "Delete", handler:{(action,index)in
            
            switch indexPath.section{
            case 0:
                self.viewCon.deleteScheduleData(index:indexPath)
            case 1:
                self.viewCon.deleteDataData(index: indexPath)
            default :break
            }
            
        })
        return [delete]
    }

    
}





extension ClassInfoTableController{
    
    func showBrowser(photos: [SSPhoto],initialIndex:Int) {
        // Create and setup browser
        let browser = SSImageBrowser(aPhotos: photos, animatedFromView: nil)
        browser.delegate = self
        browser.setInitialPageIndex(initialIndex)
        print("initial index:\(initialIndex)")
        browser.displayActionButton = false
        // Show
        viewCon.present(browser, animated: true, completion: nil)
        //tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }

}



extension ClassInfoTableController: SSImageBrowserDelegate {
    
    func photoBrowser(_ photoBrowser: SSImageBrowser, captionViewForPhotoAtIndex index: Int) -> SSCaptionView! {
        return nil
    }
    
    func photoBrowser(_ photoBrowser: SSImageBrowser, didDismissActionSheetWithButtonIndex index: Int, photoIndex: Int) {
    }
    
    func photoBrowser(photoBrowser: SSImageBrowser, didDismissAtPageIndex index: Int) {
    }
    
    func photoBrowser(photoBrowser: SSImageBrowser, didShowPhotoAtIndex index: Int) {
    }
    
    func photoBrowser(photoBrowser: SSImageBrowser, willDismissAtPageIndex index: Int) {
    }
}

