//
//  SetDeviceName.swift
//  Cowa
//
//  Created by gaojun on 2017/9/15.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit

class SetDeviceName: UIView , UITextFieldDelegate{

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var sureBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = NSLocalizedString("ChangName", comment: "")
        subTitleLabel.text = NSLocalizedString("PleaseInput", comment: "")
        
        cancelBtn.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        sureBtn.setTitle(NSLocalizedString("Sure", comment: ""), for: .normal)
        
        let view1 = UIView.init(frame: CGRect(x:0,y:0,width:5,height:30))
        view1.backgroundColor = UIColor.clear
        nameTF.leftView = view1
        nameTF.leftViewMode = .always
    }
    
    @IBAction func commitAction(_ sender: Any) {
        
        ProgressAnimateTool.tool.show(inView: self.superview!)
        
        if (nameTF.text?.characters.count)! > 0  {
            
            if (nameTF.text?.characters.count)! > 9 {
                ProgressAnimateTool.tool.dismiss()
                MyInfoTool.tool.showInView(supView: self.superview!, title: NSLocalizedString("BoxNameCount", comment: ""))
             
                
            }else{
                _ = TDeviceManager.shared().updateBagInfo("CR " + (nameTF.text)!, imei: TBLEManager.sharedManager.dev?.status.imeiString, comp: { (result) in
                    ProgressAnimateTool.tool.dismiss()
                    if result.code == "2000"{
                        
                        let dev = TBLEManager.sharedManager.dev
                        dev?.status.changePerNameAndPwd(withName: self.nameTF.text)
                        
                        TUser.boxName("CR " + (self.nameTF.text)!)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "changeHomePageDeviceName"), object: nil)
                        
                        MyInfoTool.tool.showInView(supView: self.superview!, title: NSLocalizedString("DeviceModified", comment: ""))
                        
                        let time = DispatchTime.now() + Double(Int64(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
                        DispatchQueue.main.asyncAfter(deadline: time) {
                            PopTool.tool.dismiss()
                        }
                       
                    }else{
                        MyInfoTool.tool.showInView(supView: self.superview!, title: NSLocalizedString("DeviceModificationFailed", comment: ""))
                       
                    }
                })
            }
            
        }else{
            ProgressAnimateTool.tool.dismiss()
            
            MyInfoTool.tool.showInView(supView: self.superview!, title: NSLocalizedString("AccountCheckYourInput", comment: ""))
       
        }
        
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        
        PopTool.tool.dismiss()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTF.resignFirstResponder()
        
        return true
    }
}
