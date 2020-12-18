//
//  AppConfig.swift
//  Cowa
//
//  Created by MX on 16/4/28.
//  Copyright © 2016年 MX. All rights reserved.
//

import UIKit
import SVProgressHUD

let ACTION_ONE_IDENTIFIER : String = "ACTION_ONE_IDENTIFIER"
let ACTION_TWO_IDENTIFIER : String = "ACTION_TWO_IDENTIFIER"

class AppConfig: NSObject {
    
    static let sharedConfig = AppConfig()
    fileprivate override init() {
        super.init()
        appSetup()
        UIConfig()
        NotiSetup()
    }
    
    func appSetup() {
        _ = TNetworkReachability.sharedInstance
        TNetworking.commonHandlers.append {
            (res) in
            TNetworking.showError(res)
        }
        TNetworking.reachAbilityHandler = {
            reachable in
            if !reachable {TNetworking.showMsg(NSLocalizedString("NoNetWorking", comment: ""))}
        }
        _ = TBLEManager.sharedManager
    }
    
    func UIConfig() {
        SVProgressHUD.setMinimumDismissTimeInterval(2)
    }
    
    func NotiSetup() {
        let actionOne = LocalNotificationHelper.sharedInstance().createUserNotificationActionButton(identifier: ACTION_ONE_IDENTIFIER, title: "OK")
//        let actionTwo = LocalNotificationHelper.sharedInstance().createUserNotificationActionButton(identifier: ACTION_TWO_IDENTIFIER, title: "Dislike")
        
//        let actions = [actionOne,actionTwo]
        let actions = [actionOne]
        
        LocalNotificationHelper.sharedInstance().registerUserNotificationWithActionButtons(actions: actions)
    }
    
}
