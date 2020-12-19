//
//  AppDelegate.swift
//  Cowa
//
//  Created by MX on 16/4/27.
//  Copyright © 2016年 MX. All rights reserved.
//

import UIKit
import CowaBLELib
import GoogleMaps
import SwiftyJSON

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , BMKGeneralDelegate , JPUSHRegisterDelegate{

    var window: UIWindow?
    
    var mapManager:BMKMapManager?
    
    var remoteInfo:NSDictionary?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.backgroundColor = UIColor.white
        NetURL.tool.initUrl()
        _ = AppConfig.sharedConfig
        
        
        //百度地图
        mapManager = BMKMapManager()
        let ret = mapManager?.start("xGUDHWUbGHyexo7cl8yGsZD6NfRllbmz", generalDelegate: self)
        if ret == false {
            print("map manager start false")
        }
        
        //谷歌地图
        GMSServices.provideAPIKey("AIzaSyDGfUDDce8gROs1e-bmslP_yRqwTglN7y8")
        
        //友盟统计
        UMAnalyticsConfig.sharedInstance().appKey = "59c0e3df04e2054e20000018"
        UMAnalyticsConfig.sharedInstance().channelId = "App Store"
        let infoDictionary = Bundle.main.infoDictionary
        let majorVersion : String = infoDictionary! ["CFBundleShortVersionString"] as! String
        MobClick.setAppVersion(majorVersion)
        MobClick.start(withConfigure: UMAnalyticsConfig.sharedInstance())
        

        let entity = JPUSHRegisterEntity()
        entity.types = NSInteger(JPAuthorizationOptions.alert.rawValue | JPAuthorizationOptions.badge.rawValue | JPAuthorizationOptions.sound.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        //0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用
        JPUSHService.setup(withOption: launchOptions, appKey: "fd0161d73be4155ecb4a7d2c", channel: "App Store", apsForProduction: true, advertisingIdentifier: nil)
        
        if launchOptions != nil {
            if let userInfo = launchOptions![UIApplication.LaunchOptionsKey.remoteNotification]{
                remoteInfo = userInfo as? NSDictionary
            }
        }

        
        UIApplication.shared.isIdleTimerDisabled = true
        
        TUser.imei("")
        TUser.boxName("")
        TUser.useBLESensor(false)
        TUser.isHost(false)
        TUser.appVersion(majorVersion)
        

//        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
//            self.nslogToDocument()
//        }
        
        return true
    }
    

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("register remote push failed")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        JPUSHService.handleRemoteNotification(userInfo)
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(.newData)
        
    }
    
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {

        let userInfo:Dictionary = notification.request.content.userInfo as! Dictionary<String,Any>

        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        let type:Int = Int(UNNotificationPresentationOptions.alert.rawValue)
        completionHandler(type)
    }

    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo:Dictionary = response.notification.request.content.userInfo as! Dictionary<String,Any>

        if let msgid = userInfo["_j_msgid"]{
            let id = msgid as! NSNumber
            _ = TDeviceManager.shared().getMsgFromJPUSH(id.stringValue) { (result) in
                if result.code == "2000"{

                    let data = ViewController.swiftyJsonFromData(data: result.resp!.data!)

                    let defs = UserDefaults.standard
                    let languages = defs.object(forKey: "AppleLanguages")
                    let preferredLanguage:String = (languages! as AnyObject).object(at: 0) as! String

                    if preferredLanguage.hasPrefix("zh-Hans"){
                        let alertView = UIAlertView.init(title: NSLocalizedString("COWAROBOTAvoid", comment: ""), message: data["result"]["cn"].string!, delegate: self, cancelButtonTitle: "OK")
                        alertView.show()
                    }else{
                        let alertView = UIAlertView.init(title: NSLocalizedString("COWAROBOTAvoid", comment: ""), message: data["result"]["en"].string!, delegate: self, cancelButtonTitle: "OK")
                        alertView.show()
                    }
                }
            }
        }


        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))!{
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        TBluetooth.share().cancelAllPeConnect()
    }
    
    //进入前台时消除小红点
    func applicationWillEnterForeground(_ application: UIApplication) {
        TNoti.clear()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        //播放一段无声音乐,避免被kill
        MMPDeepSleepPreventer.sharedSingleton().startPreventSleep();
        TBLEManager.sharedManager.hasWarningBattery = false
        TBLEManager.sharedManager.hasWarningDistance = false
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        
        if identifier == ACTION_ONE_IDENTIFIER {
            print("action one - tapped")
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: ACTION_ONE_IDENTIFIER), object: nil)
            
        }else if identifier == ACTION_TWO_IDENTIFIER {
            print("action two - tapped")
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: ACTION_TWO_IDENTIFIER), object: nil)
        }
        
        completionHandler()
    }
    
    
    func nslogToDocument(){
        
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentPath = paths[0]
        let fileName = documentPath + "/\(TUser.userPhone()).log"
        
        if let file = NSMutableData.init(contentsOfFile: fileName) {
            if file.length >= 10*1024*1024{
                file.length = 0
                file.write(toFile: fileName, atomically: true)
            }
        }
        
        //将log输入到文件
        freopen(fileName.cString(using: String.Encoding.ascii)!, "a+", stdout)
        freopen(fileName.cString(using: String.Encoding.ascii)!, "a+", stderr)
        
    }

}


