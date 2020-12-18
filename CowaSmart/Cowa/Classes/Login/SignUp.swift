//
//  SignUp.swift
//  Cowa
//
//  Created by MX on 16/5/7.
//  Copyright © 2016年 MX. All rights reserved.
//

import UIKit
import DynamicButton

class SignUp: UIViewController,CountryCodeDelegate,UITextFieldDelegate{
    
    var smscode:String?
    var codeStr:String = "86"
    
    var timer: Timer?
    let timeLength = 60
    var currentTime = 0
    var isWorking:Bool = false
    
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var countryCodeBtn: UIButton!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var numTF: UITextField!
    @IBOutlet weak var smsCodeBtn: UIButton!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var smsCodeLabel: UILabel!
    @IBOutlet weak var smsCodeTF: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var countryCodeLabel: UILabel!
    
    
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
        
        registerLabel.text = NSLocalizedString("AccountSignUp", comment: "")
        countryCodeBtn.setTitle("China(86)", for: .normal)
        numLabel.text = NSLocalizedString("AccountPhone", comment: "")
        numTF.placeholder = NSLocalizedString("AccountEnterPhoneNumber", comment: "")
        smsCodeBtn.setTitle(NSLocalizedString("AccountSendPIN", comment: ""), for: .normal)
        passwordLabel.text = NSLocalizedString("AccountPassword", comment: "")
        passwordTF.placeholder = NSLocalizedString("AccountEnterPassword", comment: "")
        smsCodeLabel.text = NSLocalizedString("AccountPIN", comment: "")
        smsCodeTF.placeholder = NSLocalizedString("InputSmsCode", comment: "")
        registerBtn.setTitle(NSLocalizedString("AccountSignUp", comment: ""), for: .normal)

        
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
        smsCodeTF.resignFirstResponder()
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func countryCodeBtnAction(_ sender: Any) {
        let vc = CountryCodeSelect()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func smsCodeBtnAction(_ sender: Any) {
        
        if self.numTF.text == ""{
           
            MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("AccountCheckYourInput", comment: ""))
        }else{
            
            if !isWorking{
                
                let country = self.codeStr

                _ = LoginRegisterAbstract.requestPIN(numTF.text!, reqType: .register, country: country, comp: { (result) in
                    if result.code == "2000"{
                        self.isWorking = true
                        
                        self.timerChangeStatus(true)
                        
                        MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("SnackTipPINSent", comment: ""))
                        
                    }else{
                        MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("SnackTipFailToSentThePINPleaseRetryLater", comment: ""))
                        
                    }
                })
                
                
            }
            
            
        }
        
    }

    
    @IBAction func registerBtnAction(_ sender: Any) {
        ProgressAnimateTool.tool.show(inView: self.view)
        if numTF.text == "" || passwordTF.text == "" || smsCodeTF.text == "" {
            ProgressAnimateTool.tool.dismiss()
            MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("AccountCheckYourInput", comment: ""))
        
        }else{
            
            let pwdStr = GJTool.getMD5Code(with: passwordTF.text)
            _ = LoginRegisterAbstract.register(numTF.text!, pwd: pwdStr!, pinCode: smsCodeTF.text!,  country:codeStr) { (result) in
                ProgressAnimateTool.tool.dismiss()
                if result.code == "2000" {
                    _ = LoginRegisterAbstract.login(self.numTF.text, pwd: pwdStr, comp: { (r) in
                        if r.code == "2000" {
                            
                            MobClick.profileSignIn(withPUID: self.numTF.text)
                            
                            let tags = NSSet.init(object: self.numTF.text!)
                            JPUSHService.addTags(tags as! Set<String>, completion: nil, seq: 1)
                            MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("LoginSuccess", comment: ""))
                         
                            self.navigationController?.dismiss(animated: false, completion: nil)
                            
                        }else{
                            MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("SnackTipfailedToSignIn", comment: ""))
                          
                        }
                    })
                    
                }else if result.code == "2001"{
                    MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("SnackTipWrongPIN", comment: ""))
                 
                }else if result.code == "2002"{
                    MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("AlreadyRegister", comment: ""))
               
                }else{
                    NetURL.tool.updateHost()
                    NetURL.tool.initUrl()
                    
                    _ = LoginRegisterAbstract.register(self.numTF.text!, pwd: pwdStr!, pinCode: self.smsCodeTF.text!,  country:self.codeStr) { (result) in
                        ProgressAnimateTool.tool.dismiss()
                        if result.code == "2000" {
                            _ = LoginRegisterAbstract.login(self.numTF.text, pwd: pwdStr, comp: { (r) in
                                if r.code == "2000" {
                                    
                                    MobClick.profileSignIn(withPUID: self.numTF.text)
                                    
                                    let tags = NSSet.init(object: self.numTF.text!)
                                    JPUSHService.addTags(tags as! Set<String>, completion: nil, seq: 1)
                                    MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("LoginSuccess", comment: ""))
                                    
                                    self.navigationController?.dismiss(animated: false, completion: nil)
                                    
                                }else{
                                    MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("SnackTipfailedToSignIn", comment: ""))
                                    
                                }
                            })
                            
                        }else if result.code == "2001"{
                            MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("SnackTipWrongPIN", comment: ""))
                            
                        }else if result.code == "2002"{
                            MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("AlreadyRegister", comment: ""))
                            
                        }else{
                            MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("SnackTipRegisterationFailed", comment: ""))
                            
                        }
                    }
                  
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
        smsCodeBtn.setTitle("\(currentTime)s", for: .normal)
    }
    
    func restore() {
        isWorking = false
        currentTime = timeLength
        smsCodeBtn.setTitle(NSLocalizedString("AccountSendPIN", comment: ""), for: .normal)
        timerChangeStatus(false)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        numTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        smsCodeTF.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func sendCountryCode(_ code: String, country:String) -> String {
        countryCodeBtn.setTitle("\(country)(\(code))", for: UIControl.State())
        countryCodeLabel.text = "+\(code)"
        codeStr = code
        return code
    }
}
