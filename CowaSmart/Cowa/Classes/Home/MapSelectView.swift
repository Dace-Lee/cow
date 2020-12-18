//
//  MapSelectView.swift
//  Cowa
//
//  Created by gaojun on 2017/9/1.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit

class MapSelectView: UIView {
    
   
    @IBAction func bdMapViewBtnAction(sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showbdMap"), object: nil)
    }
 
    @IBAction func ggMapViewBtnAction(sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showGgMap"), object: nil)
    }

}
