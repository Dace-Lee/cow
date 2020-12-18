//
//  MyInfoTool.swift
//  Cowa
//
//  Created by gaojun on 2017/9/18.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit

class MyInfoTool: NSObject {

    static let tool = MyInfoTool()
    
    var backgroundView:UIView?
    
    func showInView(supView:UIView, title:String){
        
        if backgroundView == nil {
            backgroundView = UIView.init(frame: supView.bounds)
        }
        
        backgroundView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let v:MyInfo = Bundle.main.loadNibNamed("MyInfo", owner: self, options: nil)!.last as! MyInfo
        v.titleLabel.text = title
        
        
        v.center = (backgroundView?.center)!
        var frame = v.frame
        frame.size.width = 250
        frame.size.height = 80
        frame.origin.x = supView.frame.width/2 - 125
        v.frame = frame
        
        backgroundView?.addSubview(v)
        supView.addSubview(backgroundView!)
        
        let time = DispatchTime.now() + Double(Int64(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time) {
            if self.backgroundView != nil {
                self.backgroundView?.removeFromSuperview()
                self.backgroundView = nil
            }
        }
    }
    
}
