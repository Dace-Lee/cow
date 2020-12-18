//
//  TNoti.swift
//  Cowa
//
//  Created by MX on 2016/11/5.
//  Copyright © 2016年 MX. All rights reserved.
//

import UIKit

class TNoti: NSObject {
    class func noti(_ mesg: String = "") {
        let userInfo = ["App" : "CowaRobot"]
        LocalNotificationHelper.sharedInstance().scheduleNotificationWithKey("Warning", title: "Warning", message: mesg, seconds: 2, userInfo: userInfo)
    }
    
    class func clear() {
        LocalNotificationHelper.sharedInstance().cancelAllNotifications()
    }
}
