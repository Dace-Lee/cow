//
//  TNetworking.swift
//  weather-Swift
//
//  Created by GJ on 17/3/1.
//  Copyright © 2016年 clf. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class TNetworking: NSObject {
    
    struct responseData {
        var request: URLRequest?
        var response: HTTPURLResponse?
        var json: AnyObject?
        var error: NSError?
        var data: Data?
    }
    
    static var commonHandlers: Array<(responseData) -> Void> = Array()
    static var reachAbilityHandler: ((Bool) -> Void)?
    
    class func requestWithPara(method met:Alamofire.HTTPMethod,URL url:String,Parameter para:[String:AnyObject]?,Token token:String?,handler: @escaping (responseData) -> Void) -> Bool {
        let reachable = TNetworkReachability.sharedInstance.reachable
        if self.reachAbilityHandler != nil {
            self.reachAbilityHandler!(reachable)
        }
        if reachable {
            var dicToken:[String:String]?
            if token != nil {
                dicToken = ["tokenId" : token!, "identity_code":"\(SecurityUtil .encryptAESData("cowaRobot-\(Int(Date().timeIntervalSince1970))", app_key: "Td85wvkoRUX3xTf92trDROs4ioUwjdZ5"))"]
            }
            //print("*****\(SecurityUtil .encryptAESData("cowaRobot-\(Int(NSDate().timeIntervalSince1970))", app_key: "Td85wvkoRUX3xTf92trDROs4ioUwjdZ5"))")
            let manager = Alamofire.Session.default
            manager.session.configuration.timeoutIntervalForRequest = 10
            manager.request(url, method: .get, parameters: para, encoding: URLEncoding.default, headers: HTTPHeaders.init(dicToken ?? ["":""])).response { (response) in
                let json : AnyObject! = try? JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as AnyObject?
                if nil != json {
                    let res = responseData(request: response.request, response: response.response, json: json, error: response.error as NSError?, data: response.data)
                   
                        handler(res)
                        for commonHandler in commonHandlers {
                            commonHandler(res)
                        }
                }
                
            }
            
            return true
        } else {
            return false
        }
    }
    
    class func transformChineseToUnicode8String(_ CNString:String) -> String {
        let UTF8String = CNString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        return UTF8String
    }
}

extension TNetworking {
    class func showError(_ res:responseData) {
        let j = ViewController.swiftyJsonFromData(data: res.data!)
        if JSON.null != j {
            if nil != j["error"].string {
                let error = j["error"].string
                if NetERROR.ERRORDIC.keys.contains(error!) {
                    let errorContent = NetERROR.ERRORDIC[error!]
                    print("输出错误",errorContent!)
                    self.showMsg(errorContent)
                }
            }
        }
    }
    
    class func showMsg(_ msg: String?) {
        TToast.show(msg)
    }
}
