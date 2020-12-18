//
//  LoginAbstractTool.swift
//  Cowa
//
//  Created by MX on 16/5/31.
//  Copyright © 2016年 MX. All rights reserved.
//

import Foundation
import RETableViewManager

class LoginAbstractTool: NSObject {
    class func assembleOnChangeText(_ eachItem:RETextItem,container:UnsafeMutablePointer<String>) {
        eachItem.onChange = {
            (item) -> Void in
            container.pointee = (item?.value)!
//            print(container.memory,"修改了内存中的字符串数据")
        }
    }
}
