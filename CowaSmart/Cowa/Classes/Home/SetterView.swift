//
//  SetterView.swift
//  Cowa
//
//  Created by gaojun on 2017/9/11.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit

class SetterView: UIView {

//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var followTitleLabel: UILabel!
    @IBOutlet weak var lampTitleLabel: UILabel!
//    @IBOutlet weak var alertTitleLabel: UILabel!
//
//    @IBOutlet weak var followSlider: UISlider!
//    @IBOutlet weak var followView: UIView!
//
//    @IBOutlet weak var labelOne: UILabel!
//    @IBOutlet weak var labelTwo: UILabel!
//    @IBOutlet weak var labelThree: UILabel!
//    @IBOutlet weak var labelFour: UILabel!
//    @IBOutlet weak var labelFive: UILabel!
//    @IBOutlet weak var labelSix: UILabel!
    
    
    @IBOutlet weak var blueBtn: UIButton!
    @IBOutlet weak var greenBtn: UIButton!
    @IBOutlet weak var redBtn: UIButton!
    @IBOutlet weak var noneColorBtn: UIButton!
    
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var noneLabel: UILabel!
    
//
//    @IBOutlet weak var alertSlider: UISlider!
//    @IBOutlet weak var alertView: UIView!
//
//    @IBOutlet weak var labelOne1: UILabel!
//    @IBOutlet weak var labelTwo2: UILabel!
//    @IBOutlet weak var labelThree3: UILabel!
//    @IBOutlet weak var labelFour4: UILabel!
//    @IBOutlet weak var labelFive5: UILabel!
//    @IBOutlet weak var labelSix6: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configUI()
    }
    
    func configUI(){
        
        //titleLabel.text = NSLocalizedString("parameterSet", comment: "")
        //followTitleLabel.text = NSLocalizedString("followDistanceSet", comment: "")
        lampTitleLabel.text = NSLocalizedString("breathSet", comment: "")
        //alertTitleLabel.text = NSLocalizedString("AlertAvoid", comment: "")
        
        blueLabel.text = NSLocalizedString("SettingContentLightForGuestColorBlue", comment: "")
        greenLabel.text = NSLocalizedString("SettingContentLightForGuestColorGreen", comment: "")
        redLabel.text = NSLocalizedString("SettingContentLightForGuestColorRed", comment: "")
        noneLabel.text = NSLocalizedString("None", comment: "")
        
//        followSlider.minimumValue = 0.4
//        followSlider.maximumValue = 1.1
//        followSlider.setThumbImage(UIImage(named:"跟随距离按钮"), for: .normal)
//
//        alertSlider.minimumValue = -0.8
//        alertSlider.maximumValue = 11.8
//        alertSlider.setThumbImage(UIImage(named:"报警距离按钮"), for: .normal)
        
        
        //setDot()
    }
    
//    func setDot(){
//
//        let lineImageView = UIImageView.init(frame: CGRect(x:2,y:followSlider.frame.size.height/2 - 1, width:230, height:2))
//        lineImageView.image = UIImage(named:"距离设置-线条")
//
//        let xArray1 = [48.5,75.7,103.5,130.5,158.5,185.5]
//
//        for i in 0...5 {
//            let imageView = UIImageView.init(frame: CGRect(x:xArray1[i], y:-1.5, width:5, height:5))
//            imageView.image = UIImage(named:"距离设置-小圆点")
//
//            lineImageView.addSubview(imageView)
//
//        }
//
//        followSlider.addSubview(lineImageView)
//
//
//        let lineImageView2 = UIImageView.init(frame: CGRect(x:2,y:alertSlider.frame.size.height/2 - 1, width:230, height:2))
//        lineImageView2.image = UIImage(named:"距离设置-线条")
//
//        let xArray2 = [48.5,63.5,94.5,124.5,155.5,185.5]
//
//        for i in 0...5 {
//            let imageView = UIImageView.init(frame: CGRect(x:xArray2[i], y:-1.5, width:5, height:5))
//            imageView.image = UIImage(named:"距离设置-小圆点")
//
//            lineImageView2.addSubview(imageView)
//
//        }
//
//        alertSlider.addSubview(lineImageView2)
//
//        initSliderValue()
//
//    }
    
