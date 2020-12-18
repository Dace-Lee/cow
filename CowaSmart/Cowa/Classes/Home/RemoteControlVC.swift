//
//  RemoteControlVC.swift
//  Cowa
//
//  Created by gaojun on 2018/8/27.
//  Copyright © 2018年 MX. All rights reserved.
//

import UIKit
import DynamicButton
import CowaBLELib

class RemoteControlVC: UIViewController {
    
    var capcityShowView: UIView?
    
    @IBOutlet weak var deviceNameBtn: UIButton!
    @IBOutlet weak var capView: UIView!
    @IBOutlet weak var capcityInsideView: UIView!
    @IBOutlet weak var capcityOutSideImageView: UIImageView!
     @IBOutlet weak var capcityLabel: UILabel!
    /*
     遥控界面
     */
   
    @IBOutlet weak var remoteControlSmallBtn: UIImageView!
    @IBOutlet weak var closeArrowIV: UIImageView!
    @IBOutlet weak var openArrowIV: UIImageView!
    @IBOutlet weak var remoteControlBackView: UIImageView!
    //on文字
    @IBOutlet weak var onLabel: UIImageView!
    @IBOutlet weak var offLabel: UIImageView!
    @IBOutlet weak var switchCircle: UIImageView!
    @IBOutlet weak var switchBtn: UIButton!
    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var timer = Timer()
    var isTouch:Bool = false
    var speedx:Float = 0.0
    var speedy:Float = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        deviceNameBtn.setTitle(TUser.boxName()!, for: .normal)
        
        capcityShowView = UIView.init(frame: CGRect(x:0,y:0,width:28,height:9))
        capcityShowView?.backgroundColor = UIColor.clear
        capcityInsideView.addSubview(capcityShowView!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceStatusUpdate), name: NSNotification.Name(rawValue: kBLENotiStatusUpdate), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createNaviGationBar()
        
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        
        let imageV = UIImageView(image: UIImage(named:"登录页面-背景图"))
        imageV.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        imageV.isUserInteractionEnabled = true
        view.insertSubview(imageV, at: 0)
        
        closeArrowIV.isUserInteractionEnabled = true
        openArrowIV.isUserInteractionEnabled = true
        remoteControlBackView.isUserInteractionEnabled = true
        remoteControlSmallBtn.isUserInteractionEnabled = true
        
        let ge = UIPanGestureRecognizer.init(target: self, action: #selector(panDid(_:)))
        ge.maximumNumberOfTouches = 1
        remoteControlSmallBtn.addGestureRecognizer(ge)
        
        switchLabel.text = NSLocalizedString("remoteControlSwitch", comment: "")
        descriptionLabel.text = NSLocalizedString("remoteControlDetail", comment: "")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews();
        if UIScreen.main.bounds.height == 812 {//iphoneX
            deviceNameBtn.frame = CGRect(x:deviceNameBtn.frame.origin.x,y:108.0,width:deviceNameBtn.frame.size.width,height:deviceNameBtn.frame.size.height)
            capView.frame = CGRect(x:capView.frame.origin.x,y:149.0,width:capView.frame.size.width,height:capView.frame.size.height)
            capcityLabel.frame = CGRect(x:capcityLabel.frame.origin.x,y:169.0,width:capcityLabel.frame.size.width,height:capcityLabel.frame.size.height)
            
        }
    }
    
    @objc func panDid(_ recognizer:UISwipeGestureRecognizer){
        let point=recognizer.location(in: self.view)
        
        if switchBtn.isSelected {
            let p1 = (x:point.x,y:point.y)
            let p2 = (x:remoteControlBackView.center.x,y:remoteControlBackView.center.y)
            
            let distance = sqrt(pow((p1.x - p2.x), 2) + pow((p1.y - p2.y), 2))
            
            if distance <= 150 {
                remoteControlSmallBtn.center = point
                
                isTouch = true
                
                anlyseSpeed()
                
                timer.fireDate = NSDate.distantPast
                
            }else if distance > 150 {
                let btnX = ((point.x - remoteControlBackView.center.x) / distance ) * 150 + remoteControlBackView.center.x
                let btnY = ((point.y - remoteControlBackView.center.y) / distance ) * 150 + remoteControlBackView.center.y
                remoteControlSmallBtn.center.x = btnX
                remoteControlSmallBtn.center.y = btnY
                
                isTouch = true
                
                anlyseSpeed()
                
                timer.fireDate = NSDate.distantPast
                
            }
            
            
            if recognizer.state == .ended {
                isTouch = false
                
                remoteControlSmallBtn.center = remoteControlBackView.center
            }
        }
        
        
    }
    
