//
//  TRegularMatch.swift
//  Cowa
//
//  Created by MX on 16/5/31.
//  Copyright © 2016年 MX. All rights reserved.
//

import UIKit

class TRegularMatch: NSObject {
    
    class func matchPhone(_ phone:String?) -> (error:String?,isValidate:Bool?) {
        if phone != nil {
            let reg = "^(\\+?0?86\\-?)?((13\\d|14[57]|15[^4,\\D]|17[678]|18\\d)\\d{8}|170[059]\\d{7})$"
            let pre = NSPredicate.init(format: "SELF MATCHES %@", reg)
            let isValidate = pre.evaluate(with: phone!)
            if isValidate {
                return (nil,isValidate)
            } else {
                print("matchPhoneNum failed")
                return ("matchPhoneNum failed",isValidate)
            }
        } else {
            return ("there are no phone number to match",false)
        }
    }
}
