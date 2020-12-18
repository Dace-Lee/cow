//
//  TCowaLocation.swift
//  Cowa
//
//  Created by MX on 2016/11/11.
//  Copyright © 2016年 MX. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD

class TCowaLocation: NSObject {
    let kNotiCowaDeviceLocationUpdate = "kNotiCowaDeviceLocationUpdate"
    
    var IMEI = ""
    
    struct ACowaDevice {
        var lat: String
        var lon: String
        var name: String?
        var imei: String
    }
    
    static let locaTool = TCowaLocation()
    fileprivate override init() {
        super.init()
    }
    
    var devsLoca: [String:ACowaDevice] = Dictionary()
    fileprivate var workEnable: Bool = false
    
    func work(_ enable: Bool = true) {
        workEnable = enable
        
        updateCowaLoca()
    }
    
    func updateCowaLoca() {
        if !workEnable { return }
        
        if self.devsLoca.count > 0 {
            self.devsLoca.removeAll()
        }

        //获取位置
        self.getDeviceLastLocation()
        //更新位置
        self.pushNeedUpdataLocation("")
        
    }
    
    fileprivate func pushNeedUpdataLocation(_ imei:String) {
        
        _ = TDeviceManager.shared().originGetImeis { (result) in
            if result.code == "2000" {
                let json = JSON.init(data: result.resp!.data!)
                let devs = json["result"].array
                if devs != nil {
                    for dev in devs! {
                        
                        _ = TDeviceManager.shared().pushLocAndCancelBond(1, imei: dev["imei"].string) { (result) in
                            
                        }
                        
                    }
                }
            }
        }
        
    }
    
    fileprivate func getDeviceLastLocation() {
        
        var url = NetURL.tool.getLoc
        var para = [String:String]()
        
        
        if let dev = TBLEManager.sharedManager.dev {
            if (dev.status.imeiString != nil) {
                para = ["telnumber":TUser.userPhone(),"imei":(dev.status.imeiString)!]
            }else{
                para = ["telnumber":TUser.userPhone()]
            }
        }else{
            para = ["telnumber":TUser.userPhone()]
        }
        
        
        url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        Alamofire.request(url, method: .post, parameters: para, encoding: URLEncoding.default, headers: nil).response { (response) in
            let json = JSON(data: response.data!)
            let result = json["result"].array
            
            if nil != result {
                for a in result! {
                    let aDev = ACowaDevice(lat: a["lat"].string!, lon: a["lon"].string!, name: a["deviceName"].string!, imei:  a["imei"].string!)
                    self.devsLoca.updateValue(aDev, forKey: aDev.imei)
                }
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: self.kNotiCowaDeviceLocationUpdate), object: nil)
        }
    }
    
   
}