    func createNaviGationBar(){
        let btn: DynamicButton? = DynamicButton.init(style: .caretLeft)
        btn?.addTarget(self, action: #selector(leftBtnAction), for: .touchUpInside)
        btn?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btn?.strokeColor = UIColor.white
        let item1=UIBarButtonItem(customView: btn!)
        self.navigationItem.leftBarButtonItem = item1
        
        let imageView = UIImageView.init(frame: CGRect(x:0,y:0,width:125,height:15))
        imageView.image = UIImage(named:"左侧栏LOGO")
        self.navigationItem.titleView = imageView
    }
    
    func leftBtnAction(){
        TBLEManager.sharedManager.dev?.status.wheelUp()
        timer.fireDate = NSDate.distantFuture
        
        _ = self.navigationController?.popViewController(animated: false)
    }

    func addTimer(){
        
        timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(sendSpeed), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .commonModes)
        timer.fireDate = NSDate.distantPast
    }
    
    func sendSpeed(){
        if isTouch {
            if let dev = TBLEManager.sharedManager.dev {
                dev.status.remoteControl(withFloatX: speedx, floatY: speedy)
            }
        }
    }
    
    func anlyseSpeed(){
        var X:Float = 0
        var Y:Float = 0
        
        let width:Float = Float(remoteControlBackView.frame.size.width)
        // let height:Float = Float(remoteControlBackView.frame.size.height)
        
        let moveBtnX:Float = Float(remoteControlSmallBtn.center.x)
        let moveBtnY:Float = Float(remoteControlSmallBtn.center.y)
        
        let bx:Float = Float(remoteControlBackView.frame.origin.x)
        let by:Float = Float(remoteControlBackView.frame.origin.y)
        
        
        if moveBtnX > bx + width / 2 && moveBtnY < width / 2 + by {
            X = -(moveBtnX - (bx + width/2))
            Y = ((width/2+by) - moveBtnY)
        }else if moveBtnX < bx + width / 2 && moveBtnY < width / 2 + by {
            X = ((bx+width/2)-moveBtnX)
            Y = ((width/2+by) - moveBtnY)
        }else if moveBtnX < bx + width / 2 && moveBtnY > width / 2 + by {
            X = -((bx+width/2)-moveBtnX)
            Y = (by+width/2) - moveBtnY
        }else if moveBtnX > bx + width / 2 && moveBtnY > width / 2 + by {
            X = moveBtnX - (bx + width/2)
            Y = (by+width/2) - moveBtnY
        }
        
        if abs(Int(X-(bx+width/2))) <= 10 {
            X = 0
        }
        
        if abs(Int(Y-(by+width/2))) <= 10 {
            Y = 0
        }
        
        if X > width/2 {
            X = width/2
        }
        if X < -width/2 {
            X = -width/2
        }
        if Y > width/2 {
            Y = width/2
        }
        if Y < -width/2 {
            Y = -width/2
        }
        
        speedx = (X*100/150)*0.7
        speedy = (Y*100/150)*0.7
        
        print("*************\(speedx)****\(speedy)")
    }
    
    @IBAction func remoteSwitchAction(_ sender: Any) {
        let btn = sender as! UIButton
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            
            UIView.animate(withDuration: 0.5, animations: {
                var frame = self.switchCircle.frame
                frame.origin.x = self.switchBtn.frame.maxX - 31
                self.switchCircle.frame = frame
                
                self.closeArrowIV.alpha = 0
                self.openArrowIV.alpha = 1
                self.remoteControlSmallBtn.image = UIImage(named:"开-控制按钮")
                
                self.onLabel.isHidden = false
                self.offLabel.isHidden = true
                self.switchLabel.isHidden = false
            }) { (finish) in
                
            }
            
            TBLEManager.sharedManager.dev?.status.wheelDown()
            
            addTimer()
            
        }else{
            
            UIView.animate(withDuration: 0.5, animations: {
                var frame = self.switchCircle.frame
                frame.origin.x = self.switchBtn.frame.origin.x + 11
                self.switchCircle.frame = frame
                
                self.closeArrowIV.alpha = 1
                self.openArrowIV.alpha = 0
                self.remoteControlSmallBtn.image = UIImage(named:"遥控-关-控制按钮")
                
                self.onLabel.isHidden = true
                self.offLabel.isHidden = false
                self.switchLabel.isHidden = true
            }) { (finish) in
                
            }
            
            TBLEManager.sharedManager.dev?.status.wheelUp()
            timer.fireDate = NSDate.distantFuture
        }
    }
    
    func deviceStatusUpdate(){
        
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
                
                
                
            }else {
                capcityOutSideImageView.image = UIImage(named:"电池框")
                
                capcityShowView?.backgroundColor = UIColor.clear
            }
            
            
        }
        
        
        
    }

}
