//
//  DeviceSearchVC.swift
//  Cowa
//
//  Created by gaojun on 2017/9/6.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit
import CowaBLELib
import SVProgressHUD

class DeviceSearchVC: UIViewController, UITableViewDataSource, UITableViewDelegate{

    enum PageType {
        case normal, wicket
    }
    
    var pageType: PageType = .normal
    
    @IBOutlet weak var tableView: UITableView!
    
    var devices: [TBLEDevice] = Array() {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "hasSacnDevices"), object: nil)
            
            tableView.reloadData()
        }
    }
    
    var deviceChanged: (() -> Void)?
    
    var noDeviceSearched: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addListener()
        
        view.backgroundColor = UIColor.clear
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: "DeviceSearchCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cellid")
        
        if pageType == .normal {
            self.title = NSLocalizedString("DeviceAddANewCOWA", comment: "")
            noDeviceSearched = {
                _ = self.navigationController?.popViewController(animated: true)
            }
            
            scan()
        }
        
    }
    
    deinit { removeListener() }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.devices.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid") as! DeviceSearchCell
        let aDevice:TBLEDevice = devices[indexPath.section]
        
        cell.namaLabel.text = NSLocalizedString("DeviceDeviceName", comment: "") + ":"
        cell.deviceNameLabel.text = aDevice.name
        cell.identifyLabel.text = devices[indexPath.section].itendifyStr
        cell.contentView.backgroundColor = UIColor.clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let device = devices[indexPath.section]
        TBLEManager.sharedManager.connect(device)
        
        let itendifyStr:String = devices[indexPath.section].itendifyStr
        UserDefaults.standard.set(itendifyStr, forKey: "uuid")
        
        TUser.boxName(devices[indexPath.section].name)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        }
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    
    @objc func eNotiDeviceSearched() {
        
        if TBLEManager.sharedManager.devices.count > 0 {
    
            self.devices = TBLEManager.sharedManager.devices
        }
        
    }
    
    class func showBLEPowerState() -> Bool {
        if !TBluetooth.share().bleAvaliable {
            let mesg = NSLocalizedString("SystemTipFailToRequestBluetoothPermission", comment: "")
            SVProgressHUD.showError(withStatus: mesg)
        }
        return TBluetooth.share().bleAvaliable
    }
    
    func scan() {
        self.devices.removeAll()
        _ = DeviceSearchVC.showBLEPowerState()
        TBluetooth.share().startScan()
        let time = DispatchTime.now() + Double(Int64(15 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            if self.devices.count == 0 {
                TBLEManager.sharedManager.scan(false)
                //没有扫描到设备，通知主界面
                NotificationCenter.default.post(name: Notification.Name(rawValue: "hasScanNoDevices"), object: nil)
            }
        }
    }
    
    fileprivate func addListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(eNotiDeviceSearched), name: NSNotification.Name(rawValue: kBluetoothNotiDeviceChanged), object: nil)
    }
    
    fileprivate func removeListener() {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func cancelBtnDid(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "deviceSearchViewRemove"), object: nil)
    }

    

}
