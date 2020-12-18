//
//  TFont.swift
//  weather-Swift
//
//  Created by sway on 16/3/23.
//  Copyright © 2016年 MX. All rights reserved.
//

import UIKit

class TFont: NSObject {
    override init() {
        super.init()
    }
    static func getSystemFont(_ size: CGFloat) -> UIFont! {
        //根据系统版本选择字体
        let os = ProcessInfo().operatingSystemVersion
        switch (os.majorVersion,os.minorVersion,os.patchVersion) {
            case(9,_,_):
                return UIFont.init(name: "PingFangSC-Medium", size: size)
            default:
                return UIFont.systemFont(ofSize: size)
        }
    }
    
    static func getIconFont(_ size: CGFloat) -> UIFont {
        return UIFont.init(name: "iconFont", size: size)!
    }
}
