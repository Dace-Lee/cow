//
//  TNetworkingERROR.swift
//  Cowa
//
//  Created by MX on 16/6/7.
//  Copyright © 2016年 MX. All rights reserved.
//

import Foundation

struct NetERROR {
    static let ERRORDIC = [//"USER_UNAUTH":"用户认证失败",
                            "MOBILE_REQUIRED":"未填写手机号",
                            "MOBILE_REGEX":"手机号格式错误",
                            "MOBILE_EXIST":"手机号已存在",
                            "MOBILE_INEXIST":"手机号不存在",
                            "PASSWORD_REQUIRED":"未填写密码",
                            "PASSWORD_LENGTH":"密码至少为6位",
                            "PASSWORD_CONFIRMED":"两次密码输入不一致",
                            "PASSWORD_MISTAKE":"密码错误",
                            "CODE_REQUIRED":"未填写验证码",
                            "CODE_CLASH":"60s之内只能发送一次验证",
                            "CODE_MISTAKE":"验证码错误",
                            "CODE_OVERDUE":"验证码已过期",
                            "DEVICE_MAC_REQUIRED":"设备MAC地址未填",
                            "DEVICE_NAME_REQUIRED":"设备名称未填写",
                            "DEVICE_INEXIST":"设备不存在"]
}
