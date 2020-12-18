//
//  DeviceListHeader.swift
//  Cowa
//
//  Created by gaojun on 2017/9/8.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit

class DeviceListHeader: UIView {

    
    @IBOutlet weak var bindDeviceLabel: UILabel!
    @IBOutlet weak var editBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bindDeviceLabel.text = NSLocalizedString("MyBindBags", comment: "")
        editBtn.setTitle(NSLocalizedString("Edit", comment: ""), for: .normal)
        editBtn.isSelected = false
    }
 
    @IBAction func editBtnAction(_ sender: Any) {
        let btn = sender as! UIButton
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            btn.setTitle(NSLocalizedString("Cancel", comment: ""), for: UIControlState())
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "editBtnAction"), object: nil)
        }else{
            btn.setTitle(NSLocalizedString("Edit", comment: ""), for: UIControlState())
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "cancelBtnAction"), object: nil)
        }
    }

}
