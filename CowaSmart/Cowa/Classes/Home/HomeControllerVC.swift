//
//  HomeControllerVC.swift
//  Cowa
//
//  Created by gaojun on 2017/9/11.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit
import CowaBLELib
import SnapKit
import DynamicButton
import SwiftyJSON
import SVProgressHUD

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

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l <= r
    default:
        return !(rhs < lhs)
    }
}

class HomeControllerVC: UIViewController {

    var deviceSearchVC: DeviceSearchVC?
    
    lazy var deviceTableContainer: UIView = {
        let v: UIView = UIView.init(frame: self.scanView.frame)
        v.backgroundColor = UIColor.clear
        return v
    }()
    
    var boxVersion = ""
    var hostNum = ""
    var backUserList:NSMutableArray = NSMutableArray()
    var backHostNum = ""
    
    var isNeedPush = false
    
    static var updateFinish = false
    
    var timer = Timer()
    var isTouch:Bool = false
    var speedx:Float = 0.0
    var speedy:Float = 0.0
    
    /*
     蓝牙扫描界面
     */
    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var openBLELabel: UILabel!
    @IBOutlet weak var scanBoxLabel: UILabel!
    @IBOutlet weak var scanBtn: UIButton!
    //@IBOutlet weak var gpsBtn: UIButton!
    @IBOutlet weak var feedBackBtn: UIButton!
    @IBOutlet weak var fantiScanLabel: UILabel!
    
    /*
     设备控制界面
     */
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var deviceNameBtn: UIButton!
    @IBOutlet weak var capView: UIView!
    @IBOutlet weak var capcityInsideView: UIView!
    @IBOutlet weak var capcityOutSideImageView: UIImageView!
    @IBOutlet var remoteControlBtn: UIButton!
    
    
    var capcityShowView: UIView?
    

    @IBOutlet weak var capcityLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var lichengLabel: UILabel!
    @IBOutlet weak var lockBtn: UIButton!
    @IBOutlet weak var flyBtn: UIButton!
    //@IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var BreatheBtn: UIButton!
    @IBOutlet weak var BreatheLab: UILabel!
    @IBOutlet weak var SnakeBtn: UIButton!
    @IBOutlet weak var SnakeLab: UILabel!
    @IBOutlet weak var feedBtn: UIButton!
    //@IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var dataShowView: UIView!
    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var feedLabel: UILabel!
    @IBOutlet weak var flyLabel: UILabel!
    @IBOutlet weak var lockLabel: UILabel!
    @IBOutlet var remoteControlLabel: UILabel!
    
    
    @IBOutlet weak var speedLiteLabel: UILabel!
    @IBOutlet weak var distanceLiteLabel: UILabel!
    
    
    var setterBtn:UIButton?
    var avoidBtn:UIButton?
    
    var setView:UIView?
    var avoidView:AvoidView?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addListener()
        
        deviceSearchVC = DeviceSearchVC()
        deviceSearchVC!.pageType = DeviceSearchVC.PageType.wicket
        addChild(deviceSearchVC!)
        deviceTableContainer.addSubview(deviceSearchVC!.view)
        deviceSearchVC!.view.snp.makeConstraints { (make) in
            make.left.bottom.right.top.equalTo(deviceTableContainer)
        }
        
        controlView.insertSubview(dataShowView, aboveSubview: picImageView)
        
        capcityShowView = UIView.init(frame: CGRect(x:0,y:0,width:28,height:9))
        capcityShowView?.backgroundColor = UIColor.clear
        capcityInsideView.addSubview(capcityShowView!)
        
