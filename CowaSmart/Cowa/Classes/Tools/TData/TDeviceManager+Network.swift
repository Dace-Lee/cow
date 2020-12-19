//
//  TDeviceManager+Network.swift
//  Cowa
//
//  Created by MX on 16/6/1.
//  Copyright © 2016年 MX. All rights reserved.
//

import Foundation
import SwiftyJSON

extension TDeviceManager {
    
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
    
    //获取用户下所有的箱子
    func originGetDevices(_ comple:@escaping (Array<MDevice>)->Void) {
        let para = ["telnumber":TUser.userPhone()]
        //print("\(para)")
        _ = TNetworking.requestWithPara(method: .get, URL: NetURL.tool.allBag, Parameter: para as [String : AnyObject]?, Token:TUser.userToken()) { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
            var devices = [MDevice]()
            //print("*****获取用户下所有的箱子返回\(json)")
            if JSON.null != json {
                let devs = json["result"].array
                if devs != nil {
                    for dev in devs! {
                        let d = MDevice.init()
                        d.device_name = dev["bagName"].string
                        d.device_IMEI = dev["imei"].string
                        d.isHost = dev["isHost"].string
                        devices.append(d)
                    }
                }
            }
            comple(devices)
        }
    }
    
    //获取用户绑定的箱子的imei
    func originGetImeis(_ comp:@escaping ((result) -> Void)) -> paraCheckResult {
        let para = ["telnumber":TUser.userPhone()]
        //print("\(para)")
       _ = TNetworking.requestWithPara(method: .get, URL: NetURL.tool.allBag, Parameter: para as [String : AnyObject]?, Token:TUser.userToken()) { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
            //print("*****获取用户下所有的imeis返回\(json)")
            if JSON.null != json {
                comp(result(succ: true, mesg: json["msg"].string, resp: res, code:json["code"].string))
                return
            }
            comp(result(succ: false, mesg: "获取失败", resp: res, code:json["code"].string))
        }
        return paraCheckResult(validate: true, mesg: "")
    }
    
    //绑定行李箱
    func BondBag(_ usr: String!,imei:String!, boxName:String!, comp:@escaping ((result) -> Void)) -> paraCheckResult {
        let url = NetURL.tool.searchAuth
        var para = [String:AnyObject]()
        para = ["telnumber":usr as AnyObject,"imei":imei as AnyObject,"type":1 as AnyObject,"box_name":boxName as AnyObject]
        //print("\(para)")
        _ = TNetworking.requestWithPara(method: .post, URL: url, Parameter: para, Token: TUser.userToken(), handler: { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
            //print("******绑定行李箱返回\(json)");
            if JSON.null != json {
                if "2000" != json["code"].string {
                    comp(result(succ: false, mesg: json["msg"].string, resp: res, code:json["code"].string))
                    return
                }
                comp(result(succ: true, mesg: json["msg"].string, resp: res, code:json["code"].string))
                return
            }
            comp(result(succ: false, mesg: "绑定失败", resp: res, code:json["code"].string))
        })
        return paraCheckResult(validate: true, mesg: "")
    }
    
    //申请授权
    func replyBondBag(_ usr: String!,imei:String!, publicUser:String!, verify:String!, comp:@escaping ((result) -> Void)) -> paraCheckResult {
        let url = NetURL.tool.searchAuth
        var para = [String:AnyObject]()
        para = ["host_tel":usr as AnyObject,"imei":imei as AnyObject,"type":6 as AnyObject,"telnumber":publicUser as AnyObject,"verify":verify as AnyObject]
        //print("\(para)")
        _ = TNetworking.requestWithPara(method: .post, URL: url, Parameter: para, Token: TUser.userToken(), handler: { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
            //print("******申请授权返回\(json)");
            if JSON.null != json {
                if "2000" != json["code"].string {
                    comp(result(succ: false, mesg: json["msg"].string, resp: res, code:json["code"].string))
                    return
                }
                comp(result(succ: true, mesg: json["msg"].string, resp: res, code:json["code"].string))
                return
            }
            comp(result(succ: false, mesg: "申请授权失败", resp: res, code:json["code"].string))
        })
        return paraCheckResult(validate: true, mesg: "")
    }
    