//    func initSliderValue(){
//        followSlider.setValue(0.5, animated: true)
//        alertSlider.setValue(1.0, animated: true)
//    }
    
    func numberFormat(num:Float,format:String) -> String{
        let formater:NumberFormatter = NumberFormatter()
        formater.positiveFormat = format
        return formater.string(from: NSNumber.init(floatLiteral: Double(num)))!
    }
    
//    @IBAction func followSliderAction(_ sender: Any) {
//        let slider = sender as! UISlider
//        var valueStr = "0.0"
//        if slider.value < 0.5 {
//            valueStr = "0.5"
//        }else if slider.value > 1.0{
//            valueStr = "1.0"
//        }else{
//            valueStr = numberFormat(num: slider.value, format: "0.0")
//        }
//        followSlider.setValue(Float(valueStr)!, animated: true)
//
//        if Float(valueStr) == 0.5 {
//            labelOne.isHidden = false
//            labelTwo.isHidden = true
//            labelThree.isHidden = true
//            labelFour.isHidden = true
//            labelFive.isHidden = true
//            labelSix.isHidden = true
//        }else if Float(valueStr) == 0.6{
//            labelOne.isHidden = true
//            labelTwo.isHidden = false
//            labelThree.isHidden = true
//            labelFour.isHidden = true
//            labelFive.isHidden = true
//            labelSix.isHidden = true
//        }else if Float(valueStr) == 0.7{
//            labelOne.isHidden = true
//            labelTwo.isHidden = true
//            labelThree.isHidden = false
//            labelFour.isHidden = true
//            labelFive.isHidden = true
//            labelSix.isHidden = true
//        }else if Float(valueStr) == 0.8{
//            labelOne.isHidden = true
//            labelTwo.isHidden = true
//            labelThree.isHidden = true
//            labelFour.isHidden = false
//            labelFive.isHidden = true
//            labelSix.isHidden = true
//        }else if Float(valueStr) == 0.9{
//            labelOne.isHidden = true
//            labelTwo.isHidden = true
//            labelThree.isHidden = true
//            labelFour.isHidden = true
//            labelFive.isHidden = false
//            labelSix.isHidden = true
//        }else if Float(valueStr) == 1.0{
//            labelOne.isHidden = true
//            labelTwo.isHidden = true
//            labelThree.isHidden = true
//            labelFour.isHidden = true
//            labelFive.isHidden = true
//            labelSix.isHidden = false
//        }
//
//        TBLEManager.sharedManager.dev?.status.followDistanceSet(withValue: Int32(Int(Float(valueStr)! * 1000)))
//    }
//
 
    @IBAction func blueBtnAction(_ sender: Any) {
        
        blueBtn.isSelected = true
        redBtn.isSelected = false
        greenBtn.isSelected = false
        noneColorBtn.isSelected = false
        
        blueLabel.textColor = UIColor.init(red: 16/255, green: 136/255, blue: 204/255, alpha: 1.0)
        greenLabel.textColor = UIColor.init(red: 109/255, green: 148/255, blue: 179/255, alpha: 1.0)
        redLabel.textColor = UIColor.init(red: 109/255, green: 148/255, blue: 179/255, alpha: 1.0)
        noneLabel.textColor = UIColor.init(red: 109/255, green: 148/255, blue: 179/255, alpha: 1.0)
        
        TBLEManager.sharedManager.dev?.status.setBreath(.blue)
    }
    
    @IBAction func greenBtnAction(_ sender: Any) {
        
        blueBtn.isSelected = false
        redBtn.isSelected = false
        greenBtn.isSelected = true
        noneColorBtn.isSelected = false
        
        blueLabel.textColor = UIColor.init(red: 109/255, green: 148/255, blue: 179/255, alpha: 1.0)
        greenLabel.textColor = UIColor.init(red: 26/255, green: 138/255, blue: 41/255, alpha: 1.0)
        redLabel.textColor = UIColor.init(red: 109/255, green: 148/255, blue: 179/255, alpha: 1.0)
        noneLabel.textColor = UIColor.init(red: 109/255, green: 148/255, blue: 179/255, alpha: 1.0)
        
        TBLEManager.sharedManager.dev?.status.setBreath(.green)
    }
    
    @IBAction func redBtnAction(_ sender: Any) {
        
        blueBtn.isSelected = false
        redBtn.isSelected = true
        greenBtn.isSelected = false
        noneColorBtn.isSelected = false
        
        blueLabel.textColor = UIColor.init(red: 109/255, green: 148/255, blue: 179/255, alpha: 1.0)
        greenLabel.textColor = UIColor.init(red: 109/255, green: 148/255, blue: 179/255, alpha: 1.0)
        redLabel.textColor = UIColor.init(red: 201/255, green: 0/255, blue: 5/255, alpha: 1.0)
        noneLabel.textColor = UIColor.init(red: 109/255, green: 148/255, blue: 179/255, alpha: 1.0)
        
        TBLEManager.sharedManager.dev?.status.setBreath(.red)
    }
    
    @IBAction func noneColorBtnAction(_ sender: Any) {
        
        blueBtn.isSelected = false
        redBtn.isSelected = false
        greenBtn.isSelected = false
        noneColorBtn.isSelected = true
        
        blueLabel.textColor = UIColor.init(red: 109/255, green: 148/255, blue: 179/255, alpha: 1.0)
        greenLabel.textColor = UIColor.init(red: 109/255, green: 148/255, blue: 179/255, alpha: 1.0)
        redLabel.textColor = UIColor.init(red: 109/255, green: 148/255, blue: 179/255, alpha: 1.0)
        noneLabel.textColor = UIColor.init(red: 167/255, green: 167/255, blue: 167/255, alpha: 1.0)
        
        TBLEManager.sharedManager.dev?.status.setBreath(.close)
    }
    
