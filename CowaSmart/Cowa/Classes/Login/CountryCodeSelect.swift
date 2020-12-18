//
//  CountryCodeSelect.swift
//  Cowa
//
//  Created by gaojun on 2017/9/5.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit
import DynamicButton

protocol CountryCodeDelegate {
    func sendCountryCode(_ code:String, country:String) -> String
}

class CountryCodeSelect: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate:CountryCodeDelegate?
    
    var data:NSDictionary?
    var smallDic:NSMutableDictionary?
    var bigArray:NSMutableArray?
    var titleArray:NSArray?
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleArray = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","Y","Z"]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let imageV = UIImageView(image: UIImage(named:"登录页面-背景图"))
        imageV.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        view.insertSubview(imageV, at: 0)
        titleLabel.text = NSLocalizedString("SelectCountryCode", comment: "")
        
        bigArray = NSMutableArray()
        readyData()
        
//        let backBtn = UIButton.init(type: .custom)
//        backBtn.frame = CGRect(x:26,y:34,width:20,height:20)
//        backBtn.setImage(UIImage(named:"后退箭头"), for: .normal)
//        backBtn.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
//        view.addSubview(backBtn)
        
        createNavi()
    }
    
    func createNavi(){
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        
        let imageView = UIImageView.init(frame: CGRect(x:0,y:0,width:125,height:15))
        imageView.image = UIImage(named:"左侧栏LOGO")
        self.navigationItem.titleView = imageView
        
        let btn: DynamicButton? = DynamicButton.init(style: .caretLeft)
        btn?.addTarget(self, action: #selector(popViewController), for: .touchUpInside)
        btn?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btn?.strokeColor = UIColor.white
        let item1=UIBarButtonItem(customView: btn!)
        self.navigationItem.leftBarButtonItem = item1
    }
    
    func popViewController(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func readyData(){
        //初始化数据
        self.data=NSDictionary.init(contentsOfFile: Bundle.main.path(forResource: "CountryCode", ofType: "plist")!)
        let dictKeys = (self.data?.allKeys)! as NSArray
        let resultkArray:NSArray = GJTool.arraySorted(dictKeys as [AnyObject]) as NSArray
        for item in resultkArray {
            smallDic = NSMutableDictionary.init(dictionary: self.data?.object(forKey: item as! String) as! NSMutableDictionary)
            bigArray?.add(smallDic!)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return ((bigArray?.object(at: section) as AnyObject).count)!
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.titleArray?.count)!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleArray?.object(at: section) as? String
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return titleArray as? Array
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let identify:String = "swiftCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identify)
        if  cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: identify)
        }
        let dic = bigArray?.object(at: indexPath.section) as! NSDictionary
        let keyArray = dic.allKeys as NSArray
        cell?.textLabel?.text = keyArray[indexPath.row] as? String
        cell?.detailTextLabel?.text = dic.object(forKey: keyArray[indexPath.row] as! String) as? String
        cell?.contentView.backgroundColor = UIColor.clear
        cell?.backgroundColor = UIColor.clear
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        self.tableView!.deselectRow(at: indexPath, animated: true)
        
        let dic = bigArray?.object(at: indexPath.section) as! NSDictionary
        let keyArray = dic.allKeys as NSArray
        _ = self.delegate?.sendCountryCode((dic.object(forKey: keyArray[indexPath.row] as! String) as? String)!, country: (keyArray[indexPath.row] as? String)!)
        
        _ = self.navigationController?.popViewController(animated: true)
    }



}
