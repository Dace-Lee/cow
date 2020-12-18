//
//  SubVC.swift
//  Cowa
//
//  Created by MX on 16/5/5.
//  Copyright © 2016年 MX. All rights reserved.
//

import UIKit
import DynamicButton
import SVProgressHUD
import SnapKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class SubVC: UIViewController,UIGestureRecognizerDelegate {
    
    var isNavRoot: Bool = false
    var isNormal: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !isNormal { return }
        self.addBackBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isNormal { return }
        self.addNaviGestureBack(self)
        SVProgressHUD.dismiss(withDelay: 0.5)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !isNormal { return }
        SVProgressHUD.dismiss(withDelay: 0.5)
    }
    
    fileprivate func addBackBarButton(_ sel: Selector = #selector(backTap)) {
        let color = UIColor.white
        self.navigationController?.navigationBar.tintColor = color
        let btn = DynamicButton.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        btn.style = .caretLeft
        btn.addTarget(self, action: sel, for: .touchUpInside)
        btn.strokeColor = color
        btn.lineWidth = 2
        let barBtn = UIBarButtonItem.init(customView: btn)
        
        self.navigationItem.leftBarButtonItem = barBtn
    }
    
    @objc fileprivate func backTap(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
        if nil != self.navigationController?.viewControllers {
            if self.isNavRoot {
                let nav = UINavigationController.init(rootViewController: HomeControllerVC())
                let delegate = UIApplication.shared.delegate as? AppDelegate
                let rootVC = delegate?.window?.rootViewController as? BaseVC
                if nil != rootVC {
                    rootVC?.setContentViewController(nav, animated: true)
                    rootVC?.presentLeftMenuViewController()
                }
            }
        }
    }
    
}

extension UIViewController {
    func addNaviGestureBack(_ dele:UIGestureRecognizerDelegate?) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = dele
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if nil != self.navigationController {
            if nil != self.navigationController?.viewControllers {
                if self.navigationController?.viewControllers.count > 1 {
                    return true
                } else {
                    let centerNav: UINavigationController = UIStoryboard.init(name: "Home", bundle: nil).instantiateInitialViewController() as! UINavigationController
                    let delegate = UIApplication.shared.delegate as? AppDelegate
                    let rootVC = delegate?.window?.rootViewController as? BaseVC
                    if nil != rootVC {
                        rootVC?.setContentViewController(centerNav, animated: true)
                        rootVC?.presentLeftMenuViewController()
                    }
                    return false
                }
            }
        }
        return false
    }
}

