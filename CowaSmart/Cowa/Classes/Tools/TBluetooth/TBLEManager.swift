//
//  TBLEManager.swift
//  Cowa
//
//  Created by MX on 16/8/29.
//  Copyright © 2016年 MX. All rights reserved.
//

import Foundation
import CowaBLELib
import AudioToolbox

class TBLEManager: NSObject {
    let kNotiBLEManagerConnectChanged = "kNotiBLEManagerConnectChanged"
    
    static let sharedManager = TBLEManager()
    fileprivate override init() {
        super.init()
        addObserver()
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    var hasWarningBattery: Bool = false
    var hasWarningDistance: Bool = false
    var keepSnakeWarning: Bool = false //是否开启持续震动报警
    var openBoxFollow: Bool? = false // 是否打开呼吸震动
    
    
    private var shakeTimer: Timer! //持续震动的定时器
    private var followShakeTimer: Timer!
    var FirstLocalNoti: Bool = false //记录本地推送
    
    
    
    
    
    var RedLightHasOn: Bool = false
    

    var devices: [TBLEDevice] {
        get {
            return TBluetooth.share().devices.allValues as! [TBLEDevice]
        }
    }
    
   
    
    var dev: CowaBLEDevice? {
        didSet {
            NotificationCenter.default.post(name: Notification.Name(rawValue: kNotiBLEManagerConnectChanged), object: nil)
        }
    }
    
    func scan(_ enable: Bool) {
        if enable {
            TBluetooth.share().removeNotConnectDevices()
            TBluetooth.share().startScan()
        } else {
            TBluetooth.share().stopScan()
        }
    }
    
    func connect(_ device: TBLEDevice?) {
        dev?.device?.selected = false
        dev?.status = nil
        dev = nil
        TBluetooth.share().connect(to: device?.peri)
        device?.selected = true
    }
    
    class func checkDevice() -> Bool {
        return nil != TBLEManager.sharedManager.dev
    }
    
    //MARK:Private methods
    @objc fileprivate func eNotiDeviceConnectChanged() {

        if nil != dev && !dev!.device.isConnect {
            dev = nil
            
            if followShakeTimer == nil{//如果失去连接，则关闭呼吸震动
                return;
            }
            followShakeTimer.invalidate()
            followShakeTimer = nil
            stopShake()
            
            nearfarDistanceStopShake()//如果失去蓝牙连接，是否持续震动（看需求）
        }
    }
    
    @objc fileprivate func eNotiDeviceStatusChanged(_ noti: Notification) {
        let device: TBLEDevice? = noti.object as? TBLEDevice
        if nil != device && device!.isReady {
            dev = nil
            dev = CowaBLEDevice.init(device: device)
            dev?.distanceSensor = true
            dev?.heartbeat = true
        }
    }

    @objc fileprivate func eNotiStatusUpdate() {
        dev?.distanceSwith = TUser.useBLESensor()
        dev?.batteryLowAlarm = TUser.useAlarm()
        dev?.distanceAlarm = TUser.useAlarm()
        isJudgeNeedOpenKeepSnakeing(isFar: false, isRed: (dev?.status.isFollowWraning)!)
        isJudgeNeedOpenBreathSnakeing()
    }
    
    @objc fileprivate func eNotiDeviceFaraway() {
        
        TBLEManager.sharedManager.dev?.status.setBreath(.red)
        hasWarningDistance = true
        RedLightHasOn = true
//        if TUser.useAlarm() && !hasWarningDistance && TBLEManager.checkDevice()
        
        isJudgeNeedOpenKeepSnakeing(isFar: true, isRed: (dev?.status.isFollowWraning)!)
    }
    
    @objc fileprivate func eNotiDeviceNear() {
        
        if !(dev?.status.isFollowWraning)!{ //非红灯
             nearfarDistanceStopShake()//距离靠近关闭持续震动
//             FirstLocalNoti = false
        }
       
//        if RedLightHasOn  {//改变箱子呼吸灯颜色
            TBLEManager.sharedManager.dev?.status.setBreath(.close)
            
            if  let color = UserDefaults.standard.object(forKey: "\(TUser.userPhone()).ledColor") {
                if color as! String == "red" {
                    TBLEManager.sharedManager.dev?.status.setBreath(.red)
                }else if color as! String == "blue" {
                    TBLEManager.sharedManager.dev?.status.setBreath(.blue)
                }else if color as! String == "green" {
                    TBLEManager.sharedManager.dev?.status.setBreath(.green)
                }
            }
            hasWarningDistance = false
            RedLightHasOn = false
//        }
    }
    
    @objc fileprivate func eNotiDeviceBatteryLow() {
        if TUser.useAlarm() && !hasWarningBattery && TBLEManager.checkDevice() {
            let content = NSLocalizedString("WarningBatteryLow", comment: "")
            TNoti.noti(content)
            hasWarningBattery = true
        }
    }
    
    //MARK 是否需要打开震动报警 第一个参数判断是否超过距离，第二个参数判断是否是拉杆灯红灯
    fileprivate func isJudgeNeedOpenKeepSnakeing(isFar:Bool, isRed:Bool){
        
        if !keepSnakeWarning {  // 如果震动提醒不打开，那么底下的持续震动就不启动
            nearfarDistanceStopShake()
            FirstLocalNoti = false
            return
        }
        if !(dev?.status.followStatus)!{
            return;
        }
        if   TBLEManager.checkDevice(){
            if isFar  || isRed {
                farDistanceKeepShake()//开启持续震动
                if !FirstLocalNoti {//第一次发送本地推送
                    let content = NSLocalizedString("WarningCowaFaraway", comment: "")//国际化推送内容
                    TNoti.noti(content)  //发送本地推送
                    FirstLocalNoti = true
                    
                }
            }
        }
    }
    
    //MARK  是否需要呼吸震动
    fileprivate func isJudgeNeedOpenBreathSnakeing(){
        if nil != dev && dev!.device.isConnect{
            if openBoxFollow! {//开启呼吸震动
                if (self.dev?.status.followStatus)!{// 目前是跟随状态
                    if followShakeTimer == nil{
                        followShakeTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(startShake), userInfo: nil, repeats: true);
                        RunLoop.current.add(followShakeTimer, forMode: RunLoop.Mode.default)
                    }
                    
                }
            }else{ //关闭
                if followShakeTimer == nil{
                    return;
                }
                followShakeTimer.invalidate()
                followShakeTimer = nil
                stopShake()
            }
        }
    }
    
    
    
    

