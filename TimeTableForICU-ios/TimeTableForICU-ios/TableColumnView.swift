//
//  TableColumnView.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/12/13.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import UIKit
import SnapKit



class TableColumnView: UIView {
    
    @IBOutlet weak var button1: TopRightBorderButton!
    @IBOutlet weak var button2: TopRightBorderButton!
    @IBOutlet weak var button3: TopRightBorderButton!
    @IBOutlet weak var button4: TopRightBorderButton!
    @IBOutlet weak var button5: TopRightBorderButton!
    @IBOutlet weak var button6: TopRightBorderButton!
    @IBOutlet weak var button7: TopRightBorderButton!
    @IBOutlet weak var button8: TopRightBorderButton!

    @IBOutlet weak var label: UILabel!
    
    var buttonArray:[TopRightBorderButton]!
   // var tableData:[TableDataEntity]!
    var week:columnWeek = .mon
    var sizeOfEachButton : [CGFloat] = [CGFloat(10),CGFloat(10),CGFloat(10),CGFloat(10),CGFloat(10),CGFloat(10),CGFloat(10),CGFloat(10)]
    var numOfConnectingButtons: [Int] = [1,1,1,1,1,1,1,1]
    
  
    var isL4 = false
    var isPeriod8Visible = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      //  comminInit()
    }
    
    // Storyboard/xib から初期化はここから
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       // comminInit()
    }
    
    override func awakeFromNib() {
        comminInit()
    }
    
    func showPeriod8(show :Bool){
        isPeriod8Visible = show
        self.setNeedsLayout()
    }
    func l4Available(l4:Bool){
        isL4 = l4
        self.setNeedsLayout()
    }
    func setData(tableData:[TableDataEntity],viewCon:ViewController,fontSize:Int){
        let lang = Language.init(lang: UserDefaultManager.loadDefaultLanguage())
        var periodNum = 0
        for periodButton in buttonArray{
            let button = periodButton.button
            if lang == .jp{
                button?.setTitle(tableData[periodNum].jTitle + "\n\n" + tableData[periodNum].classRoom, for: UIControlState.normal)
            }else{
                button?.setTitle(tableData[periodNum].eTitle + "\n\n" + tableData[periodNum].classRoom, for: UIControlState.normal)
            }
            
            button?.titleLabel?.font=UIFont.systemFont(ofSize:CGFloat(fontSize))
            button?.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            button?.titleLabel?.numberOfLines=0
            button?.titleLabel?.textAlignment = .center
            button?.setTitleColor(UIColor.black, for: UIControlState.normal)
            button?.backgroundColor = UIColor(hex:tableData[periodNum].color)
            button?.tag = (periodNum+1)*10 + week.rawValue
            button?.addTarget(viewCon, action: #selector(viewCon.tableButtonTouched(sender:)), for: .touchUpInside)
            if tableData[periodNum].L4 == TableStatus.L4.rawValue{
                l4Available(l4: true)
            }
            if periodNum < buttonArray.count-1 && periodNum != 2{      //配列の最後と、３限は次のコマと接続しないのでパス
                if tableData[periodNum].rgno == tableData[periodNum+1].rgno && tableData[periodNum].rgno != TableStatus.initRgno.rawValue{
                    periodButton.isConnectWithNextButton = true
                }else{
                    periodButton.isConnectWithNextButton = false
                }
            }
            periodNum+=1
        }
    }
 
    override func updateConstraints() {
        
        super.updateConstraints()
        
    }
    

    
    //indexで渡した添字のボタンから何個連なってるか再帰的にカウント
    private func countConnectingButtons(index : Int, max : Int) -> Int{  // maxは、１〜３限、４〜８限でセパレートするためのもの
        var button = buttonArray[index]
        var returnVal = 1
        
        if button.isConnectWithNextButton == true {
            if index+1<=max{
                returnVal += countConnectingButtons(index: index+1,max: max)
            }
        }
        return returnVal
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()                             //こっからそれぞれのコマのサイズを決める
        let width = self.bounds.width
        let height = self.bounds.height
        var eachHeight=(height-40)/8

        if isPeriod8Visible{
            eachHeight=(height-40)/8
        }else{
            eachHeight=(height-40)/7
        }
        
        for i in 0..<sizeOfEachButton.count{
            sizeOfEachButton[i]=eachHeight
            buttonArray[i].isHidden = false
        }
    
        for i in 0..<3{
            numOfConnectingButtons[i] = countConnectingButtons(index: i, max: 8)
            sizeOfEachButton[i] = sizeOfEachButton[i]*CGFloat(numOfConnectingButtons[i])
            for j in 1..<numOfConnectingButtons[i]{
                sizeOfEachButton[j+i]=0
                buttonArray[i+j].isHidden = true
            }
        }
  
        
        for i in 3..<buttonArray.count{
            numOfConnectingButtons[i] = countConnectingButtons(index: i, max: 8)
            sizeOfEachButton[i] = sizeOfEachButton[i]*CGFloat(numOfConnectingButtons[i])
            for j in 1..<numOfConnectingButtons[i]{
                sizeOfEachButton[j+i]=0
                buttonArray[i+j].isHidden = true
            }
        }
        print("")
        print("sizeOfEachButtons　: week : \(week.rawValue)")
        for tmp in sizeOfEachButton{
            print(tmp)
        }
                                                    //こっからはconstraintsを設定
        if isL4{
            sizeOfEachButton[3]+=20
            label.snp.updateConstraints{(make)->Void in
                make.top.equalTo(sizeOfEachButton[0]+sizeOfEachButton[1]+sizeOfEachButton[2])
                make.right.equalTo(0)
                make.size.equalTo(CGSize(width: width, height: 20))
            }
        }else{
            label.snp.updateConstraints{(make)->Void in
                make.top.equalTo(sizeOfEachButton[0]+sizeOfEachButton[1]+sizeOfEachButton[2])
                make.right.equalTo(0)
                make.size.equalTo(CGSize(width: width, height: 40))
            }

        }
        
        
        for i in 0..<buttonArray.count{
            buttonArray[i].snp.updateConstraints{(make)->Void in
                var sum=CGFloat(0)
                for j in 0..<i{
                    sum+=sizeOfEachButton[j]
                }
                if i>2{
                    if isL4{
                        sum+=20
                    }else{
                        sum+=40
                    }
                }
                make.top.equalTo(sum)
                make.right.equalTo(0)
                make.size.equalTo(CGSize(width: width, height: sizeOfEachButton[i]))
            }
            print("size of eachButton \(i) : \(sizeOfEachButton[i])")
            if sizeOfEachButton[i] == 0{
                buttonArray[i].isHidden = true
            }else{
                buttonArray[i].isHidden = false
            }
        }
        
     
    }
    
    
    
    private func comminInit() {
        
        // MyCustomView.xib からカスタムViewをロードする
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TableColumnView", bundle: bundle)
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
        
        
        buttonArray = [button1,button2,button3,button4,button5,button6,button7,button8]
        
        label.backgroundColor=UIColor.gray
        for button in buttonArray{
            button.button.setTitle("", for: .normal)
        }
        
        
    }
    
   


}
