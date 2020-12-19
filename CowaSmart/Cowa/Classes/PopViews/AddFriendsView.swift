//
//  AddFriendsView.swift
//  Cowa
//
//  Created by gaojun on 2017/9/12.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit

protocol AddFriendOKDelegate {
    func refreshFriendList()
}

class AddFriendsView: UIView , UITextFieldDelegate{

    var delegate:AddFriendOKDelegate?
    
    var imeiStr = ""
    
    @IBOutlet weak var numTF: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var phoneTitleLabel: UILabel!
    @IBOutlet weak var commitBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        numTF.placeholder = NSLocalizedString("AccountEnterPhoneNumber", comment: "")
        titleLabel.text = NSLocalizedString("AddBindFriends", comment: "")
        subTitleLabel.text = NSLocalizedString("AddFriendSub", comment: "")
        phoneTitleLabel.text = NSLocalizedString("AccountPhone", comment: "")
        commitBtn.setTitle(NSLocalizedString("Sure", comment: ""), for: .normal)
        
        let view1 = UIView.init(frame: CGRect(x:0,y:0,width:5,height:30))
        view1.backgroundColor = UIColor.clear
        numTF.leftView = view1
        numTF.leftViewMode = .always
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        PopTool.tool.dismiss()
    }
    
    @IBAction func commitBtnAction(_ sender: Any) {
        ProgressAnimateTool.tool.show(inView: self.superview!)
        if numTF.text?.count == 0 || numTF.text == TUser.userPhone() {
            ProgressAnimateTool.tool.dismiss()
            MyInfoTool.tool.showInView(supView: self.superview!, title: NSLocalizedString("AccountCheckYourInput", comment: ""))
        }else{
            
            _ = TDeviceManager.shared().addFriend(TUser.userPhone(), imei: imeiStr, publicUser: numTF.text, comp: { (result) in
                
                ProgressAnimateTool.tool.dismiss()
                
                if result.code == "2000" {
                    
                    MyInfoTool.tool.showInView(supView: self.superview!, title: NSLocalizedString("AuthSuccess", comment: ""))
                    
                    let time = DispatchTime.now() + Double(Int64(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: time) {
                        PopTool.tool.dismiss()
                    
                    }
                    
                    self.delegate?.refreshFriendList()
                    
                }else if result.code == "2003"{
                    MyInfoTool.tool.showInView(supView: self.superview!, title: NSLocalizedString("HasNoUser", comment: ""))
              
                }else{
                    MyInfoTool.tool.showInView(supView: self.superview!, title: NSLocalizedString("AuthFalse", comment: ""))
                   
                }
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        numTF.resignFirstResponder()
        
        return true
    }

}
