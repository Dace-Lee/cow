//
//  PrintTool.swift
//  Cowa
//
//  Created by gaojun on 2017/8/2.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit

class PrintTool: NSObject {

    static let tool = PrintTool()
    
    func print(_ action:String, content:String, imei:String){
        
        let str = NSString.init(format: "{\"action\": \"%@\",\"content\":\"%@\",\"time\":\"\(Date())\",\"Imei\":\"%@\"}" as NSString, action,content,imei)
        
        GJTool.nslog(str as String)
    }
    
    
}