        capView.insertSubview(capcityInsideView, aboveSubview: capcityOutSideImageView)
        
//        let lang = getLocalLanguage()
//        if !lang.hasPrefix("zh-Hant"){
//            fantiScanLabel.isHidden = true
//        }
        
        
        //电池框增加点击手势
        let tapSingle = UITapGestureRecognizer(target:self,action:#selector(tapSingleDid))
        tapSingle.numberOfTapsRequired = 1
        tapSingle.numberOfTouchesRequired = 1
        capcityLabel.isUserInteractionEnabled = true
        capcityLabel.addGestureRecognizer(tapSingle)
        
        exchangeView(false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //后台搜索上一次连接的箱子
        scanSpecialBagInBackground()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let imageV = UIImageView(image: UIImage(named:"登录页面-背景图"))
        imageV.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        view.insertSubview(imageV, at: 0)
        createNavigationBar()
        
        view.addSubview(deviceTableContainer)
        deviceTableContainer.snp.makeConstraints { (make) in
            make.left.bottom.right.top.equalTo(scanView)
        }
        
        openBLELabel.text = NSLocalizedString("HomeKeepBlueConnect", comment: "")
        scanBoxLabel.text = NSLocalizedString("HomeKeepMobileNearBag", comment: "")
        
        speedLiteLabel.text = NSLocalizedString("AverageSpeed", comment: "")
        distanceLiteLabel.text = NSLocalizedString("Mileage", comment: "")
        
        lockLabel.text = NSLocalizedString("SettingAuto", comment: "")
        flyLabel.text = NSLocalizedString("WeatherAirplaneMode", comment: "")
        SnakeBtn.imageView?.contentMode = .scaleAspectFit
        BreatheBtn.imageView?.contentMode = .scaleAspectFit
        SnakeLab.text = NSLocalizedString("SnakeWarn", comment: "")
        BreatheLab.text = NSLocalizedString("SnakeBreathe", comment: "")
        feedLabel.text = NSLocalizedString("FeedBack", comment: "")
        remoteControlLabel.text = NSLocalizedString("remoteControlButton", comment: "")
        fantiScanLabel.text = NSLocalizedString("clickConnectCowa", comment: "")
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        if UIScreen.main.bounds.height == 812 {//iphoneX
            deviceNameBtn.frame = CGRect(x:deviceNameBtn.frame.origin.x,y:54.0,width:deviceNameBtn.frame.size.width,height:deviceNameBtn.frame.size.height)
            capView.frame = CGRect(x:capView.frame.origin.x,y:95.0,width:capView.frame.size.width,height:capView.frame.size.height)
            capcityLabel.frame = CGRect(x:capcityLabel.frame.origin.x,y:115.0,width:capcityLabel.frame.size.width,height:capcityLabel.frame.size.height)
            dataShowView.frame = CGRect(x:dataShowView.frame.origin.x,y:186.0,width:dataShowView.frame.size.width,height:dataShowView.frame.size.height)
            picImageView.frame = CGRect(x:picImageView.frame.origin.x,y:186.0,width:picImageView.frame.size.width,height:picImageView.frame.size.height)
            
        }
    }
    
    func scanSpecialBagInBackground() {
        if !TBluetooth.share().bleAvaliable {
            
            return
        }
    }
    
    @objc func startRescan() {
        if TUser.lastUUID() != "" && (TBLEManager.sharedManager.dev == nil) {
            TBluetooth.share().startScan()
        }
    }
    
    func createNavigationBar(){
        
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        
        let imageView = UIImageView.init(frame: CGRect(x:0,y:0,width:125,height:15))
        imageView.image = UIImage(named:"左侧栏LOGO")
        self.navigationItem.titleView = imageView
        
        let btn = UIButton.init(frame: CGRect(x:0,y:0,width: 22,height: 22))
        btn.setImage(UIImage(named: "菜单栏图标"), for: .normal)
        btn.addTarget(self, action: #selector(leftBtnAction), for: .touchUpInside)
        let item1=UIBarButtonItem(customView: btn)
        self.navigationItem.leftBarButtonItem = item1
        
        avoidBtn = UIButton.init(frame: CGRect(x:0,y:0,width: 22,height: 22))
        avoidBtn!.setImage(UIImage(named: "感叹号"), for: .normal)
        avoidBtn!.addTarget(self, action: #selector(showAvoidView), for: .touchUpInside)
        avoidBtn!.isHidden = true
        avoidBtn!.isSelected = false
        let item3=UIBarButtonItem(customView: avoidBtn!)
        
//        setterBtn = UIButton.init(frame: CGRect(x:0,y:0,width: 22,height: 22))
//        setterBtn!.setImage(UIImage(named: "设置按钮"), for: .normal)
//        setterBtn!.addTarget(self, action: #selector(showSetView), for: .touchUpInside)
//        setterBtn!.isHidden = true
//        setterBtn!.isSelected = false
//        let item2=UIBarButtonItem(customView: setterBtn!)
        
        self.navigationItem.rightBarButtonItems = [item3]
        
    }
    
    @objc func showAvoidView(){
        avoidBtn?.isSelected = !(avoidBtn?.isSelected)!
        if (avoidBtn?.isSelected)! {
            if avoidView == nil {
                avoidView = Bundle.main.loadNibNamed("AvoidView", owner: self, options: nil)?.last as? AvoidView
                avoidView?.title = (TBLEManager.sharedManager.dev?.status.modeCode)!
                avoidView?.setTitleLabel()
                avoidView?.frame = CGRect(x:view.frame.size.width/2 - 150, y:-128, width:300, height:128)
                view.addSubview(avoidView!)
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                self.avoidView?.frame = CGRect(x:self.view.frame.size.width/2 - 150, y:70, width:300, height:128)
            }) { (finish) in
                self.avoidView?.frame = CGRect(x:self.view.frame.size.width/2 - 150, y:70, width:300, height:128)
            }
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.avoidView?.removeFromSuperview()
                self.avoidView = nil
            }) { (finish) in
                self.avoidView?.removeFromSuperview()
                self.avoidView = nil
            }
        }
    }
    
