//
//  MyAccountVC.swift
//  Cowa
//
//  Created by gaojun on 2017/9/14.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit

class MyAccountVC: SubVC, UITextFieldDelegate{

    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var pwdLabel: UILabel!
    @IBOutlet weak var commitBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let imageV = UIImageView(image: UIImage(named:"登录页面-背景图"))
        imageV.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        view.insertSubview(imageV, at: 0)
        
        titleLabel.text = NSLocalizedString("MenuMyAccount", comment: "")
        nameLabel.text = NSLocalizedString("Mingcheng", comment: "")
        phoneLabel.text = NSLocalizedString("AccountPhone", comment: "")
        pwdLabel.text = NSLocalizedString("AccountPassword", comment: "")
        commitBtn.setTitle(NSLocalizedString("Sure", comment: ""), for: .normal)
        nameTF.placeholder = NSLocalizedString("AccountNameTFPH", comment: "")
        
        self.isNavRoot = true
        createNavi()
    
        nameTF.text = TUser.userNickName()
        numLabel.text = TUser.userPhone()
        
    }
    
    func createNavi(){
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        
        title = NSLocalizedString("MenuMyAccount", comment: "")
    }

    
    @IBAction func resetPwdAction(_ sender: Any) {
        
        let vc = ResetPwdVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func commitBtnAction(_ sender: Any) {
        ProgressAnimateTool.tool.show(inView: self.view)
        _ = LoginRegisterAbstract.setUserMes(TUser.userPhone(), name: nameTF.text) { (result) in
            ProgressAnimateTool.tool.dismiss()
            if result.code == "2000" {
                
                
                
                TUser.userNickName(self.nameTF.text)
                
                MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("DeviceModified", comment: ""))
            
            }else{
                MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("DeviceModificationFailed", comment: ""))
               
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTF.resignFirstResponder()
        
        return true
    }
    

}
