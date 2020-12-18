//
//  Login.swift
//  Cowa
//
//  Created by MX on 16/5/6.
//  Copyright © 2016年 MX. All rights reserved.
//

import UIKit
import SVProgressHUD

class Login: UIViewController {

    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var signUp: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attr = [NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:TFont.getSystemFont(14)] as [String : Any]
        
        
        
        signIn.setAttributedTitle(NSAttributedString.init(string: NSLocalizedString("AccountSignIn", comment: "Sign In"), attributes: attr), for: UIControlState())
        signUp.setAttributedTitle(NSAttributedString.init(string: NSLocalizedString("AccountSignUp", comment: "Sign Up"), attributes: attr), for: UIControlState())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        TBgImageManager.sharedBgImgManager.assembleImgInView(view, bgPic: "开机画面背景图")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    class func showLogin(_ inVc: UIViewController) {
        let login = UIStoryboard.init(name: "Login", bundle: nil).instantiateInitialViewController()
        inVc.present(login!, animated: false, completion: nil)
    }
}
