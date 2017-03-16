//
//  ClassInfoViewControllerCameraExtension.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/10.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import Foundation
import UIKit
import Photos


//参考　http://ja.stackoverflow.com/questions/17776/指定したアルバム内への画像の保存方法について
//http://stackoverflow.com/questions/33866743/swift-adding-photo-to-custom-album

//これも参考になるかもhttp://stackoverflow.com/questions/27008641/save-images-with-phimagemanager-to-custom-album


extension ClassInfoViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        // 撮影した画像をカメラロールに保存
       // UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
    
        CameraAndFileIOUtils.saveImage(image: image, albumName: Constants.albumName,completion:{ (identifier) in
            self.DBDataTableM.setData(classKey: self.classKey, tableKey: self.tableKey, type: .photo, addedDate: Date(), data: identifier!)
            
            self.loadDataData()
        
           // self.tableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .none)
           // self.addDataData(data: identifier!, typeOfData: .photo)
            
            self.tableView.reloadData()
            
            
        })
        
       
        
        picker.dismiss(animated: true, completion: nil)
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
 
    
    
    func deleteImageWithDeleteFromDB(indentifier:String,indexPath:IndexPath){
        CameraAndFileIOUtils.deleteImage(identifier: indentifier, completion: {
            
            self.deleteDataDataFromDBByIdentifier(index:indexPath,identifier:indentifier)
        })
        
    }
    func deleteImage(identifier:String){
        CameraAndFileIOUtils.deleteImage(identifier: identifier, completion: {
        })
    }
    
    
    func deleteDataDataFromDBByIdentifier(index:IndexPath,identifier:String){
        let date = DataList[index.row].getDate()
        let data = DataList[index.row].getData()
        let dataIndex = data.index{ $0.data == identifier }
        
        _ = DBDataTableM.deleteDataByIdentifier(identifier: identifier)
        
        DataList[index.row].deleteData(index:dataIndex!)
        
        
        tableView.reloadRows(at: [index], with: .automatic)
        //   tableView.reloadData()
        
    }

  
    /*
    func test(image:UIImage){
        
 
        
        let albumTitle = "testFolder" // アルバム名
    
        let savingImage = image
        
        var theAlbum: PHAssetCollection? // アルバムをオブジェクト化
        // フォトライブラリからMyAlbumを検索
        let result = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.any, options: nil)
        result.enumerateObjects({(object, index, stop) in
            if let theCollection = object as? PHAssetCollection,
                theCollection.localizedTitle == albumTitle
            {
                theAlbum = theCollection // 見つかったら、theAlbumに代入
            }
        })
        // アルバムにイメージを保存する
        if let anAlbum = theAlbum {
            PHPhotoLibrary.shared().performChanges({
                let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: savingImage)
            
                let assetPlaceholder = createAssetRequest.placeholderForCreatedAsset!
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: anAlbum)
                
                let fastEnumeration = NSArray(array: [assetPlaceholder] as [PHObjectPlaceholder])
                albumChangeRequest!.addAssets(fastEnumeration)
                print("identifier :\(assetPlaceholder.localIdentifier)")
                
                
            }, completionHandler: nil)
        } else {
            
            print("folder cannnot find     make new Folder")
            createAlbum()
            test(image:image)
        }
        
        
        
    }
    
    
    */
  
}

