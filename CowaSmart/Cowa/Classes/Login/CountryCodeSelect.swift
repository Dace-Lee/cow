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
    
    @objc func popViewController(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func readyData(){
        //初始化数据
//        self.data=NSDictionary.init(contentsOfFile: Bundle.main.path(forResource: "CountryCode", ofType: "plist")!)
//        let dictKeys = (self.data?.allKeys)! as NSArray
//        let resultkArray:NSArray = GJTool.arraySorted(dictKeys as [AnyObject]) as NSArray
//        for item in resultkArray {
//            smallDic = NSMutableDictionary.init(dictionary: self.data?.object(forKey: item as! String) as! NSMutableDictionary)
//            bigArray?.add(smallDic!)
//        }
        bigArray = NSMutableArray(array: [["Afghanistan":"93","Alaska":"1907","Albania":"355","Algeria":"213","American Samoa":"684","Angola":"244","Anguilla":"1809","Argentina":"54","Aruba":"297","Ascension Island":"247","Australia":"61","Austria":"43"],["Bahamas":"1809","Bahrain":"973","Bangladesh":"880","Barbados":"1809","Belgium":"32","Belize":"501","Benin":"229","Bhutan":"975","Bolivia":"591","Botswana":"267","Brazil":"55","Brunei":"673","Bulgaria":"359","Burkina Faso":"226","Burundi":"257"],["Cambodia":"855","Cameroon":"237","Canada":"1","Cape Verde":"238","Central African Republic":"236","Chad":"235","Chile":"56","China":"86","Christmas Island":"6724","Coate d'Ivoire":"225","Cocos Island":"6722","Colombia":"57","Comoros":"269","Congo":"243","Cook Islands":"682","Costa Rica":"506","Cuba":"53","Cyprus":"357"],["Denmark":"45","Djibouti":"253"],["Ecuador":"593","Egypt":"20","El Salvador":"503","Equatorial Guinea":"240","Ethiopia":"251"],["Faroe Islands":"298","Fiji":"679","Finland":"358","France":"33","French Guiana":"594"],["Gabon":"241","Gambia":"220","Germany":"49","Ghana":"233","Gibraltar":"350","Greece":"30","Greenland":"299","Guam":"671","Guatemala":"502","Guinea":"224","Guinea-Bissau":"245","Guyana":"592"],["Haiti":"509","Hawaii":"1808","Honduras":"504","Hong Kong":"852","Hungary":"336"],["Iceland":"354","India":"91","Indonesia":"62","Iran":"98","Iraq":"964","Ireland":"353","Islas Malvinas":"500","Israel":"972","Italy":"39"],["Jamaica":"1809","Japan":"81","Jordan":"962"],["Kenya":"254","Kiribati":"686","Kuwait":"965"],["Laos":"856","Lebanon":"961","Lesotho":"266","Liberia":"231","Libya":"218","Liechtenstein":"4175","Luxembourg":"352"],["Macao":"853","Madagascar":"261","Malawi":"265","Malaysia":"60","Maldives":"960","Mali":"223","Malta":"356","Martinique":"596","Mauritania":"222","Mauritius":"230","Mexico":"52","Midway Island":"1808","Mongolia":"976","Morocco":"210","Mozambique":"258","Myanmar":"95"],["Namibia":"264","Nauru":"674","Nepal":"977","Netherlands":"31","New Zealand":"64","Nicaragua":"505","Niger":"227","Nigeria":"234","Niue":"683","Norfolk Island":"6723","North Korea":"850","Norway":"47"],["Oman":"968"],["Pakistan":"92","Panama":"507","Paraguay":"595","Peru":"51","Philippines":"63","Poland":"48","Portugal":"351","Principe":"239","Puerto Rico":"1809"],["Qatar":"974"],["Reunion":"262","Romania":"40","Russia":"7","Rwanda":"250"],["Saint Helena":"290","Saint Lucia":"1809","Samoa":"685","San Marino":"223","Sao Tome and Principe":"239","Saudi Arabia":"966","Senegal":"221","Seychelles":"248","Sierra Leone":"232","Singapore":"65","Solomon Islands":"677","Somalia":"252","South Africa":"27","South Korea":"82","Spain":"34","Sri Lanka":"94","Sudan":"249","Suriname":"597","Swaziland":"268","Sweden":"46","Swiss":"41","Syria":"963"],["Taiwan":"886","Tanzania":"255","Thailand":"66","Togo":"228","Tonga":"676","Tunisia":"216","Turkey":"90","Tuvalu":"688"],["USA":"1","Uganda":"256","United Kingdom":"44","Uruguay":"598"],["Vanuatu":"678","Vatican":"396","Venezuela":"58","Vietnam":"84","Virgin Islands":"1809"],["Wake Island":"1808"],["Yugoslavia":"338"],["Zambia":"260","Zimbabwe":"263"]])
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