    func showSetView(){
        setterBtn?.isSelected = !(setterBtn?.isSelected)!
        if (setterBtn?.isSelected)! {
            if setView == nil {
                setView = Bundle.main.loadNibNamed("SetterView", owner: self, options: nil)?.last as? SetterView
                setView?.frame = CGRect(x:view.frame.size.width/2 - 160, y:-144.5, width:320, height:144.5)
                view.addSubview(setView!)
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                self.setView?.frame = CGRect(x:self.view.frame.size.width/2 - 160, y:70, width:320, height:144.5)
            }) { (finish) in
                self.setView?.frame = CGRect(x:self.view.frame.size.width/2 - 160, y:70, width:320, height:144.5)
            }
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.setView?.frame = CGRect(x:self.view.frame.size.width/2 - 160, y:-144.5, width:320, height:144.5)
            }) { (finish) in
                self.setView?.frame = CGRect(x:self.view.frame.size.width/2 - 160, y:-144.5, width:320, height:144.5)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        setterBtn?.isSelected = false
        avoidBtn?.isSelected = false
        UIView.animate(withDuration: 0.5, animations: {
            self.setView?.frame = CGRect(x:self.view.frame.size.width/2 - 160, y:-144.5, width:320, height:144.5)
            if self.avoidView != nil {
                self.avoidView?.removeFromSuperview()
                self.avoidView = nil
            }
            
        }) { (finish) in
            self.setView?.frame = CGRect(x:self.view.frame.size.width/2 - 160, y:-144.5, width:320, height:144.5)
            if self.avoidView != nil {
                self.avoidView?.removeFromSuperview()
                self.avoidView = nil
            }
        }
        
        
        
    }
    
    @objc func leftBtnAction(){
        NotificationCenter.default.post(name: Notification.Name(rawValue: kBaseFloatingDrawerNeedChangeSideStatus), object: nil)
        TBLEManager.sharedManager.scan(false)
        exchangeView(false)
    }

    /*
     蓝牙扫描界面按钮点击
     */
    @IBAction func scanBtnAction(_ sender: Any) {
        ProgressAnimateTool.tool.show(inView: view)
        exchangeView(true)
        deviceSearchVC!.scan()
        if !DeviceSearchVC.showBLEPowerState() {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC), execute: {
                self.exchangeView(false)
            })
        }
        
    }
    
    @IBAction func gpsBtnAction(_ sender: Any) {
        let mapView = MapViewController()
        self.navigationController?.pushViewController(mapView, animated: true)
    }
    
    @IBAction func feedBackBtnAction(_ sender: Any) {
        
        let vc = FeedbackVC()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func addListener(){
        NotificationCenter.default.addObserver(self, selector: #selector(hasDisconnect), name: NSNotification.Name(rawValue: "hasDisconnect"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeHomePageDeviceName), name: NSNotification.Name(rawValue: "changeHomePageDeviceName"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hasSacnDevices), name: NSNotification.Name(rawValue: "hasSacnDevices"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(StartCheckAuth), name: NSNotification.Name(rawValue: "StartCheckAuth"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showScanView), name: NSNotification.Name(rawValue: "hasScanNoDevices"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceSearchViewRemove), name: NSNotification.Name(rawValue: "deviceSearchViewRemove"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(boxAuthSuccess), name: NSNotification.Name(rawValue: "boxAuthSuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showAplyBindView), name: NSNotification.Name(rawValue: "showAplyBindView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addCurrentUserToBox), name: NSNotification.Name(rawValue: "boxHostAuthOk"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HasGetBoxHost), name: NSNotification.Name(rawValue: "HasGetBoxHost"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HasGetImei(_:)), name: NSNotification.Name(rawValue: "HasGetImei"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(boxAuthSuccess), name: NSNotification.Name(rawValue: "HasDeleteBoxHostWhenNotSync"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveBoxVersion(_:)), name: NSNotification.Name(rawValue: "HasGetBoxVersion"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorView), name: NSNotification.Name(rawValue: "showErrorView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceStatusUpdate), name: NSNotification.Name(rawValue: kBLENotiStatusUpdate), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deviceConnectUpdate), name: NSNotification.Name(rawValue: TBLEManager.sharedManager.kNotiBLEManagerConnectChanged), object: nil)
        //扫描到上次的设备
        NotificationCenter.default.addObserver(self, selector: #selector(hideScanAndSearchPage), name: NSNotification.Name(rawValue: "hasDiscoveLastDevice"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startRescan), name: NSNotification.Name(rawValue: kBluetoothNotiPowerChanged), object: nil)
        
        
        //升级完成后，返回界面，强制用户重新扫描
        NotificationCenter.default.addObserver(self, selector: #selector(reScan), name: nil, object: nil)
    }
    
    @objc func showErrorView(){
        avoidBtn?.isHidden = false
    }
    
    @objc func hideScanAndSearchPage () {
                setterBtn?.isHidden = false
                avoidBtn?.isHidden = true
                scanView.isHidden = true
                deviceTableContainer.isHidden = true
        
                controlView.isHidden = false
    }
    
    @objc func reScan(){
        
        if HomeControllerVC.updateFinish{
            
            HomeControllerVC.updateFinish = false

            TBluetooth.share().cancelReconnect(TBLEManager.sharedManager.dev?.device.peri)
            TBluetooth.share().cancelConnect(TBLEManager.sharedManager.dev?.device.peri)
            TBLEManager.sharedManager.connect(nil)
        }
        
    }
    
    @objc func saveBoxVersion(_ noti:Notification){
        
        boxVersion = noti.object as! String
        
    }

    
    @objc func HasGetBoxHost(_ noti:Notification){
        let hostStr = noti.object as! String
        hostNum = hostStr
    }
    
    @objc func HasGetImei(_ noti:Notification){
        
                    //检查箱子上有没有host
                    if self.hostNum != ""{
                        //箱子上有host，auth，再delete host
                        TBLEManager.sharedManager.dev?.status.auth(withBoxHostNum: self.hostNum)
                    }else{
                        //箱子上没有host
                        boxAuthSuccess()
                    }
        
    }
    
    @objc func hasDisconnect(){
        exchangeView(false)
        
        MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("HasDisconnect", comment: ""))
    }
    
    @objc func changeHomePageDeviceName(){
        deviceNameBtn.setTitle(TUser.boxName(), for: .normal)
    }
    
    @objc func hasSacnDevices(){
        if self.deviceSearchVC!.devices.count > 0 {
            ProgressAnimateTool.tool.dismiss()
        }
    }
    
    @objc func StartCheckAuth(){
        ProgressAnimateTool.tool.show(inView: view)
    }
    
    @objc func showAplyBindView(){
        let v:AplyBindView = Bundle.main.loadNibNamed("AplyBindView", owner: self, options: nil)!.last as! AplyBindView
        v.hostNum = hostNum
        v.isWorking = true
        PopTool.tool.show(inView: view, withView: v, width: 300, height: 266)
    }

    @objc func addCurrentUserToBox(){
        TBLEManager.sharedManager.dev?.status.addUser(withNum: TUser.userPhone())
    }
    
    @objc func boxAuthSuccess(){
        ProgressAnimateTool.tool.dismiss()
        
        PopTool.tool.dismiss()
        
        AvoidViewTool.tool.showInView(supView: self.view, title: NSLocalizedString("AuthSuccess", comment: ""))
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TheBagHasAuthSuccess"), object: nil)
        
        //保存uuID，下次自动扫描连接
        TUser.lastPeripheralUUID(TBLEManager.sharedManager.dev?.device.itendifyStr)
        
        
        //检查是否需要更新箱子代码
//                if TUser.isHost(){
//
//                    let time = DispatchTime.now() + Double(Int64(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
//                    DispatchQueue.main.asyncAfter(deadline: time) {
//
//                        _ = TDeviceManager.shared().getBoxVerision("box", comp: { (result) in
//                            if result.code == "2000"{
//                                let json = JSON(data: result.resp!.data!)
//                                let backVersion = json["result"]["data"]["code"].string!
//                                //解析box version
//                                let versionArray = self.boxVersion.components(separatedBy: ".")
//                                if Int(backVersion) > Int(versionArray[1]){
//
//                                    let urlStr:String = json["result"]["data"]["url"].string!
//                                    let url = urlStr.replacingOccurrences(of: "\\", with: "")
//                                    let alert = UIAlertController.init(title: NSLocalizedString("COWAROBOTAvoid", comment: ""), message: NSLocalizedString("UpdateAvoid", comment: ""), preferredStyle: .alert)
//                                    alert.addAction(UIAlertAction.init(title: NSLocalizedString("NO", comment: ""), style: .default, handler: { (UIAlertAction) in
//                                    }))
//                                    alert.addAction(UIAlertAction.init(title: NSLocalizedString("YES", comment: ""), style: .default, handler: { (UIAlertAction) in
//                                        let vc = UpdateVC()
//                                        vc.versionUrl = url
//                                        self.navigationController?.pushViewController(vc, animated: true)
//
//                                    }))
//                                    self.present(alert, animated: true, completion: nil)
//                                }
//                            }
//                        })
//                    }
//
//                }
    }
    
    @objc func deviceSearchViewRemove(){
        exchangeView(false)
    }
    
    @objc func deviceStatusUpdate(){
     
            deviceNameBtn.setTitle(TUser.boxName()!, for: .normal)
        
            if let battery = TBLEManager.sharedManager.dev?.status.battery {
                capcityLabel.text = String.init(format: NSLocalizedString("Capcity", comment: "") + ":%lu%%", battery)
                
                
                if 0 < battery && battery < 20 {
                    
                    capcityOutSideImageView.image = UIImage(named:"红色电池框")
                    
                    capcityLabel.textColor = UIColor.red
                    
                    capcityShowView?.frame = CGRect(x:0,y:0,width:Int((CGFloat(battery)/100)*28),height:9)
                    
                    
                    
                    capcityShowView?.backgroundColor = UIColor.init(red: 227/255, green: 34/255, blue: 31/255, alpha: 1.0)
                    
                }else if 20 <= battery && battery <= 100 {
                    
                    capcityOutSideImageView.image = UIImage(named:"电池框")
                    
                    capcityLabel.textColor = UIColor.init(red: 109/255, green: 148/255, blue: 179/255, alpha: 1.0)
                    
                    capcityShowView?.frame = CGRect(x:0,y:0,width:Int((CGFloat(battery)/100)*28),height:9)
                    
                    
                    
                    capcityShowView?.backgroundColor = UIColor.init(red: 27/255, green: 120/255, blue: 169/255, alpha: 1.0)
                    
                    print(capcityShowView!)
            
                    
                }else {
                    capcityOutSideImageView.image = UIImage(named:"电池框")
                    
                    capcityShowView?.backgroundColor = UIColor.clear
                }
                
                
            }


            if let speed = TBLEManager.sharedManager.dev?.status.speed {
                speedLabel.text = String.init(format: "%.1f", 3.6*(Double(speed)/1000.000))
            }


            if let mileage = TBLEManager.sharedManager.dev?.status.mileage {
                lichengLabel.text = String.init(format: "%.1f", Double(mileage)/1000.000)
            }
        
        if let dev = TBLEManager.sharedManager.dev {
            if dev.status.misLock {
               
                lockBtn.setImage(UIImage(named:"智能锁关"), for: .normal)
            }else{
               
                lockBtn.setImage(UIImage(named:"智能锁开-释放"), for: .normal)
            }
        }

        
        
//        if let dev = TBLEManager.sharedManager.dev {
//            if dev.status.followStatus {
//                self.BreatheBtn.isHidden = false
//            }else{
//                self.BreatheBtn.isHidden = true
//            }
//        }
        
    }
    
    @objc func deviceConnectUpdate(){
        exchangeView(false)
    }
    
    @objc func showScanView(){
        exchangeView(false)
    }
    
    func exchangeView(_ showSearchTable: Bool) {
        if showSearchTable {
            scanView.isHidden = true
            deviceTableContainer.isHidden = false
            controlView.isHidden = true
         
        } else {
            TBLEManager.sharedManager.scan(false)
            if nil != TBLEManager.sharedManager.dev {
                setterBtn?.isHidden = false
                avoidBtn?.isHidden = true
                scanView.isHidden = true
                deviceTableContainer.isHidden = true
                
                controlView.isHidden = false
                
            } else {
                PopTool.tool.dismiss()
                ProgressAnimateTool.tool.dismiss()
                setterBtn?.isHidden = true
                avoidBtn?.isHidden = true
                controlView.isHidden = true
                scanView.isHidden = false
               
                deviceTableContainer.isHidden = true
            }
        }
    }
    
    /*
     设备控制界面按钮点击
     */
    @IBAction func deviceNameBtnAction(_ sender: Any) {
        
    let v:SetDeviceName = Bundle.main.loadNibNamed("SetDeviceName", owner: self, options: nil)!.last as! SetDeviceName
    PopTool.tool.show(inView: view, withView: v, width: 300, height: 243)
        
    }
    
    //弹出绑定手环框
    @objc func tapSingleDid(){
        let alertController = UIAlertController(title: "绑定手环",
                                                message: "请输入手环编码后六位号码", preferredStyle: .alert)
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "请输入编码"
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "绑定", style: .default, handler: {
            action in
            let password = alertController.textFields!.first!
            //发送指令
            if password.text?.count != 0 {
                if let dev = TBLEManager.sharedManager.dev {
                    dev.status.bindHandleRing(withNum: password.text!)
                }
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func lockBtnAction(_ sender: Any) {
        
        if let dev = TBLEManager.sharedManager.dev {
            
            if dev.status.mSecLock {
                //提示用户锁出错
                MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("CloseSecuryLock", comment: ""))
                
                if !(dev.status.misLock) {
                    dev.status.setLockM(!(dev.status.misLock))
                }
                
            }else{
                dev.status.setLockM(!(dev.status.misLock))
            }
            
        }
        
    }
    
    //丢失报警
    @IBAction func KeepSnakeSwitch(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            SnakeBtn.setBackgroundImage(UIImage(named:"dropWarn_open"), for: .normal)
        }else{
            SnakeBtn.setBackgroundImage(UIImage(named:"dropWarn_close"), for: .normal)
        }
        TBLEManager.sharedManager.keepSnakeWarning = sender.isSelected
    }
    
    //跟随提醒
    @IBAction func breatheSwitch(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected  {
            SnakeBtn.isSelected = true
            SnakeBtn.setBackgroundImage(UIImage(named:"dropWarn_open"), for: .normal)
            TBLEManager.sharedManager.keepSnakeWarning = true
            TBLEManager.sharedManager.FirstLocalNoti = false
        }
        if sender.isSelected {
            BreatheBtn.setBackgroundImage(UIImage(named:"breatheWarn_open"), for: .normal)
            
        }else{
            BreatheBtn.setBackgroundImage(UIImage(named:"breatheWarn_close"), for: .normal)
        }
        TBLEManager.sharedManager.openBoxFollow = sender.isSelected;
        
    }
    
    @IBAction func flyBtnAction(_ sender: Any) {
        let v:SelectCard = Bundle.main.loadNibNamed("SelectCard", owner: self, options: nil)!.last as! SelectCard
        PopTool.tool.show(inView: view, withView: v, width: 300, height: 177)
    }
    
//    @IBAction func locationBtnAction(_ sender: Any) {
//        let mapView = MapViewController()
//        self.navigationController?.pushViewController(mapView, animated: true)
//    }
    
    @IBAction func feedBtnAction(_ sender: Any) {
        let vc = FeedbackVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func remoteControlEvent(_ sender: Any) {
        
        if let dev = TBLEManager.sharedManager.dev {
            if dev.status.followStatus {
                MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("pleaseCloseFollow", comment: ""))
                return
            }
        }
        
        self.navigationController?.pushViewController(RemoteControlVC(), animated: false)
    }
    
    //    @IBAction func followBtnAction(_ sender: Any) {
//
//        if let dev = TBLEManager.sharedManager.dev {
//
//            dev.status.setFollow(!(dev.status.followStatus))
//
//        }
//
//    }
    
    func getLocalLanguage() -> String{
        let defs = UserDefaults.standard
        let languages = defs.object(forKey: "AppleLanguages")
        let preferredLanguage = (languages! as AnyObject).object(at: 0)
        return String(describing: preferredLanguage)
    }
}
