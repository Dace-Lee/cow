//
//  SignOut.swift
//  Cowa
//
//  Created by gaojun on 2017/9/12.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit
import CowaBLELib

class SignOut: UIView {

   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var commitBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = NSLocalizedString("MenuSignOutAvoid", comment: "")
        
        
        cancelBtn.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        commitBtn.setTitle(NSLocalizedString("Sure", comment: ""), for: .normal)
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        PopTool.tool.dismiss()
    }
    
    @IBAction func commitAction(_ sender: Any) {
        
        PopTool.tool.dismiss()
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "SignOutAccount"), object: nil)
        
    }
    
}
