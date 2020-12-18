//
//  FeedbackVC.swift
//  Cowa
//
//  Created by gaojun on 2017/9/12.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit
import DynamicButton
import SwiftyJSON

class FeedbackVC: UIViewController, UITextViewDelegate {
    
    var resourceArr = [FacebackModel]()
    @IBOutlet weak var lockBtn: UIButton!
    @IBOutlet weak var handRingBtn: UIButton!
    @IBOutlet weak var handerBtn: UIButton!
    @IBOutlet weak var wheelBtn: UIButton!
    @IBOutlet weak var bleConnectBtn: UIButton!
    @IBOutlet weak var bindShareBtn: UIButton!
    
    @IBOutlet weak var lockBtn2: UIButton!
    @IBOutlet weak var handRingBtn2: UIButton!
    @IBOutlet weak var handerBtn2: UIButton!
    @IBOutlet weak var wheelBtn2: UIButton!
    @IBOutlet weak var bleConnectBtn2: UIButton!
    @IBOutlet weak var bindShareBtn2: UIButton!
    
    @IBOutlet weak var issueLabel: UILabel!
    @IBOutlet weak var feedLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var bgImageView: UIImageView!
    
    @IBOutlet weak var commitBtn: UIButton!
    
    @IBOutlet weak var facebackBtn: UIButton!
    var isFirst = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNaviGationBar()
        
        
        
        let imageV = UIImageView(image: UIImage(named:"登录页面-背景图"))
        imageV.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        view.insertSubview(imageV, at: 0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        lockBtn2.setTitle(NSLocalizedString("LockIssue", comment: ""), for: .normal)
        handRingBtn2.setTitle(NSLocalizedString("HandleRing", comment: ""), for: .normal)
        handerBtn2.setTitle(NSLocalizedString("Handler", comment: ""), for: .normal)
        wheelBtn2.setTitle(NSLocalizedString("Wheel", comment: ""), for: .normal)
        bleConnectBtn2.setTitle(NSLocalizedString("BLEConnect", comment: ""), for: .normal)
        bindShareBtn2.setTitle(NSLocalizedString("BindIssue", comment: ""), for: .normal)
        
        issueLabel.text = NSLocalizedString("MeetIssue", comment: "")
        feedLabel.text = NSLocalizedString("AdviceFeed", comment: "")
        
        textView.text = NSLocalizedString("IssueText", comment: "")
        
        commitBtn.setTitle(NSLocalizedString("Commite", comment: ""), for: .normal)
        
        view.insertSubview(textView, aboveSubview: bgImageView)
        
        //
        loadData()
        facebackBtn.setTitle(NSLocalizedString("AFaceBack", comment: ""), for: .normal)
        
    }
    
    
    fileprivate func loadData() {
        let url = "http://server.cowarobot.com/openapi/cowaapp.user.opition"
        let phoneNum: String = TUser.userPhone() as String
//        print(phoneNum)
        let  tokenId = TUser.userToken() as String
        let para = ["telnumber":phoneNum]
        _ = TNetworking.requestWithPara(method: .get, URL: url, Parameter: para as [String : AnyObject], Token: tokenId, handler: { (res) in
           
            let json = JSON(data: res.data!)
            if "2000" == json["code"].string {
                self.resourceArr =  json["result"].arrayValue.map({FacebackModel(json: $0)})
                let count = UserDefaults.standard.object(forKey: "questionCount") as? Int
                if let aCount = count {
                    if self.resourceArr.count == aCount {
                        self.facebackBtn.setTitle(NSLocalizedString("AFaceBack", comment: ""), for: .normal)
                        self.facebackBtn.setBackgroundImage(UIImage(named:"注册按钮"), for: .normal)
                        self.facebackBtn.isEnabled = true
                    }else {
                        self.facebackBtn.setTitle(NSLocalizedString("AFaceBack", comment: ""), for: .normal)
                        self.facebackBtn.setBackgroundImage(UIImage(named:"faceback"), for: .normal)
                        self.facebackBtn.isEnabled = true
                    }
                }else {
                    self.facebackBtn.setTitle(NSLocalizedString("AFaceBack", comment: ""), for: .normal)
                    self.facebackBtn.setBackgroundImage(UIImage(named:"注册按钮"), for: .normal)
                    self.facebackBtn.isEnabled = true
                }
              
                
            }else {
                self.facebackBtn.setTitle(NSLocalizedString("AdviceFeed", comment: ""), for: .normal)
                self.facebackBtn.setBackgroundImage(UIImage(named:"faceback"), for: .normal)
                self.facebackBtn.isEnabled = false
            }
            
        })
    }
    
