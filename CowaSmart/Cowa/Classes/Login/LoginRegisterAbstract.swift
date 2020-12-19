//
//  LoginRegisterAbstract.swift
//  weather-Swift
//
//  Created by MX on 2016/10/8.
//  Copyright © 2016年 MX. All rights reserved.
//

import Foundation
import SwiftyJSON

class LoginRegisterAbstract : NSObject {
    enum RequestPINType {
        case register, changePwd
    }

    struct result {
        var succ: Bool = false
        var mesg: String?
        var resp: TNetworking.responseData?
        var code: String?
    }

    struct paraCheckResult {
        var validate: Bool = false
        var mesg: String?
    }

    class func needLogin() -> Bool {
        return TUser.userToken() == ""
    }

    //登录
    class func login(_ usr: String!, pwd: String!, comp:@escaping ((result) -> Void)) -> paraCheckResult {
        let url = NetURL.tool.login
        let vserion:String = TUser.appVersion() as String
        let para = ["username":usr, "password":pwd,"version_ios":vserion]
        //print("\(para)")
        _ = TNetworking.requestWithPara(method: .post, URL: url, Parameter: para as [String : AnyObject]?, Token: nil) { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
            print("******登录返回\(json)");
            if JSON.null != json {
                if "2000" == json["code"].string {
                    TUser.userPhone(usr)
                    TUser.userPwd(pwd)
                    TUser.userToken(json["result"]["tokenId"].string!)
                    TUser.userNickName(json["result"]["nickname"].string!)
                    comp(result(succ: true, mesg: json["msg"].string, resp: res, code:json["code"].string))
                    return
                }
                
                comp(result(succ: false, mesg: json["msg"].string, resp: res, code:json["code"].string))
                return
                
            }
            comp(result(succ: false, mesg: "登录失败", resp: res, code:json["code"].string))
        }
        return paraCheckResult(validate: true, mesg: "")
    }

    //请求验证码
    class func requestPIN(_ usr: String!,reqType: RequestPINType, country:String!, comp:@escaping ((result) -> Void)) -> paraCheckResult {
        let url = NetURL.tool.smscode
        var para = [String:AnyObject]()
        switch reqType {
        case .changePwd: para = ["telnumber":usr as AnyObject,"cid":country as AnyObject,"type":2 as AnyObject]
        case .register: para = ["telnumber":usr as AnyObject,"cid":country as AnyObject,"type":1 as AnyObject]
        }
        //print("\(para)")
        _ = TNetworking.requestWithPara(method: .post, URL: url, Parameter: para, Token: nil, handler: { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
            print("******验证码返回\(json)");
            if JSON.null != json {
                if "2000" != json["code"].string {
                    comp(result(succ: false, mesg: json["msg"].string, resp: res, code:json["code"].string))
                    return
                }
                comp(result(succ: true, mesg: json["msg"].string, resp: res, code:json["code"].string))
                return
            }
            comp(result(succ: false, mesg: "验证码请求失败", resp: res, code:json["code"].string))
        })
        return paraCheckResult(validate: true, mesg: "")
    }
    
    //请求远程解绑PIN码
    class func requestRemotePIN(_ usr: String!,imei: String!, comp:@escaping ((result) -> Void)) -> paraCheckResult {
        let url = NetURL.tool.remote_smscode
        let para = ["telnumber":usr,"imei":imei]
        //print("\(para)")
        _ = TNetworking.requestWithPara(method: .post, URL: url, Parameter: para as [String : AnyObject]?, Token: TUser.userToken(), handler: { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
            //print("******远程解绑验证码\(json)");
            if JSON.null != json {
                if "2000" != json["code"].string {
                    comp(result(succ: false, mesg: json["msg"].string, resp: res, code:json["code"].string))
                    return
                }
                comp(result(succ: true, mesg: json["msg"].string, resp: res, code:json["code"].string))
                return
            }
            comp(result(succ: false, mesg: "验证码请求失败", resp: res, code:json["code"].string))
        })
        return paraCheckResult(validate: true, mesg: "")
    }

    //注册
    class func register(_ usr: String, pwd: String, pinCode: String, country:String, comp:@escaping ((result) -> Void)) -> paraCheckResult {
        let url = NetURL.tool.Register
        let para = ["username":usr,"password":pwd,"verify":pinCode,"cid":country]
        //print("\(para)")
        _ = TNetworking.requestWithPara(method: .post, URL: url, Parameter: para as [String : AnyObject]?, Token: nil) { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
            //print("******注册返回\(json)");
            if JSON.null != json {
                if "2000" != json["code"].string {
                    comp(result(succ: false, mesg: json["msg"].string, resp: res, code:json["code"].string))
                    return
                }
                
                comp(result(succ: true, mesg: json["msg"].string, resp: res, code:json["code"].string))
                return
                
            }
            comp(result(succ: false, mesg: "注册失败", resp: res, code:json["code"].string))
        }
        return paraCheckResult(validate: true, mesg: "")
    }

