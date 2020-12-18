//
//  BoxHasBeenBindView.swift
//  Cowa
//
//  Created by gaojun on 2017/9/13.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit
import CowaBLELib

class BoxHasBeenBindView: UIView {

    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var commitBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        subTitleLabel.text = NSLocalizedString("TheBagBeenBindAnother", comment: "")
        
        commitBtn.setTitle(NSLocalizedString("AplyBind", comment: ""), for: .normal)
    }
   
    @IBAction func cancelBtnAction(_ sender: Any) {
        
        PopTool.tool.dismiss()
        
        TBluetooth.share().cancelConnect(TBLEManager.sharedManager.dev?.status.device.peri)
        TBLEManager.sharedManager.connect(nil)
        
    }
    
    
    @IBAction func aplyBtnAction(_ sender: Any) {
        
        _ = LoginRegisterAbstract.requestAuthPIN(TUser.userPhone(), imei: TBLEManager.sharedManager.dev?.status.imeiString) { (result) in
            
            if result.code == "2000"{
                
                MyInfoTool.tool.showInView(supView: self.superview!, title: NSLocalizedString("SnackTipPINSent", comment: ""))
                
                let time = DispatchTime.now() + Double(Int64(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: time) {
                    PopTool.tool.dismiss()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showAplyBindView"), object: nil)
                }
                
            }else{
                MyInfoTool.tool.showInView(supView: self.superview!, title: NSLocalizedString("SnackTipFailToSentThePINPleaseRetryLater", comment: ""))
            }
            
        }
    }
    
}
