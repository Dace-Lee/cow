//
//  TNetworkingURL.swift
//  Cowa
//
//  Created by MX on 16/5/31.
//  Copyright © 2016年 MX. All rights reserved.
//

import Foundation

class NetURL:NSObject {
    
    static let tool = NetURL()
    
    var Host = "http://server.cowarobot.com"
    //测试环境：http://123.207.182.233
    //正式环境：http://server.cowarobot.com
    
    var APIUser = ""
    var Verify   = ""
    var Register = ""
    var login    = ""
    var logout   = ""
    var profile  = ""
    var smscode  = ""
    var remote_smscode  = ""
    var userInfo  = ""
    var PwdVerify = ""
    var PwdReset = ""
    var PwdRetrieve = ""
    var APIDevice = ""
    var create    = ""
    var delete    = ""
    var modify    = ""
    var all       = ""
    var APIBag = ""
    var allBag = ""
    var remoteCancelBond = ""
    var searchAuth = ""
    var push = ""
    var getLoc = ""
    var getBoxVersion = ""
    var resetBox = ""
    var updateBox = ""
    var userData = ""
    var logFile = ""
    var feedBack = ""
    var jPush = ""
    var allUser = ""
    
    
    func updateHost(){
        Host = "http://123.207.182.233"
    }
    
    func initUrl(){
        APIUser = Host + "/openapi"
        Verify   = APIUser + "/verify"
        Register = APIUser + "/cowaapp.user.register"
        login    = APIUser + "/cowaapp.user.login"
        logout   = APIUser + "/logout"
        profile  = APIUser + "/profile"
        smscode  = APIUser + "/cowaapp.system.sendSms"
        remote_smscode  = APIUser + "/cowaapp.user.long_unbind"
        userInfo  = APIUser + "/cowaapp.user.updateUserInfo"
        PwdVerify = APIUser + "/password/verify"
        PwdReset = APIUser + "/cowaapp.user.resetPassword"
        PwdRetrieve = APIUser + "/cowaapp.user.forgetPassword"
        
        APIDevice = Host + "/api/device"
        create    = APIDevice + "/create"
        delete    = APIDevice + "/delete"
        modify    = APIDevice + "/modify"
        all       = APIDevice + "/all"
        
        APIBag = Host + "/openapi"
        allBag = APIBag + "/cowaapp.user.getBoxList"
        remoteCancelBond = APIBag + "/cowaapp.user.unbind_doAction"
        searchAuth = APIBag + "/cowaapp.box.permissions"
        push = APIBag + "/cowaapp.system.pushJlight"
        getLoc = APIBag + "/cowaapp.box.getBoxLocation"
        getBoxVersion = APIBag + "/cowaapp.system.getNewestVersion"
        resetBox = APIBag + "/cowaapp.system.resetBox"
        updateBox = APIBag + "/cowaapp.box.storeBoxInfo"
        userData = APIBag + "/cowaapp.user.getAllUserInfoByImei"
        logFile = APIBag + "/cowaapp.user.storeLogfile"
        feedBack = APIBag + "/cowaapp.user.updateLogFile"
        jPush = APIBag + "/cowaapp.user.getJpushMesById"
        allUser = APIUser + "/cowaapp.user.getUserByImei"
    }
    
}

