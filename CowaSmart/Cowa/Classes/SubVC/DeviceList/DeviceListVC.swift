//
//  DeviceListVC.swift
//  Cowa
//
//  Created by gaojun on 2017/9/6.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit
import DynamicButton
import CowaBLELib

class DeviceListVC: SubVC,UITableViewDelegate, UITableViewDataSource, CancelBondOKDelegate{

    @IBOutlet weak var deviceListLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var point:CGPoint?
    
    var deviceList: Array<MDevice> = Array() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refresh()
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageV = UIImageView(image: UIImage(named:"登录页面-背景图"))
        imageV.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        view.insertSubview(imageV, at: 0)
        deviceListLabel.text = NSLocalizedString("MenuDeviceList", comment: "")
        self.isNavRoot = true
        createNavi()

        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "DeviceListCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cellid")
        
        NotificationCenter.default.addObserver(self, selector: #selector(editBtnAction), name: NSNotification.Name(rawValue: "editBtnAction"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editCancelBtnAction), name: NSNotification.Name(rawValue: "cancelBtnAction"), object: nil)
    }
    
    func createNavi(){
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        
        let imageView = UIImageView.init(frame: CGRect(x:0,y:0,width:125,height:15))
        imageView.image = UIImage(named:"左侧栏LOGO")
        self.navigationItem.titleView = imageView
    }
    
    @objc func editBtnAction(){
        tableView.setEditing(true, animated: true)
    }
    
    @objc func editCancelBtnAction(){
        tableView.setEditing(false, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return deviceList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid") as! DeviceListCell
        
        for subView in cell.contentView.subviews {
            if subView is UIButton {
                let btn:UIButton = subView as! UIButton
                btn.setTitle(NSLocalizedString("ShareList", comment: ""), for: .normal)
                btn.tag = indexPath.section
                btn.addTarget(self, action: #selector(shareBtnAction(_:)), for: .touchUpInside)
            }
        }
        
        
        let name = self.deviceList[indexPath.section].device_name
        cell.deviceNameLabel.text = name
        cell.selectionStyle = .none
        
        let host = self.deviceList[indexPath.section].isHost as String
        let imei = self.deviceList[indexPath.section].device_IMEI as String
        
        let dev = TBLEManager.sharedManager.dev
        let currentImei = dev?.status.imeiString
        
        if host == "1" {
            
            cell.myImageView.image = UIImage(named: "设备列表-主-图标")
            if imei == currentImei {
                cell.deviceNameLabel?.textColor = UIColor.blue
                
            }
        } else {
            cell.myImageView?.image = UIImage(named: "设备列表-分享-图标")
            cell.shareBtn.isHidden = true
            cell.jiantouImage.isHidden = true
            
            if imei == currentImei {
                cell.deviceNameLabel?.textColor = UIColor.init(red: 44/255, green: 131/255, blue: 246/255, alpha: 1.0)
            }
        }
        
        cell.contentView.backgroundColor = UIColor.clear
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 53
        }
        
        return 12.5
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
           
            if let deviceListHeaderView = Bundle.main.loadNibNamed("DeviceListHeader", owner: self, options: nil)?.last {
                let view1 = deviceListHeaderView as! DeviceListHeader
                view1.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: 38)
                view1.backgroundColor = UIColor.clear
                return view1
            }
            
           return nil
            
        }else{
            return nil
        }
        
    }
    
    @objc func shareBtnAction(_ sender:UIButton){
        let host = self.deviceList[sender.tag].isHost as String
        if host == "1" {
            let  vc = BindSettingVC()
            vc.deviceImei = self.deviceList[sender.tag].device_IMEI
            vc.deviceName = self.deviceList[sender.tag].device_name
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let host = self.deviceList[indexPath.section].isHost as String
        if host == "1" {
            let  vc = BindSettingVC()
            vc.deviceImei = self.deviceList[indexPath.section].device_IMEI
            vc.deviceName = self.deviceList[indexPath.section].device_name
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let host = self.deviceList[indexPath.section].isHost as String
        let imei = self.deviceList[indexPath.section].device_IMEI as String
        
        let dev = TBLEManager.sharedManager.dev
        let currentImei = dev?.status.imeiString
        
        if host == "1" || ( host == "0" && imei == currentImei){
            return true
        }else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let imei = self.deviceList[indexPath.section].device_IMEI as String
        
        let dev = TBLEManager.sharedManager.dev
        let currentImei = dev?.status.imeiString
        
       
            if imei == currentImei {
                //本地解绑
                
                let deleteBtn = UITableViewRowAction.init(style: .normal, title: NSLocalizedString("CancelBind", comment: "")) { (action, indexPath) in
                    ProgressAnimateTool.tool.show(inView: self.view)
                    
                    _ = TDeviceManager.shared().unbond(TUser.userPhone(), imei: imei, comp: { (result) in
                        
                        if result.code == "2000" {
                            
                          
                            
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "deleteUserSuccess"), object: nil)
                            
                            TBLEManager.sharedManager.dev?.status.delUser(withNum: TUser.userPhone())
                            
                            self.deleteUser()
                            
                            WatchDog.dog.stop()
                            
                        }else{
                            
                            ProgressAnimateTool.tool.dismiss()
                            
                            MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("CancelBondFalse", comment: ""))
                        }
                    })
                }
                deleteBtn.backgroundColor = UIColor.init(red: 104/255, green: 150/255, blue: 198/255, alpha: 1.0)
                return [deleteBtn]
                
                
            }else {
                //远程解绑
                let deleteBtn = UITableViewRowAction.init(style: .normal, title: NSLocalizedString("RemoteCancelBind", comment: "")) { (action, indexPath) in
                    let v:RemoteCancelBindView = Bundle.main.loadNibNamed("RemoteCancelBindView", owner: self, options: nil)!.last as! RemoteCancelBindView
                    v.imeiStr = self.deviceList[indexPath.section].device_IMEI
                    v.refreshDelegate = self
                    PopTool.tool.show(inView: (self.parent?.view)!, withView: v, width: 300, height: 248)
                }
                deleteBtn.backgroundColor = UIColor.init(red: 104/255, green: 150/255, blue: 198/255, alpha: 1.0)
                return [deleteBtn]
            }
    
    }
    
    func refresh() {
        TDeviceManager.shared().originGetDevices { (list) in
            self.deviceList = list
        }
    }

    
    func deleteUser(){
        
        ProgressAnimateTool.tool.dismiss()
        
        MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("CancelBondOK", comment: ""))
        
        let time = DispatchTime.now() + Double(Int64(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            TBluetooth.share().cancelReconnect(TBLEManager.sharedManager.dev?.status.device.peri)
            TBluetooth.share().cancelConnect(TBLEManager.sharedManager.dev?.status.device.peri)
            TBLEManager.sharedManager.connect(nil)
        }
        
        refresh()
    }
    
    func refreshDeviceList() {
        refresh()
    }

    @IBAction func cancalBtnAction(_ sender: Any) {
        
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
