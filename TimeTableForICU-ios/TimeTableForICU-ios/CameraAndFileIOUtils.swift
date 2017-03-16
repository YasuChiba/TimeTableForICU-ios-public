//
//  CamerAndFileIOUtils.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/11.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import Foundation
import Photos
import UIKit
import Material

class CameraAndFileIOUtils{
    
    
    private static func saveImage(image:UIImage,album:PHAssetCollection!,completion:@escaping (String)->()){
        var identifier:String?
        
        if let anAlbum = album {
            PHPhotoLibrary.shared().performChanges({ () -> Void in

                let createAssetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
                
                let assetPlaceholder = createAssetRequest.placeholderForCreatedAsset!
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: anAlbum)
                
                let fastEnumeration = NSArray(array: [assetPlaceholder] as [PHObjectPlaceholder])
                albumChangeRequest!.addAssets(fastEnumeration)
                print("identifier :\(assetPlaceholder.localIdentifier)")
                identifier = assetPlaceholder.localIdentifier
                
            },completionHandler: { (isSuccess, error) -> Void in
                if isSuccess == true {
                    print("Success!")
                    completion(identifier!)
                }
                else{
                    print("error occured")
                }
            })
            
        }
    }
    
    
    
    
    
    
    
    static func saveImage(image:UIImage,albumName:String,completion:@escaping (String?)->()){
        
        if let album = self.findAlbum(albumName:albumName){
            saveImage(image: image, album: album, completion: completion)
        }else{
            createAlbum(completion : {
                self.saveImage(image: image, albumName:albumName,completion: completion)
            })
        }
    }
    
    
    static func findAlbum(albumName:String)->PHAssetCollection?{
        
        
        var theAlbum: PHAssetCollection? // アルバムをオブジェクト化
        // フォトライブラリからMyAlbumを検索
        let result = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.any, options: nil)
        result.enumerateObjects({(object, index, stop) in
            if let theCollection = object as? PHAssetCollection,
                theCollection.localizedTitle == albumName
            {
                theAlbum = theCollection // 見つかったら、theAlbumに代入
            }
        })
        
        
        return theAlbum
        
    }
    
    
    
    
    static func createAlbum(completion:@escaping ()->()){
        let albumName :String = Constants.albumName
        
        
        PHPhotoLibrary.shared().performChanges({ () -> Void in
            _ = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
        },completionHandler: { (isSuccess, error) -> Void in
            if isSuccess == true {
                print("Success!")
                completion()
            }
            else{
                print("error occured")
            }
        })
    }
    
    
    static func deleteImage(identifier:String,completion:@escaping()->()) {
        let assets = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil)
        guard let asset = assets.lastObject else{
            return
        }
        PHPhotoLibrary.shared().performChanges({() -> Void in
            PHAssetChangeRequest.deleteAssets([asset] as NSArray)
            
        }, completionHandler: { (isSuccess, error)-> Void in
                if isSuccess == true{
                    completion()
                }else{
                }
          
        })
        
    }
    
    static func loadImageFromIdentifier(identifier:String,completion:@escaping (UIImage?)->()){
        let asset = PHAsset.fetchAssets(withLocalIdentifiers:[identifier], options: nil)
        if asset.lastObject == nil{
            completion(Icon.photoLibrary)
            return
        }else{
            let manager: PHImageManager = PHImageManager()
            
            
            manager.requestImage(for: asset.lastObject!,
                                         targetSize: PHImageManagerMaximumSize,
                                         contentMode: PHImageContentMode.aspectFill,
                                         options: nil) { (image, info) in
                                            // imageにUIImageが渡ってきます
                                            completion(image)

            }
        }
    }
    
    
    static func loadThumbnailFromIdentifier(identifier:String,completion:@escaping (UIImage?)->()){
        let asset = PHAsset.fetchAssets(withLocalIdentifiers: [identifier], options: nil)
        if asset.lastObject == nil{
            completion(Icon.photoLibrary)
            return
        }else{
            print("thumbnail loaded")
            loadThumbnailFromAsset(asset: asset.lastObject!, completion: completion)
        }
    }
    
    static func loadThumbnailFromIdentifier(identifier:[String],completion:@escaping ([UIImage])->()){
        var photoAssets:[PHAsset] = []
        var imageArray:[UIImage] = []
        
        var assets: PHFetchResult = PHAsset.fetchAssets(withLocalIdentifiers: identifier, options: nil)
        assets.enumerateObjects({ (asset, index, stop) -> Void in
            photoAssets.append(asset as PHAsset)
        })
        
        var count = 0
        for asset in photoAssets{
            var option = PHImageRequestOptions()
            option.normalizedCropRect = CGRect.Make(0, 0, 100, 100)
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .aspectFit, options: option, resultHandler: { result, info in
                if result == nil{
                    imageArray.append(Icon.photoLibrary!)
                }else{
                    imageArray.append(result!)
                }
                count += 1
                if count == photoAssets.count {
                    completion(imageArray)
                }
            })
        }
    }
    
    static func loadThumbnailFromAsset(asset: PHAsset, completion:@escaping (UIImage?)->()) {
        
        var option = PHImageRequestOptions()
        option.normalizedCropRect = CGRect.Make(0, 0, 100, 100)
        
        
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .aspectFit, options: option, resultHandler: { result, info in
            if result == nil{
                completion(Icon.photoLibrary)
            }else{
                print("completion process   result not nil")
                completion(result)
            }
        })
    }

    
    
}