    //远程解绑
    func remoteCancelBond(_ usr: String!,verify: String!,imei:String!, comp:@escaping ((result) -> Void)) -> paraCheckResult {
        let url = NetURL.tool.remoteCancelBond
        let para = ["telnumber":usr,"verify":verify,"imei":imei]
        //print("远程解绑参数\(para)")
        _ = TNetworking.requestWithPara(method: .post, URL: url, Parameter: para as [String : AnyObject]?, Token: TUser.userToken(), handler: { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
            //print("******远程解绑返回\(json)");
            if JSON.null != json {
                if "2000" != json["code"].string {
                    comp(result(succ: false, mesg: json["msg"].string, resp: res, code:json["code"].string))
                    return
                }
                comp(result(succ: true, mesg: json["msg"].string, resp: res, code:json["code"].string))
                return
            }
            comp(result(succ: false, mesg: "远程解绑失败", resp: res, code:json["code"].string))
        })
        return paraCheckResult(validate: true, mesg: "")
    }
    
    //验证当前登录用户是否合法
    func checkAuth(_ usr: String!, imei:String!, publicUser:String!, comp:@escaping ((result) -> Void)) -> paraCheckResult {
        let url = NetURL.tool.searchAuth
        var para = [String:AnyObject]()
        para = ["host_tel":usr as AnyObject,"imei":imei as AnyObject,"telnumber":publicUser as AnyObject,"type":5 as AnyObject]
        //print("\(para)")
        _ = TNetworking.requestWithPara(method: .post, URL: url, Parameter: para, Token: TUser.userToken(), handler: { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
            //print("******验证当前登录用户是否合法返回\(json)")
            if JSON.null != json {
                if "2000" != json["code"].string {
                    comp(result(succ: false, mesg: json["msg"].string, resp: res, code:json["code"].string))
                    return
                }
                comp(result(succ: true, mesg: json["msg"].string, resp: res, code:json["code"].string))
                return
            }
            comp(result(succ: false, mesg: "验证授权失败", resp: res, code:json["code"].string))
        })
        return paraCheckResult(validate: true, mesg: "")
    }
    
    ///添加新朋友
    func addFriend(_ usr: String!, imei:String!, publicUser:String!, comp:@escaping ((result) -> Void)) -> paraCheckResult {
        let url = NetURL.tool.searchAuth
        var para = [String:AnyObject]()
        para = ["host_tel":usr as AnyObject,"imei":imei as AnyObject,"telnumber":publicUser as AnyObject,"type":3 as AnyObject]
        //print("\(para)")
        _ = TNetworking.requestWithPara(method: .post, URL: url, Parameter: para, Token: TUser.userToken(), handler: { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
            //print("******添加新朋友返回\(json)")
            if JSON.null != json {
                if "2000" != json["code"].string {
                    comp(result(succ: false, mesg: json["msg"].string, resp: res, code:json["code"].string))
                    return
                }
                comp(result(succ: true, mesg: json["msg"].string, resp: res, code:json["code"].string))
                return
            }
            comp(result(succ: false, mesg: "授权失败", resp: res, code:json["code"].string))
        })
        return paraCheckResult(validate: true, mesg: "")
    }
    
    //获取箱子下的授权用户
    func originGetFrends(_ user:String!, imei:String!, comple:@escaping (Array<FrendsModel>)->Void) {
        let para = ["telnumber":user,"imei":imei]
        //print("\(para)")
        _ = TNetworking.requestWithPara(method: .get, URL: NetURL.tool.allUser, Parameter: para as [String : AnyObject]?, Token:TUser.userToken()) { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
            //print("******获取箱子下的授权用户返回\(json)")
            var frends = [FrendsModel]()
            if JSON.null != json {
                let devs = json["result"].array
                if devs != nil {
                    for dev in devs! {
                        let d = FrendsModel.init()
                        d.userPhone = dev["userPhone"].string
                        d.isHost = dev["isHost"].string
                        frends.append(d)
                    }
                }
            }
            comple(frends)
        }
    }
    
