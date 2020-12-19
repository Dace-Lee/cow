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
        
        let attr = [convertFromNSAttributedStringKey(NSAttributedString.Key.foregroundColor):UIColor.white,convertFromNSAttributedStringKey(NSAttributedString.Key.font):TFont.getSystemFont(14)] as [String : Any]
        
        
        
        signIn.setAttributedTitle(NSAttributedString.init(string: NSLocalizedString("AccountSignIn", comment: "Sign In"), attributes: convertToOptionalNSAttributedStringKeyDictionary(attr)), for: UIControl.State())
        signUp.setAttributedTitle(NSAttributedString.init(string: NSLocalizedString("AccountSignUp", comment: "Sign Up"), attributes: convertToOptionalNSAttributedStringKeyDictionary(attr)), for: UIControl.State())
        
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
        login?.modalPresentationStyle = .fullScreen
        inVc.present(login!, animated: false, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