//    @IBAction func alertSliderAction(_ sender: Any) {
//        let slider = sender as! UISlider
//        var valueStr = "0.0"
//        if slider.value < 1.0{
//            valueStr = "1"
//        }else if slider.value > 10.0{
//            valueStr = "10"
//        }else{
//            valueStr = numberFormat(num: slider.value, format: "0")
//        }
//
//        if valueStr == "3"{
//            valueStr = "4"
//        }
//
//        if valueStr == "5"{
//            valueStr = "6"
//        }
//
//        if valueStr == "7"{
//            valueStr = "8"
//        }
//
//        if valueStr == "9"{
//            valueStr = "10"
//        }
//
//        alertSlider.setValue(Float(valueStr)!, animated: true)
//
//        if Float(valueStr) == 1 {
//            labelOne1.isHidden = false
//            labelTwo2.isHidden = true
//            labelThree3.isHidden = true
//            labelFour4.isHidden = true
//            labelFive5.isHidden = true
//            labelSix6.isHidden = true
//        }else if Float(valueStr) == 2{
//            labelOne1.isHidden = true
//            labelTwo2.isHidden = false
//            labelThree3.isHidden = true
//            labelFour4.isHidden = true
//            labelFive5.isHidden = true
//            labelSix6.isHidden = true
//        }else if Float(valueStr) == 4{
//            labelOne1.isHidden = true
//            labelTwo2.isHidden = true
//            labelThree3.isHidden = false
//            labelFour4.isHidden = true
//            labelFive5.isHidden = true
//            labelSix6.isHidden = true
//        }else if Float(valueStr) == 6{
//            labelOne1.isHidden = true
//            labelTwo2.isHidden = true
//            labelThree3.isHidden = true
//            labelFour4.isHidden = false
//            labelFive5.isHidden = true
//            labelSix6.isHidden = true
//        }else if Float(valueStr) == 8{
//            labelOne1.isHidden = true
//            labelTwo2.isHidden = true
//            labelThree3.isHidden = true
//            labelFour4.isHidden = true
//            labelFive5.isHidden = false
//            labelSix6.isHidden = true
//        }else if Float(valueStr) == 10{
//            labelOne1.isHidden = true
//            labelTwo2.isHidden = true
//            labelThree3.isHidden = true
//            labelFour4.isHidden = true
//            labelFive5.isHidden = true
//            labelSix6.isHidden = false
//        }
//
//
//        TBLEManager.sharedManager.dev?.status.alertDistanceSet(withValue: Int32(Int(Float(valueStr)! * 1000)))
//
//    }

}