    //取消授权
    func deleteFriend(_ usr: String!, imei:String!, publicUser:String!, comp:@escaping ((result) -> Void)) -> paraCheckResult {
        let url = NetURL.tool.searchAuth
        var para = [String:AnyObject]()
        para = ["host_tel":usr as AnyObject,"imei":imei as AnyObject,"telnumber":publicUser as AnyObject,"type":4 as AnyObject]
        //print("\(para)")
        _ = TNetworking.requestWithPara(method: .post, URL: url, Parameter: para, Token: TUser.userToken(), handler: { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
            //print("******取消授权返回\(json)")
            if JSON.null != json {
                if "2000" != json["code"].string {
                    comp(result(succ: false, mesg: json["msg"].string, resp: res, code:json["code"].string))
                    return
                }
                comp(result(succ: true, mesg: json["msg"].string, resp: res, code:json["code"].string))
                return
            }
            comp(result(succ: false, mesg: "删除授权失败", resp: res, code:json["code"].string))
        })
        return paraCheckResult(validate: true, mesg: "")
    }
    
    //本地解绑
    func unbond(_ telnumber: String!, imei:String!, comp:@escaping ((result) -> Void)) -> paraCheckResult {
        let url = NetURL.tool.searchAuth
        var para = [String:AnyObject]()
        para = ["imei":imei as AnyObject,"telnumber":telnumber as AnyObject,"type":2 as AnyObject]
       // print("\(para)")
        _ = TNetworking.requestWithPara(method: .post, URL: url, Parameter: para, Token: TUser.userToken(), handler: { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
           // print("******解绑返回\(json)")
            if JSON.null != json {
                if "2000" != json["code"].string {
                    comp(result(succ: false, mesg: json["msg"].string, resp: res, code:json["code"].string))
                    return
                }
                comp(result(succ: true, mesg: json["msg"].string, resp: res, code:json["code"].string))
                return
            }
            comp(result(succ: false, mesg: "解绑失败", resp: res, code:json["code"].string))
        })
        return paraCheckResult(validate: true, mesg: "")
    }
    
    //极光推送
    func pushLocAndCancelBond(_ type: Int!, imei:String!, comp:@escaping ((result) -> Void)) -> paraCheckResult {
        let url = NetURL.tool.push
        var para = [String:AnyObject]()
        para = ["imei":imei as AnyObject,"type":type as AnyObject]
       // print("推送参数\(para)")
        _ = TNetworking.requestWithPara(method: .post, URL: url, Parameter: para, Token: TUser.userToken(), handler: { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
           // print("******推送返回\(json)")
            if JSON.null != json {
                if "2000" != json["code"].string {
                    comp(result(succ: false, mesg: json["msg"].string, resp: res, code:json["code"].string))
                    return
                }
                comp(result(succ: true, mesg: json["msg"].string, resp: res, code:json["code"].string))
                return
            }
            comp(result(succ: false, mesg: "操作失败", resp: res, code:json["code"].string))
        })
        return paraCheckResult(validate: true, mesg: "")
    }
    
    //获取box版本
    func getBoxVerision(_ type:String!, comp:@escaping ((result) -> Void)) -> paraCheckResult {
        let url = NetURL.tool.getBoxVersion
        let para = ["type":type,"box_type":"R1"]
        //print("\(para)")
        _ = TNetworking.requestWithPara(method: .post, URL: url, Parameter: para as [String : AnyObject]?, Token: TUser.userToken(), handler: { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
            print("******box版本返回\(json)")
            if JSON.null != json {
                if "2000" != json["code"].string {
                    comp(result(succ: false, mesg: json["msg"].string, resp: res, code:json["code"].string))
                    return
                }
                comp(result(succ: true, mesg: json["msg"].string, resp: res, code:json["code"].string))
                return
            }
            comp(result(succ: false, mesg: "box版本返回失败", resp: res, code:json["code"].string))
        })
        return paraCheckResult(validate: true, mesg: "")
    }
    
    //reset功能
    func resetWithBag(_ imei:String!, comp:@escaping ((result) -> Void)) -> paraCheckResult {
        let url = NetURL.tool.resetBox
        let para = ["imei":imei]
        //print("\(para)")
        _ = TNetworking.requestWithPara(method: .post, URL: url, Parameter: para as [String : AnyObject]?, Token: TUser.userToken(), handler: { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
            //print("******reset返回\(json)")
            if JSON.null != json {
                if "2000" != json["code"].string {
                    comp(result(succ: false, mesg: json["msg"].string, resp: res, code:json["code"].string))
                    return
                }
                comp(result(succ: true, mesg: json["msg"].string, resp: res, code:json["code"].string))
                return
            }
            comp(result(succ: false, mesg: "reset返回失败", resp: res, code:json["code"].string))
        })
        return paraCheckResult(validate: true, mesg: "")
    }
    
