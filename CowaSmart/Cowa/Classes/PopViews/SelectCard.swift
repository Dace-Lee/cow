//
//  SelectCard.swift
//  Cowa
//
//  Created by gaojun on 2017/9/12.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit


class SelectCard: UIView {

   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet var titleHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = NSLocalizedString("OpenFlyMode", comment: "")
        detailLabel.text = NSLocalizedString("OpenFlySub", comment: "")
        
        cancelBtn.setTitle(NSLocalizedString("Cancel", comment: ""), for: .normal)
        commitBtn.setTitle(NSLocalizedString("Sure", comment: ""), for: .normal)
        
        let lang = getLocalLanguage()
        if lang.hasPrefix("ko"){
            titleLabel.text = NSLocalizedString("OpenFlyMode", comment: "")
            detailLabel.text = ""
            
            self.titleHeight.constant = 50
        }
    }
    
    func getLocalLanguage() -> String{
        let defs = UserDefaults.standard
        let languages = defs.object(forKey: "AppleLanguages")
        let preferredLanguage = (languages! as AnyObject).object(at: 0)
        return String(describing: preferredLanguage)
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        PopTool.tool.dismiss()
    }
    
    @IBAction func commitAction(_ sender: Any) {
        
        PopTool.tool.dismiss()
        
        TBLEManager.sharedManager.dev?.status.powerOff()
        TBLEManager.sharedManager.dev?.status.powerOff()
        TBLEManager.sharedManager.dev?.status.powerOff()
        TBLEManager.sharedManager.dev?.status.powerOff()
        TBLEManager.sharedManager.dev?.status.powerOff()
        
    }
    
}