    fileprivate func farDistanceKeepShake(){ //超出距离持续震动
        if shakeTimer == nil {
            shakeTimer =  Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(startShake), userInfo: nil, repeats: true)
        }
        
    }
    
    
    fileprivate func nearfarDistanceStopShake(){
        if shakeTimer == nil {
            return;
        }
        stopShake()
        shakeTimer.invalidate()
        shakeTimer = nil
        
    }
    
    
    @objc func startShake(){//开始震动
        let soundID = SystemSoundID(kSystemSoundID_Vibrate)
        AudioServicesPlaySystemSound(soundID)
    }
    
    func stopShake(){//停止震动
        let soundID = SystemSoundID(kSystemSoundID_Vibrate)
        AudioServicesRemoveSystemSoundCompletion(soundID)
        AudioServicesDisposeSystemSoundID(soundID)
    }
    
    
    fileprivate func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(eNotiStatusUpdate), name: NSNotification.Name(rawValue: kBLENotiStatusUpdate), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(eNotiDeviceStatusChanged), name: NSNotification.Name(rawValue: kBLENotiStatusChanged), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(eNotiDeviceConnectChanged), name: NSNotification.Name(rawValue: kBLENotiDeviceConnectChanged), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(eNotiDeviceBatteryLow), name: NSNotification.Name(rawValue: kCowaBLENotiBatteryLow), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(eNotiDeviceFaraway), name: NSNotification.Name(rawValue: kCowaBLENotiDistanceFaraway), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(eNotiDeviceFaraway), name: NSNotification.Name(rawValue: "kCowaBLENotiDistanceFaraway"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(eNotiDeviceNear), name: NSNotification.Name(rawValue: "kCowaBLENotiDistanceNear"), object: nil)
    }
}
