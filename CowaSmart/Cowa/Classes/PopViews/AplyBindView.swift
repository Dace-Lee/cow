//
//  AplyBindView.swift
//  Cowa
//
//  Created by gaojun on 2017/9/14.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit
import CowaBLELib

class AplyBindView: UIView, UITextFieldDelegate{

    let timeLength = 60
    var currentTime = 0
    var timer: Timer?
    var isWorking:Bool = false
    var hostNum = ""
    
    @IBOutlet weak var smsBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var smsLabel: UILabel!
    @IBOutlet weak var commitBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = NSLocalizedString("AplyBind", comment: "")
         subtitleLabel.text = NSLocalizedString("ReplyBindSub", comment: "")
         smsLabel.text = NSLocalizedString("AccountPIN", comment: "")
        commitBtn.setTitle(NSLocalizedString("Sure", comment: ""), for: .normal)
        smsBtn.setTitle(NSLocalizedString("Get", comment: ""), for: .normal)
        
        textField.placeholder = NSLocalizedString("InputSmsCode", comment: "")
        let view1 = UIView.init(frame: CGRect(x:0,y:0,width:5,height:30))
        view1.backgroundColor = UIColor.clear
        textField.leftView = view1
        textField.leftViewMode = .always
        
        restore()
    }
    
    @IBAction func commitAction(_ sender: Any) {
        ProgressAnimateTool.tool.show(inView: self.superview!)
        if textField.text?.count == 0 {
            ProgressAnimateTool.tool.dismiss()
            
            MyInfoTool.tool.showInView(supView: self.superview!, title: NSLocalizedString("AccountCheckYourInput", comment: ""))
        
        }else{
            
            _ = TDeviceManager.shared().replyBondBag(hostNum, imei: TBLEManager.sharedManager.dev?.status.imeiString, publicUser: TUser.userPhone(), verify:textField.text, comp: { (result) in
                
                
                if result.code == "2000"{
                    
                    
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "stopSendStatus"), object: nil)
                    
                    let dev = TBLEManager.sharedManager.dev
                    dev?.status.auth(withHostNum: self.hostNum)
                    
                }else{
                    ProgressAnimateTool.tool.dismiss()
                    MyInfoTool.tool.showInView(supView: self.superview!, title: NSLocalizedString("AplyBondFalse", comment: ""))
                   
                }
            })
        }
        
    }
    
    @IBAction func smsBtnAction(_ sender: Any) {
        
        if !isWorking{
            getSmsCode()
        }
        
    }
    
    func getSmsCode(){
        _ = LoginRegisterAbstract.requestAuthPIN(TUser.userPhone(), imei: TBLEManager.sharedManager.dev?.status.imeiString) { (result) in
            
            
            if result.code == "2000"{
                
                self.isWorking = true
                
                 self.timerChangeStatus(true)
                
                 MyInfoTool.tool.showInView(supView: self.superview!, title: NSLocalizedString("SnackTipPINSent", comment: ""))
                
            }else{
                 MyInfoTool.tool.showInView(supView: self.superview!, title: NSLocalizedString("SnackTipFailToSentThePINPleaseRetryLater", comment: ""))
               
                self.restore2()
                self.smsBtn.setTitle(NSLocalizedString("GetPinButton", comment: ""), for: UIControl.State())
            }
            
        }
    }
    
    
    func restore() {
        currentTime = timeLength
        timerChangeStatus(true)
    }
    
    func timerChangeStatus(_ fire: Bool) {
        if fire {
            if timer == nil {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(clockEvent), userInfo: nil, repeats: true)
            }
        } else {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func clockEvent() {
        update()
        if currentTime <= 0 {
            restore2()
            self.smsBtn.setTitle(NSLocalizedString("GetPinButton", comment: ""), for: UIControl.State())
            
        }
        currentTime -= 1
    }
    
    @objc fileprivate func update() {
        smsBtn.setTitle("\(currentTime)s", for: UIControl.State())
    }
    
    func restore2() {
        isWorking = false
        currentTime = timeLength
        timerChangeStatus(false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        
        return true
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        PopTool.tool.dismiss()
        
        TBluetooth.share().cancelConnect(TBLEManager.sharedManager.dev?.status.device.peri)
        TBLEManager.sharedManager.connect(nil)
    }
    

}
