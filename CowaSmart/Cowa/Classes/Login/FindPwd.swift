//
//  FindPwd.swift
//  Cowa
//
//  Created by MX on 16/5/16.
//  Copyright © 2016年 MX. All rights reserved.
//

import UIKit
import DynamicButton

class FindPwd: UIViewController,CountryCodeDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countryCodeBtn: UIButton!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var numTF: UITextField!
    @IBOutlet weak var smsCodeBtn: UIButton!
    @IBOutlet weak var smsCodeLabel: UILabel!
    @IBOutlet weak var smsCodeTF: UITextField!
    @IBOutlet weak var nrePwdLabel: UILabel!
    @IBOutlet weak var newPwdTF: UITextField!
    @IBOutlet weak var commitBtn: UIButton!

    var timer: Timer?
    let timeLength = 60
    var currentTime = 0
    var isWorking:Bool = false
    
    var smscode:String?
    var codeStr:String = "86"
    
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
        
        titleLabel.text = NSLocalizedString("AccountResetPassword", comment: "")
        countryCodeBtn.setTitle("China(86)", for: .normal)
        numLabel.text = NSLocalizedString("AccountPhone", comment: "")
        numTF.placeholder = NSLocalizedString("AccountEnterPhoneNumber", comment: "")
        smsCodeBtn.setTitle(NSLocalizedString("AccountSendPIN", comment: ""), for: .normal)
        nrePwdLabel.text = NSLocalizedString("AccountNewPassword", comment: "")
        newPwdTF.placeholder = NSLocalizedString("AccountEnterNewPassword", comment: "")
        smsCodeLabel.text = NSLocalizedString("AccountPIN", comment: "")
        smsCodeTF.placeholder = NSLocalizedString("InputSmsCode", comment: "")
        commitBtn.setTitle(NSLocalizedString("Sure", comment: ""), for: .normal)

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
    
    func popViewController(){
        numTF.resignFirstResponder()
        smsCodeTF.resignFirstResponder()
        newPwdTF.resignFirstResponder()
        
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
                _ = LoginRegisterAbstract.requestPIN(numTF.text, reqType: .changePwd, country: country, comp: { (result) in
                    if result.code == "2000"{
                        self.isWorking = true
                        
                        self.timerChangeStatus(true)
                        
                        MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("SnackTipPINSent", comment: ""))
                       
                    }else if result.code == "2001" {
                        MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("HasNoUser", comment: ""))
                       
                    }else{
                        MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("SnackTipFailToSentThePINPleaseRetryLater", comment: ""))
                        
                    }
                })
                
                
            }
            
            
        }
        
    }
   
    @IBAction func commitBtnAction(_ sender: Any) {
        ProgressAnimateTool.tool.show(inView: self.view)
        if numTF.text == "" || smsCodeTF.text == "" || newPwdTF.text == "" {
            ProgressAnimateTool.tool.dismiss()
            MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("AccountCheckYourInput", comment: ""))
           
        }else{
            let pwdStr = GJTool.getMD5Code(with: newPwdTF.text)
            _ = LoginRegisterAbstract.retrievePwd(numTF.text!, newPwd: pwdStr!, pin: smsCodeTF.text!, comp: { (result) in
                ProgressAnimateTool.tool.dismiss()
                if result.code == "2000" {
                    MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("SetPwdOK", comment: ""))
                   
                    _ = self.navigationController?.popViewController(animated: true)
                }else if result.code == "2001"{
                    MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("SnackTipWrongPIN", comment: ""))
                    
                }else if result.code == "2003"{
                    MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("HasNoUser", comment: ""))
                    
                }else{
                    MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("SetPwdFalse", comment: ""))
                    
                }
            })
        }
        
    }
    
    func sendCountryCode(_ code: String, country:String) -> String {
        countryCodeBtn?.setTitle("\(country)(\(code))", for: UIControlState())
        codeStr = code
        return code
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
    
    func clockEvent() {
        
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
        smsCodeTF.resignFirstResponder()
        newPwdTF.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