    //找回密码
    class func retrievePwd(_ user: String, newPwd: String, pin: String, comp:@escaping ((result) -> Void)) -> paraCheckResult {
        let url = NetURL.tool.PwdRetrieve
        let para = ["username" : user, "verify" : pin, "password" : newPwd]
        //print("\(para)")
        _ = TNetworking.requestWithPara(method: .post, URL: url, Parameter: para as [String : AnyObject]?, Token: nil) { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
            //print("******找回密码返回\(json)");
            if JSON.null != json {
                if "2000" == json["code"].string {
                    comp(result(succ: true, mesg: json["msg"].string, resp: res, code:json["code"].string))
                    return
                }
                
                comp(result(succ: false, mesg: json["msg"].string, resp: res, code:json["code"].string))
                return
                
            }
            comp(result(succ: false, mesg: "密码找回失败", resp: res, code:json["code"].string))
        }

        return paraCheckResult(validate: true, mesg: "")
    }

    //重置密码
    class func resetPwd(_ user:String, old: String, new: String, comp:@escaping ((result) -> Void)) -> paraCheckResult {
        let url = NetURL.tool.PwdReset
        let para = ["oldpassword" : old, "newpassword" : new, "username" : user]
        //print("\(para)")
        _ = TNetworking.requestWithPara(method: .post, URL: url, Parameter: para as [String : AnyObject]?, Token: TUser.userToken()) { (res) in
            //print("\(res)")
            let json = ViewController.swiftyJsonFromData(data: res.data!)
            //print("******重置密码\(json)");
            if JSON.null != json {
                if "2000" == json["code"].string {
                    _ = self.login(user, pwd: new, comp: { (res) in
                    })
                    comp(result(succ: true, mesg: json["msg"].string, resp: res, code:json["code"].string))
                    return
                }
                
                comp(result(succ: false, mesg: json["msg"].string, resp: res, code:json["code"].string))
                return
                
            }
            comp(result(succ: false, mesg: "密码重置失败", resp: res, code:json["code"].string))
        }
        return paraCheckResult(validate: true, mesg: "")
    }
    
    //授权获取验证码
    class func requestAuthPIN(_ usr: String!,imei:String!, comp:@escaping ((result) -> Void)) -> paraCheckResult {
        let url = NetURL.tool.smscode
        var para = [String:AnyObject]()
        para = ["telnumber":usr as AnyObject,"type":4 as AnyObject,"imei":imei as AnyObject]
       // print("\(para)")
        _ = TNetworking.requestWithPara(method: .post, URL: url, Parameter: para, Token: nil, handler: { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
            //print("******授权验证码返回\(json)");
            if JSON.null != json {
                if "2000" != json["code"].string {
                    comp(result(succ: false, mesg: json["msg"].string, resp: res, code:json["code"].string))
                    return
                }
                comp(result(succ: true, mesg: json["msg"].string, resp: res, code:json["code"].string))
                return
            }
            comp(result(succ: false, mesg: "授权验证码请求失败", resp: res, code:json["code"].string))
        })
        return paraCheckResult(validate: true, mesg: "")
    }
    
    //NICKNAME
    class func setUserMes(_ usr: String!,name:String!, comp:@escaping ((result) -> Void)) -> paraCheckResult {
        let url = NetURL.tool.userInfo
        var para = [String:AnyObject]()
       para = ["username":usr as AnyObject,"nickName":name as AnyObject]
        //print("\(para)")
        _ = TNetworking.requestWithPara(method: .post, URL: url, Parameter: para, Token: TUser.userToken(), handler: { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
            //print("******NICKNAME返回\(json)");
            if JSON.null != json {
                if "2000" != json["code"].string {
                    comp(result(succ: false, mesg: json["msg"].string, resp: res, code:json["code"].string))
                    return
                }
                comp(result(succ: true, mesg: json["msg"].string, resp: res, code:json["code"].string))
                return
            }
            comp(result(succ: false, mesg: "个人信息修改失败", resp: res, code:json["code"].string))
        })
        return paraCheckResult(validate: true, mesg: "")
    }

    fileprivate class func paraUserPhoneCheck(_ usrPhone: String!) -> Bool {
        return true
    }

}
