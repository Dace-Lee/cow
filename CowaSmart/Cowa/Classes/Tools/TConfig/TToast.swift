//
//  TToast.swift
//  Cowa
//
//  Created by MX on 2016/11/5.
//  Copyright © 2016年 MX. All rights reserved.
//

import Foundation
import Toast_Swift

class TToast: NSObject {
    
    class func show(_ mesg: String? = nil) {
        if nil != mesg {
            let rect = UIScreen.main.bounds
//            UIApplication.shared.delegate?.window!!.makeToast(mesg!, duration: 2.0,position: CGPoint(x: rect.midX, y: rect.maxY * 7/8.0))
            UIApplication.shared.delegate?.window!!.makeToast(mesg!, duration: 2.0,position: ToastPosition.center)
        }
    }
}
