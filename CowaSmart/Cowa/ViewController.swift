//
//  ViewController.swift
//  Cowa
//
//  Created by MX on 16/4/27.
//  Copyright © 2016年 MX. All rights reserved.
//

import UIKit
import RESideMenu
import SVProgressHUD

class ViewController: UIViewController {

    lazy var mainVC: BaseVC = {
        
        let nav = UINavigationController.init(rootViewController: HomeControllerVC())
        
        let vc = BaseVC.init(contentViewController: nav, leftMenuViewController: MenuViewController(), rightMenuViewController: nil)
        return vc!
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            let delegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
            delegate?.window?.rootViewController = self.mainVC
            
            if TUser.userToken() == "" {
                Login.showLogin(self.mainVC)
                return
            }
            
            _ = LoginRegisterAbstract.login(TUser.userPhone(), pwd: TUser.userPwd()) { (result) in
                ProgressAnimateTool.tool.dismiss()
                if result.code == "2000" {
                    
                    let tags = NSSet.init(object: TUser.userPhone())
                    JPUSHService.addTags(tags as! Set<String>, completion: nil, seq: 1)
                    
                    MobClick.profileSignIn(withPUID: TUser.userPhone())
                    
                    
                }else if result.code == "2001"{

                }else if result.code == "2002" {
                  
                }else{
                    NetURL.tool.updateHost()
                    NetURL.tool.initUrl()
                    _ = LoginRegisterAbstract.login(TUser.userPhone(), pwd: TUser.userPwd()) { (result) in
                        ProgressAnimateTool.tool.dismiss()
                        if result.code == "2000" {
                            
                            let tags = NSSet.init(object: TUser.userPhone())
                            JPUSHService.addTags(tags as! Set<String>, completion: nil, seq: 1)
                            
                            MobClick.profileSignIn(withPUID: TUser.userPhone())
                            
                        }
                    }
                    
                }
            }
            
        }
    }
    

    

    
}