    //修改箱子信息
    func updateBagInfo(_ name:String!, imei:String!, comp:@escaping ((result) -> Void)) -> paraCheckResult {
        let url = NetURL.tool.updateBox
        let para = ["imei":imei,"name":name]
        //print("\(para)")
        _ = TNetworking.requestWithPara(method: .post, URL: url, Parameter: para as [String : AnyObject]?, Token: TUser.userToken(), handler: { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
            //print("******修改箱子信息返回\(json)")
            if JSON.null != json {
                if "2000" != json["code"].string {
                    comp(result(succ: false, mesg: json["msg"].string, resp: res, code:json["code"].string))
                    return
                }
                comp(result(succ: true, mesg: json["msg"].string, resp: res, code:json["code"].string))
                return
            }
            comp(result(succ: false, mesg: "修改箱子信息返回失败", resp: res, code:json["code"].string))
        })
        return paraCheckResult(validate: true, mesg: "")
    }
    
    //由imei号返回所有使用用户
    func getUserFromImei(_ imei:String!, comp:@escaping ((result) -> Void)) -> paraCheckResult {
        let url = NetURL.tool.userData
        let para = ["imei":imei]
        //print("\(para)")
        _ = TNetworking.requestWithPara(method: .post, URL: url, Parameter: para as [String : AnyObject]?, Token: TUser.userToken(), handler: { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
            //print("******由imei号返回所有使用用户\(json)")
            if JSON.null != json {
                if "2000" == json["code"].string {
                    comp(result(succ: true, mesg: json["msg"].string, resp: res, code:json["code"].string))
                    return
                }
                comp(result(succ: false, mesg: json["msg"].string, resp: res, code:json["code"].string))
                return
            }
            comp(result(succ: false, mesg: "由imei号返回所有使用用户数据为null", resp: res, code:json["code"].string))
        })
        return paraCheckResult(validate: true, mesg: "")
    }
    
    
    //上传log文件
    func pushFeedBack(_ id:String!, telnumber:String!, description:String!, type:String!, comp:@escaping ((result) -> Void)) -> paraCheckResult {
        let url = NetURL.tool.feedBack
        let para = ["id":id,"telnumber":telnumber,"description":description,"type":type,"mechine":"R1Lite"]
        //print("\(para)")
        _ = TNetworking.requestWithPara(method: .post, URL: url, Parameter: para as [String : AnyObject]?, Token: TUser.userToken(), handler: { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
            //print("******\(json)")
            if JSON.null != json {
                if "2000" == json["code"].string {
                    comp(result(succ: true, mesg: json["msg"].string, resp: res, code:json["code"].string))
                    return
                }
                comp(result(succ: false, mesg: json["msg"].string, resp: res, code:json["code"].string))
                return
            }
            comp(result(succ: false, mesg: "null", resp: res, code:json["code"].string))
        })
        return paraCheckResult(validate: true, mesg: "")
    }
    
    //从后台获取极光推送消息
    func getMsgFromJPUSH(_ mes_id:String!, comp:@escaping ((result) -> Void)) -> paraCheckResult {
        let url = NetURL.tool.jPush
        let para = ["mes_id":mes_id]
        //print("\(para)")
        _ = TNetworking.requestWithPara(method: .post, URL: url, Parameter: para as [String : AnyObject]?, Token: TUser.userToken(), handler: { (res) in
            let json = ViewController.swiftyJsonFromData(data: res.data!)
            //print("******从后台获取极光推送消息\(json)")
            if JSON.null != json {
                if "2000" == json["code"].string {
                    comp(result(succ: true, mesg: json["msg"].string, resp: res, code:json["code"].string))
                    return
                }
                comp(result(succ: false, mesg: json["msg"].string, resp: res, code:json["code"].string))
                return
            }
            comp(result(succ: false, mesg: "从后台获取极光推送消息null", resp: res, code:json["code"].string))
        })
        return paraCheckResult(validate: true, mesg: "")
    }
    
}
