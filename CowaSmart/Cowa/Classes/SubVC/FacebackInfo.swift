//
//  FacebackInfo.swift
//  Cowa
//
//  Created by 李来伟 on 2018/2/9.
//  Copyright © 2018年 MX. All rights reserved.
//

import UIKit
import SwiftyJSON
class FacebackInfo: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var resourceArr = [FacebackModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("AdviceFeed", comment: "")
        let imageV = UIImageView(image: UIImage(named:"登录页面-背景图"))
        imageV.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        view.insertSubview(imageV, at: 0)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.backgroundView = UIImageView(image: UIImage(named:"tableBg1"))
        tableView.register(UINib(nibName: "FaceBackTilteCell", bundle: nil), forCellReuseIdentifier: "FaceBackTilteCellIden")
        tableView.tableFooterView = UIView()
        loadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    fileprivate func loadData() {
        let url = "http://server.cowarobot.com/openapi/cowaapp.user.opition"
        let phoneNum: String = TUser.userPhone() as String
        //        print(phoneNum)
        let  tokenId = TUser.userToken() as String
        let para = ["telnumber":phoneNum]
        _ = TNetworking.requestWithPara(method: .get, URL: url, Parameter: para as [String : AnyObject], Token: tokenId, handler: { (res) in
            
            let json = JSON(data: res.data!)
            if "2000" == json["code"].string {
              self.resourceArr =  json["result"].arrayValue.map({FacebackModel(json: $0)})
                self.tableView.reloadData()
            }else {
     
            }
            
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension FacebackInfo: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resourceArr.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FaceBackTilteCellIden", for: indexPath) as! FaceBackTilteCell
        cell.model = resourceArr[indexPath.row]
        cell.selectionStyle = .none
        cell.backgroundColor = .clear;
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if resourceArr.count > 0 {
//            let cell =  tableView.cellForRow(at: indexPath) as! FaceBackTilteCell
//            return cell.rowHeight
//        }
        return resourceArr[indexPath.row].rowHeight;
//        return 0;
    }
}
