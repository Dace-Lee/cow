//
//  BindSettingVC.swift
//  Cowa
//
//  Created by gaojun on 2017/9/12.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit
import DynamicButton

class BindSettingVC: UIViewController, UITableViewDelegate, UITableViewDataSource, AddFriendOKDelegate {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var deviceName:String = ""
    var deviceImei:String = ""
    
    var frendsList: Array<FrendsModel> = Array() {
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
        
        titleLabel.text = NSLocalizedString("BindSetting", comment: "")
        title = NSLocalizedString("BindSetting", comment: "")
        let imageV = UIImageView(image: UIImage(named:"登录页面-背景图"))
        imageV.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        view.insertSubview(imageV, at: 0)
        
        createNavi()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "BindSettingCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cellid")
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteFriends), name: NSNotification.Name(rawValue: "deleteFriends"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cancelDeleteFriends), name: NSNotification.Name(rawValue: "cancelDeleteFriends"), object: nil)
        
    }
    
    @objc func deleteFriends(){
        tableView.setEditing(true, animated: true)
    }
    
    @objc func cancelDeleteFriends(){
        tableView.setEditing(false, animated: true)
    }
    
    func createNavi(){
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        
        let imageView = UIImageView.init(frame: CGRect(x:0,y:0,width:125,height:15))
        imageView.image = UIImage(named:"左侧栏LOGO")
        self.navigationItem.titleView = imageView
        
        let btn: DynamicButton? = DynamicButton.init(style: .caretLeft)
        btn?.addTarget(self, action: #selector(leftBtnAction), for: .touchUpInside)
        btn?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btn?.strokeColor = UIColor.white
        let item1=UIBarButtonItem(customView: btn!)
        self.navigationItem.leftBarButtonItem = item1
    }
    
    @objc func leftBtnAction(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return frendsList.count
        }else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid") as! BindSettingCell
        
        if indexPath.section == 0 {
            
            cell.picImageView.image = UIImage(named:"绑定设置-主-图标")
            cell.nameLabel.text = deviceName
            
        }else if indexPath.section == 1 {
            
            let host = self.frendsList[indexPath.row].isHost as String
            if host == "1" {
                cell.picImageView.image = UIImage(named:"绑定设置-主-图标")
                cell.nameLabel.text = NSLocalizedString("ME", comment: "")
            }else{
                cell.picImageView.image = UIImage(named:"绑定设置-分享-图标")
                cell.nameLabel.text = self.frendsList[indexPath.row].userPhone
               
            }
            
        }else{
            cell.picImageView.image = UIImage(named:"添加好友图标-释放")
            cell.nameLabel.text = ""
            cell.imageView?.isUserInteractionEnabled = true
            
            let tapSingle = UITapGestureRecognizer(target:self,action:#selector(addBtnAction2))
            cell.imageView?.addGestureRecognizer(tapSingle)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 48
        }
        return 38
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            addBtnAction2()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            if let deviceListHeaderView = Bundle.main.loadNibNamed("BindSettingHeaderViewOne", owner: self, options: nil)?.last {
                let view1 = deviceListHeaderView as! BindSettingHeaderViewOne
                view1.headerTitleLabel.text = NSLocalizedString("MyBag", comment: "")
                view1.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: 38)
                view1.backgroundColor = UIColor.clear
                return view1
            }
            
            return nil
        }else if section == 1{
            
            if let deviceListHeaderView = Bundle.main.loadNibNamed("BindSettingHeaderViewTwo", owner: self, options: nil)?.last {
                let view1 = deviceListHeaderView as! BindSettingHeaderViewTwo
                view1.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: 38)
                view1.backgroundColor = UIColor.clear
                return view1
            }
            
            return nil
        }else if section == 2{
            
            if let deviceListHeaderView = Bundle.main.loadNibNamed("BindSettingHeaderViewOne", owner: self, options: nil)?.last {
                let view1 = deviceListHeaderView as! BindSettingHeaderViewOne
                view1.headerTitleLabel.text = NSLocalizedString("AddBindFriends", comment: "")
                view1.frame = CGRect(x: 0,y: 0,width: self.view.frame.width,height: 38)
                view1.backgroundColor = UIColor.clear
                return view1
            }
            
            return nil
        }else{
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            let host = self.frendsList[indexPath.row].isHost as String
            if host != "1" {
                return true
            }else{
                return false
            }
        }else{
            return false
        }
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
            let deleteBtn = UITableViewRowAction.init(style: .normal, title: NSLocalizedString("Delete", comment: "")) { (action, indexPath) in
               
                ProgressAnimateTool.tool.show(inView: self.view)
                
                _ = TDeviceManager.shared().deleteFriend(TUser.userPhone(), imei: self.deviceImei, publicUser: self.frendsList[indexPath.row].userPhone, comp: { (result) in
                    
                    
                    if result.code == "2000" {
                        
                        ProgressAnimateTool.tool.dismiss()
                        
                      
                        
                        MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("DeviceRemoved", comment: ""))
                        
                        
                    }else{
                        
                        ProgressAnimateTool.tool.dismiss()
                        
                        MyInfoTool.tool.showInView(supView: self.view, title: NSLocalizedString("DeviceRemoveFailed", comment: ""))
                        
                    }
                    self.refresh()
                })

                
            }
        deleteBtn.backgroundColor = UIColor.init(red: 104/255, green: 150/255, blue: 198/255, alpha: 1.0)
        return [deleteBtn]
        
    }

    @objc func addBtnAction2(){
        let v:AddFriendsView = Bundle.main.loadNibNamed("AddFriendsView", owner: self, options: nil)!.last as! AddFriendsView
        v.delegate = self
        v.imeiStr  = self.deviceImei
        PopTool.tool.show(inView: (self.parent?.view)!, withView: v, width: 300, height: 242)
    }
    
    func refresh() {
        TDeviceManager.shared().originGetFrends(TUser.userPhone(), imei: deviceImei) { (list) in
            self.frendsList = list
        }
    }
    
    func refreshFriendList() {
        refresh()
    }

    @IBAction func cancelBtnAction(_ sender: Any) {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }

}
