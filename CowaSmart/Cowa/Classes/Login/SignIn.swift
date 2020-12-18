//
//  SignIn.swift
//  Cowa
//
//  Created by MX on 16/5/6.
//  Copyright © 2016年 MX. All rights reserved.
//

import UIKit
import DynamicButton


class SignIn: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var findPWDBtn: UIButton!
    @IBOutlet weak var numTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageV = UIImageView(image: UIImage(named:"登录页面-背景图"))
        imageV.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        view.insertSubview(imageV, at: 0)
        
        titleLabel.text = NSLocalizedString("AccountSignIn", comment: "")
        findPWDBtn.setTitle(NSLocalizedString("FindYourPWD", comment: ""), for: .normal)
        loginBtn.setTitle(NSLocalizedString("AccountSignIn", comment: ""), for: .normal)
        numLabel.text = NSLocalizedString("AccountPhone", comment: "")
        passwordLabel.text = NSLocalizedString("AccountPassword", comment: "")
        numTF.placeholder = NSLocalizedString("AccountEnterPhoneNumber", comment: "")
        numTF.tintColor = UIColor.init(red: 109/255, green: 148/255, blue: 179/255, alpha: 1.0)
        passwordTF.placeholder = NSLocalizedString("AccountEnterPassword", comment: "")
        passwordTF.tintColor = UIColor.init(red: 109/255, green: 148/255, blue: 179/255, alpha: 1.0)
        
        
//        let backBtn = UIButton.init(type: .custom)
//        backBtn.frame = CGRect(x:26,y:34,width:20,height:20)
//        backBtn.setImage(UIImage(named:"后退箭头"), for: .normal)
//        backBtn.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
//        view.addSubview(backBtn)

        createNavi()
    }
    
    func createNavi(){
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        
        let imageView = UIImageView.init(frame: CGRect(x:0,y:0,width:125,height:15))
        imageView.image = UIImage(named:"左侧栏LOGO")
        self.navigationItem.titleView = imageView
        
        let btn: DynamicButton? = DynamicButton.init(style: .caretLeft)
        btn?.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        btn?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btn?.strokeColor = UIColor.white
        let item1=UIBarButtonItem(customView: btn!)
        self.navigationItem.leftBarButtonItem = item1
    }
    
    @objc func popViewController(){
        numTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        
        ProgressAnimateTool.tool.show(inView: self.view)
        
        if numTF.text == "" || passwordTF.text == "" {
            
            ProgressAnimateTool.tool.dismiss()
            
            MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("AccountCheckYourInput", comment: ""))
           
        }else{
            let pwdStr = GJTool.getMD5Code(with: passwordTF.text)
            _ = LoginRegisterAbstract.login(numTF.text, pwd: pwdStr) { (result) in
                ProgressAnimateTool.tool.dismiss()
                if result.code == "2000" {
                    
                    MobClick.profileSignIn(withPUID: self.numTF.text)
                    
                    let tags = NSSet.init(object: self.numTF.text!)
                    JPUSHService.addTags(tags as! Set<String>, completion: nil, seq: 1)
                    
                    MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("LoginSuccess", comment: ""))
                    
                    self.navigationController?.dismiss(animated: false, completion: nil)
                }else if result.code == "2001"{
                    MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("HasNoUser", comment: ""))
                   
                }else if result.code == "2002" {
                    MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("MissMatch", comment: ""))
                
                }else{
                    NetURL.tool.updateHost()
                    NetURL.tool.initUrl()
                    _ = LoginRegisterAbstract.login(self.numTF.text, pwd: pwdStr) { (result) in
                        ProgressAnimateTool.tool.dismiss()
                        if result.code == "2000" {
                            
                            MobClick.profileSignIn(withPUID: self.numTF.text)
                            
                            let tags = NSSet.init(object: self.numTF.text!)
                            JPUSHService.addTags(tags as! Set<String>, completion: nil, seq: 1)
                            
                            MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("LoginSuccess", comment: ""))
                            
                            self.navigationController?.dismiss(animated: false, completion: nil)
                        }else if result.code == "2001"{
                            MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("HasNoUser", comment: ""))
                            
                        }else if result.code == "2002" {
                            MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("MissMatch", comment: ""))
                            
                        }else{
                            MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("SnackTipfailedToSignIn", comment: ""))
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        numTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