    func createNaviGationBar(){
        let btn: DynamicButton? = DynamicButton.init(style: .caretLeft)
        btn?.addTarget(self, action: #selector(leftBtnAction), for: .touchUpInside)
        btn?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btn?.strokeColor = UIColor.white
        let item1=UIBarButtonItem(customView: btn!)
        self.navigationItem.leftBarButtonItem = item1
        
        title = NSLocalizedString("FeedBack", comment: "")
    }
    
    @objc func leftBtnAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func lockBtnAction(_ sender: Any) {
        lockBtn.isSelected = true
        handRingBtn.isSelected = false
        handerBtn.isSelected = false
        wheelBtn.isSelected = false
        bleConnectBtn.isSelected = false
        bindShareBtn.isSelected = false
    }

    @IBAction func handleRingBtnAction(_ sender: Any) {
        lockBtn.isSelected = false
        handRingBtn.isSelected = true
        handerBtn.isSelected = false
        wheelBtn.isSelected = false
        bleConnectBtn.isSelected = false
        bindShareBtn.isSelected = false
    }
    
    @IBAction func wheelBtnAction(_ sender: Any) {
        lockBtn.isSelected = false
        handRingBtn.isSelected = false
        handerBtn.isSelected = false
        wheelBtn.isSelected = true
        bleConnectBtn.isSelected = false
        bindShareBtn.isSelected = false
    }
    
    @IBAction func handlerBtnAction(_ sender: Any) {
        lockBtn.isSelected = false
        handRingBtn.isSelected = false
        handerBtn.isSelected = true
        wheelBtn.isSelected = false
        bleConnectBtn.isSelected = false
        bindShareBtn.isSelected = false
    }
    
    @IBAction func bindShareBtnAction(_ sender: Any) {
        lockBtn.isSelected = false
        handRingBtn.isSelected = false
        handerBtn.isSelected = false
        wheelBtn.isSelected = false
        bleConnectBtn.isSelected = false
        bindShareBtn.isSelected = true
    }
    
    @IBAction func bleConnectBtnAction(_ sender: Any) {
        lockBtn.isSelected = false
        handRingBtn.isSelected = false
        handerBtn.isSelected = false
        wheelBtn.isSelected = false
        bleConnectBtn.isSelected = true
        bindShareBtn.isSelected = false
    }
    
    @IBAction func commitBtnAction(_ sender: Any) {
        
        if textView.text.isEmpty || (lockBtn.isSelected == false &&
            handRingBtn.isSelected == false &&
            handerBtn.isSelected == false &&
            wheelBtn.isSelected == false &&
            bleConnectBtn.isSelected == false &&
            bindShareBtn.isSelected == false ) || textView.text == NSLocalizedString("IssueText", comment: ""){
            MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("AccountCheckYourInput", comment: ""))
        }else{
            ProgressAnimateTool.tool.show(inView: self.view)
            
            var type = ""
            if bleConnectBtn.isSelected{
                type = "9"
            }else if bindShareBtn.isSelected{
                type = "10"
            }else if lockBtn.isSelected{
                type = "5"
            }else if handRingBtn.isSelected{
                type = "6"
            }else if handerBtn.isSelected{
                type = "8"
            }else if wheelBtn.isSelected{
                type = "7"
            }
//            18017520826
            textView.resignFirstResponder()
            
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentPath = paths[0]
            let fileName = documentPath + "/\(TUser.userPhone()).log"
            if let file:NSMutableData = NSMutableData(contentsOfFile: fileName) {
                
                if file.length > 0{
                    var url = "http://115.159.63.84/openapi/cowaapp.user.storeLogfile"
                    
                    url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                    let request:NSMutableURLRequest = NSMutableURLRequest(url: URL(string: url)!)
                    request.httpMethod = "POST"
                    let session:URLSession = URLSession.shared;
                    session.uploadTask(with: request as URLRequest, from: file as Data, completionHandler: { (data, responseData, error) in
                        
                        let json = JSON(data:data!)
                        if json != JSON.null{
                            if json["code"].string == "2000"{
                                _ = TDeviceManager.shared().pushFeedBack(json["result"]["id"].string, telnumber: TUser.userPhone(), description: self.textView.text, type: type, comp: { (result) in
                                    ProgressAnimateTool.tool.dismiss()
                                    if result.code == "2000"{
                                        
                                        MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("CommitOk", comment: ""))
                                        
                                        file.length = 0
                                        file.write(toFile: fileName, atomically: true)
                                        
                                    }else{
                                        MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("CommitFalse", comment: ""))
                                        
                                    }
                                })
                            }
                        }else{
                            ProgressAnimateTool.tool.dismiss()
                            MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("CommitFalse", comment: ""))
                            
                        }
                    }).resume()
                }else{
                    _ = TDeviceManager.shared().pushFeedBack("", telnumber: TUser.userPhone(), description: self.textView.text, type: type, comp: { (result) in
                        ProgressAnimateTool.tool.dismiss()
                        if result.code == "2000"{
                            MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("CommitOk", comment: ""))
                            
                        }else{
                            MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("CommitFalse", comment: ""))
                            
                        }
                    })
                }
            }else {
                _ = TDeviceManager.shared().pushFeedBack("", telnumber: TUser.userPhone(), description: self.textView.text, type: type, comp: { (result) in
                    ProgressAnimateTool.tool.dismiss()
                    if result.code == "2000"{
                        MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("CommitOk", comment: ""))
                        
                    }else{
                        MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("CommitFalse", comment: ""))
                        
                    }
                })
            }
        }
        
        
    }
    /* */
    @IBAction func facebackAction(_ sender: UIButton) {
        
        let vc = FacebackInfo()
        UserDefaults.standard.set(self.resourceArr.count, forKey: "questionCount")
//        UserDefaults.standard.set(true, forKey: "isOK")
        UserDefaults.standard.synchronize()
        sender.setBackgroundImage(UIImage(named:"faceback"), for: .normal)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if isFirst {
            isFirst = false
            textView.text = ""
        }
    }
    
}
