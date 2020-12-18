//
//  MenuViewController.swift
//  Cowa
//
//  Created by gaojun on 2017/9/5.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit
import CowaBLELib

class MenuViewController: UIViewController {

    @IBOutlet weak var myAccountBtn: UIButton!
    @IBOutlet weak var commandBtn: UIButton!
    @IBOutlet weak var aboutBtn: UIButton!
    @IBOutlet weak var useageBtn: UIButton!
    @IBOutlet weak var exitBtn: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignOutAccount), name: NSNotification.Name(rawValue: "SignOutAccount"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let imageV = UIImageView(image: UIImage(named:"登录页面-背景图"))
        imageV.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        view.insertSubview(imageV, at: 0)
        
        
        myAccountBtn.setTitle(NSLocalizedString("MenuMyAccount", comment: ""), for: .normal)
        commandBtn.setTitle(NSLocalizedString("MenuProducts", comment: ""), for: .normal)
        aboutBtn.setTitle(NSLocalizedString("MenuAbout", comment: ""), for: .normal)
        useageBtn.setTitle(NSLocalizedString("MenuFAQ", comment: ""), for: .normal)
        exitBtn.setTitle(NSLocalizedString("MenuSignOut", comment: ""), for: .normal)
        
    }
  
    @IBAction func accountBtnAction(_ sender: Any) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let rootVC = delegate?.window?.rootViewController as? BaseVC
        
        let vc = MyAccountVC()
        if nil != rootVC {
            let nav = UINavigationController.init(rootViewController: vc)
            rootVC?.setContentViewController(nav, animated: true)
            rootVC?.hideViewController()
        }
    }
    
    
    @IBAction func commandBtnAction(_ sender: Any) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let rootVC = delegate?.window?.rootViewController as? BaseVC
        
        let vc = RecommendVC()
        if nil != rootVC {
            let nav = UINavigationController.init(rootViewController: vc)
            rootVC?.setContentViewController(nav, animated: true)
            rootVC?.hideViewController()
        }
    }
    
    @IBAction func aboutBtnAction(_ sender: Any) {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let rootVC = delegate?.window?.rootViewController as? BaseVC
        
        let vc = AboutVC()
        if nil != rootVC {
            let nav = UINavigationController.init(rootViewController: vc)
            rootVC?.setContentViewController(nav, animated: true)
            rootVC?.hideViewController()
        }
        
    }
    
    @IBAction func useAgeBtnAction(_ sender: Any) {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let rootVC = delegate?.window?.rootViewController as? BaseVC

        let vc: UIViewController = UseageViewController()
        if nil != rootVC {
            let nav = UINavigationController.init(rootViewController: vc)
            rootVC?.setContentViewController(nav, animated: true)
            rootVC?.hideViewController()
        }

    }
    
    @IBAction func exitBtnAction(_ sender: Any) {
        
        let v:SignOut = Bundle.main.loadNibNamed("SignOut", owner: self, options: nil)!.last as! SignOut
        PopTool.tool.show(inView: UIApplication.shared.keyWindow!, withView: v, width: 300, height: 197)
        
    }
    
    func SignOutAccount(){
        if let dev = TBLEManager.sharedManager.dev {
            TBluetooth.share().cancelReconnect(dev.device.peri)
            TBluetooth.share().cancelConnect(dev.device.peri)
            TBLEManager.sharedManager.connect(nil)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "stopSendStatus"), object: nil)
        }
        
        
        WatchDog.dog.stop()
        
        MobClick.profileSignOff()
        
        TUser.useAlarm(false)
        TUser.userPwd("")
        TUser.userPhone("")
        TUser.useBLESensor(false)
        TUser.userToken("")
        TUser.boxName("")
        TUser.isHost(false)
        TUser.imei("")
        TUser.lastPeripheralUUID("")
        Login.showLogin(self)
    }

}
