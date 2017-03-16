//
//  ClassInfoTableMemoCell.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2017/01/03.
//  Copyright © 2017年 彌平千葉. All rights reserved.
//

import UIKit
import SnapKit
import Material


protocol TableViewMemoDelegate {
    func didTappTableViewMemoImageView(identifierArray:[String],selectedImageIndex:Int,indexPath:IndexPath)
    func didLongTappTableViewMemoImageView(imageIdentifier:String,indexPath:IndexPath)
}
class ImageWithTag{
    var image:UIImageView!
    var identifier:String!
}

class ClassInfoTableMemoCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var memoLabel: UILabel!
    
    @IBOutlet weak var photoBaseView: UIView!
  
    
    var delegate : TableViewMemoDelegate!
    
    var indexPath:IndexPath!
  
  
    var imageViewArray:[ImageWithTag] = []
    var identifierArray:[String] = []

    
    override func awakeFromNib() {
        super.awakeFromNib()
        comminInit()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    private func comminInit() {
        // カスタムViewをロードする
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ClassInfoTableMemoCell", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
      
    
      
      
        // カスタムViewのサイズを自分自身と同じサイズにする
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                      options:NSLayoutFormatOptions(rawValue: 0),
                                                      metrics:nil,
                                                      views: bindings))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                      options:NSLayoutFormatOptions(rawValue: 0),
                                                      metrics:nil,
                                                      views: bindings))
        
        
    }
    
    func setPhotoData(indentifiers:[String]){
        identifierArray = indentifiers
        setImage()
    }
    
    private func setImage(){
      
        let width = self.frame.width/4-50
        
        
        var tmpIdenfier:[String] = []
        var countforadding=0
        for tmp in identifierArray{
            tmpIdenfier.append(tmp)
            countforadding+=1
            if countforadding > 2{
                break
            }
        }
        CameraAndFileIOUtils.loadThumbnailFromIdentifier(identifier: tmpIdenfier, completion:{images in
            var count = 0
            for image in images{
                let tmpImageView = UIImageView()
                tmpImageView.image = image
                self.photoBaseView.addSubview(tmpImageView)
                
                tmpImageView.snp.makeConstraints { (make) -> Void in
                    make.top.equalToSuperview()
                    if self.imageViewArray.count == 0{
                        make.left.equalToSuperview()
                    }else{
                        make.left.equalTo(self.imageViewArray.last!.image.snp.right).offset(10)
                    }
                    make.width.equalTo(width)
                    make.height.equalTo(80)
                }
                
                tmpImageView.tag = count
                tmpImageView.isUserInteractionEnabled = true
                
                let longTap = UILongPressGestureRecognizer(target:self,action:#selector(self.imageViewLongTapped(_:)))
                tmpImageView.addGestureRecognizer(longTap)
                
                let tap = UITapGestureRecognizer(target:self,action:#selector(self.imageViewTapped(_:)))
                tmpImageView.addGestureRecognizer(tap)
                
                var tmp = ImageWithTag()
                tmp.image = tmpImageView
                tmp.identifier = tmpIdenfier[count]
                count += 1
                self.imageViewArray.append(tmp)

                
            }
            
  
            
        })
  
        let addImageView = UIImageView()
        addImageView.image = Icon.add
        self.photoBaseView.addSubview(addImageView)
        let tap = UITapGestureRecognizer(target:self,action:#selector(self.addImageViewTapped(_:)))
        addImageView.addGestureRecognizer(tap)
        addImageView.snp.makeConstraints({(make) -> Void in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(CGFloat(tmpIdenfier.count)*(width+CGFloat(10)))
            make.width.equalTo(width)
            make.height.equalTo(80)
        })
    
        
    }
    private func getData(index:Int)->(indentifier:String,image:UIImageView){
        return (imageViewArray[index].identifier,imageViewArray[index].image)
    }
    
    
    func imageViewLongTapped(_ sender:UILongPressGestureRecognizer){
        if sender.state == .ended && sender.view != nil{
            let ident = getData(index: (sender.view?.tag)!).indentifier
            self.delegate.didLongTappTableViewMemoImageView(imageIdentifier:ident,indexPath: indexPath)
        }
    }
    func imageViewTapped(_ sender:UITapGestureRecognizer){   //選択した画像と表示する画像がずれるのはselectedImageIndexがずれるから。　写真のロードが終わる時間はそれぞれちがうので・・・　　　さあどう解決しよう
        delegate.didTappTableViewMemoImageView(identifierArray:identifierArray,selectedImageIndex:(sender.view?.tag)!,indexPath: indexPath)
    }
    func addImageViewTapped(_ sender:UITapGestureRecognizer){
        print("add iamge view tapped")
    }

}
