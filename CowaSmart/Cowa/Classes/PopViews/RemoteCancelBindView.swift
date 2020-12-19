//
//  RemoteCancelBindView.swift
//  Cowa
//
//  Created by gaojun on 2017/9/12.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit

protocol CancelBondOKDelegate {
    func refreshDeviceList()
}

class RemoteCancelBindView: UIView, UITextFieldDelegate{

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var smsBtn: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var smsLabel: UILabel!
    @IBOutlet weak var commitBtn: UIButton!
    
    
    var refreshDelegate:CancelBondOKDelegate?
    
    var timer: Timer?
    let timeLength = 60
    var currentTime = 0
    var isWorking:Bool = false
    
    var imeiStr:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = NSLocalizedString("CancelBond", comment: "")
        subtitleLabel.text = NSLocalizedString("CheckUser", comment: "")
        smsLabel.text = NSLocalizedString("AccountPIN", comment: "")
        commitBtn.setTitle(NSLocalizedString("Sure", comment: ""), for: .normal)
        smsBtn.setTitle(NSLocalizedString("Get", comment: ""), for: .normal)
        
        textField.placeholder = NSLocalizedString("InputSmsCode", comment: "")
        let view1 = UIView.init(frame: CGRect(x:0,y:0,width:5,height:30))
        view1.backgroundColor = UIColor.clear
        textField.leftView = view1
        textField.leftViewMode = .always
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        PopTool.tool.dismiss()
    }
    
    @IBAction func smsBtnAction(_ sender: Any) {
        
        
        if !isWorking{
            
            
            
            _ = LoginRegisterAbstract.requestRemotePIN(TUser.userPhone(), imei: imeiStr) { (result) in
                
                
                if result.code == "2000"{
                    
                    self.isWorking = true
                    
                    self.timerChangeStatus(true)
                    
                    MyInfoTool.tool.showInView(supView: self.superview!, title: NSLocalizedString("SnackTipPINSent", comment: ""))

                }else{
                    MyInfoTool.tool.showInView(supView: self.superview!, title: NSLocalizedString("SnackTipFailToSentThePINPleaseRetryLater", comment: ""))

                    self.restore()
                    self.smsBtn.setTitle(NSLocalizedString("GetPinButton", comment: ""), for: UIControl.State())
                }
                
            }
            
        }

        
    }
    
    func timerChangeStatus(_ fire: Bool) {
        if fire {
            if timer == nil {
                currentTime = timeLength
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
            restore()
        }
        currentTime -= 1
    }
    
    func update() {
        smsBtn.setTitle("\(currentTime)s", for: .normal)
    }
    
    func restore() {
        isWorking = false
        currentTime = timeLength
        smsBtn.setTitle(NSLocalizedString("AccountSendPIN", comment: ""), for: .normal)
        timerChangeStatus(false)
    }
    
    @IBAction func commitBtnAction(_ sender: Any) {
        ProgressAnimateTool.tool.show(inView: self.superview!)
        if (self.textField.text?.count)! > 0 {
          
            _ = TDeviceManager.shared().remoteCancelBond(TUser.userPhone(), verify: self.textField.text, imei: imeiStr, comp: { (result) in
          
                ProgressAnimateTool.tool.dismiss()
                
                if result.code == "2000"{
                    
                    MyInfoTool.tool.showInView(supView: self.superview!, title: NSLocalizedString("CancelBondOK", comment: ""))
                    
                    let time = DispatchTime.now() + Double(Int64(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: time) {
                        PopTool.tool.dismiss()
                        
                    }
                    
                    _ = TDeviceManager.shared().pushLocAndCancelBond(2, imei: self.imeiStr) { (result) in
                    }
                    
                    self.refreshDelegate?.refreshDeviceList()
                    
                }else{
                    
                    MyInfoTool.tool.showInView(supView: self.superview!, title: NSLocalizedString("CancelBondFalse", comment: ""))
                   
                }
            })
        }else {
            ProgressAnimateTool.tool.dismiss()
            MyInfoTool.tool.showInView(supView: self.superview!, title: NSLocalizedString("AccountCheckYourInput", comment: ""))
           
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        
        return true
    }
    

}
