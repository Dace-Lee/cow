//
//  ResetPwdVC.swift
//  Cowa
//
//  Created by gaojun on 2017/9/14.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit
import DynamicButton

class ResetPwdVC: UIViewController, UITextFieldDelegate{

    
    @IBOutlet weak var oldPwdTF: UITextField!
    @IBOutlet weak var newPwdTF: UITextField!
    @IBOutlet weak var surePwdTF: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var currentPwdLabel: UILabel!
    @IBOutlet weak var newPwdLabel: UILabel!
    @IBOutlet weak var sureLabel: UILabel!
    @IBOutlet weak var commitBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        title = NSLocalizedString("AccountChangePassword", comment: "")
        let imageV = UIImageView(image: UIImage(named:"登录页面-背景图"))
        imageV.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        view.insertSubview(imageV, at: 0)
        
        titleLabel.text = NSLocalizedString("AccountChangePassword", comment: "")
        currentPwdLabel.text = NSLocalizedString("AccountCurrentPassword", comment: "")
        newPwdLabel.text = NSLocalizedString("AccountNewPassword", comment: "")
        sureLabel.text = NSLocalizedString("InputPwdAgain", comment: "")
        
        commitBtn.setTitle(NSLocalizedString("Sure", comment: ""), for: .normal)
        
        oldPwdTF.placeholder = NSLocalizedString("AccountEnterPassword", comment: "")
        newPwdTF.placeholder = NSLocalizedString("AccountEnterNewPassword", comment: "")
        surePwdTF.placeholder = NSLocalizedString("AccountConfirmPassword", comment: "")
        
        createNavi()
        
        
    }

    func createNavi(){
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        
        let btn: DynamicButton? = DynamicButton.init(style: .caretLeft)
        btn?.addTarget(self, action: #selector(leftBtnAction), for: .touchUpInside)
        btn?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btn?.strokeColor = UIColor.white
        let item1=UIBarButtonItem(customView: btn!)
        self.navigationItem.leftBarButtonItem = item1
    }
    
    @objc func leftBtnAction(){
        oldPwdTF.resignFirstResponder()
        newPwdTF.resignFirstResponder()
        surePwdTF.resignFirstResponder()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        oldPwdTF.resignFirstResponder()
        newPwdTF.resignFirstResponder()
        surePwdTF.resignFirstResponder()
        
        return true
    }

    @IBAction func commitBtnAction(_ sender: Any) {
        ProgressAnimateTool.tool.show(inView: self.view)
        if (newPwdTF.text != surePwdTF.text) || oldPwdTF.text == "" || newPwdTF.text == "" || surePwdTF.text == ""{
            ProgressAnimateTool.tool.dismiss()
            MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("AccountCheckYourInput", comment: ""))
          
        }else{
            let oldPwd = GJTool.getMD5Code(with: oldPwdTF.text)
            let newPwd = GJTool.getMD5Code(with: newPwdTF.text)
            _ = LoginRegisterAbstract.resetPwd(TUser.userPhone(),old:oldPwd!, new: newPwd!, comp: { (result) in
                ProgressAnimateTool.tool.dismiss()
                if result.code == "2000" {
                    
                 
                    MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("SetPwdOK", comment: ""))
                    
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("SetPwdFalse", comment: ""))
                  
                }
            })
        }
        
    }
}
