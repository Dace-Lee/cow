//
//  DataSycnizeHelper.swift
//  Cowa
//
//  Created by gaojun on 2017/8/1.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CowaBLELib

class DataSycnizeHelper: NSObject {
    
    static let helper = DataSycnizeHelper()
    
    func startSycn(_ imei:String){
        
        _ = TDeviceManager.shared().getUserFromImei(imei) { (result) in
            
            
            if result.code == "2000" || result.code == "2002"{
                
                let userArray = NSMutableArray()
                let data = JSON(data: result.resp!.data!)
                if data != JSON.null{
                    
                    if result.code == "2000"{
                        let dataArray = data["result"].array
                        if dataArray != nil{
                            for item in dataArray! {
                                userArray.add(item["username"].string!)
                            }
                        }
                    }
                    
                }
                
                PrintTool.tool.print("back:get user from imei return ", content: "back:get user from imei return \(userArray)", imei: TUser.imei())
                
                self.judgeIsExistNow(userArray)
                
                UserDefaults.standard.set(userArray, forKey: imei)
                
                UserDefaults.standard.set(Date(), forKey: "\(TUser.userPhone()).time")
                
            }
            
        }
        
    }
    
    func judgeIsExistNow(_ array:NSArray){
        
        if !array.contains(TUser.userPhone()){
            
            let dev = TBLEManager.sharedManager.dev
            dev?.status.deleteUser = false
            dev?.status.hasReVersion = false
            dev?.status.hasReHost = false
            dev?.status.hasReAddUser = false
            dev?.status.hasReDeleteUser = false
            dev?.status.hasReAuth = false
            dev?.status.hasReImei = false
            dev?.status.hasReAuthWithBoxHostNum = false
            dev?.status.hasReAuthBackHost = false
            dev?.status.hasReAddBackHost = false
            dev?.status.hasReAuthBoxHost = false
            dev?.status.hasReDeleteBoxHost = false
            
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "userIsNotExist"), object: nil)
            
            TBluetooth.share().cancelReconnect(dev?.device.peri)
            
        }
        
    }

}
