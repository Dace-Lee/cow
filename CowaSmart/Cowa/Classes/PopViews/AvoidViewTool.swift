//
//  AvoidViewTool.swift
//  Cowa
//
//  Created by gaojun on 2017/9/18.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit

class AvoidViewTool: NSObject {

    static let tool = AvoidViewTool()
    
    var backgroundView:UIView?
    
    func showInView(supView:UIView, title:String){
        
        if backgroundView == nil {
            backgroundView = UIView.init(frame: supView.bounds)
        }
        
        backgroundView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let v:BindSuccess = Bundle.main.loadNibNamed("BindSuccess", owner: self, options: nil)!.last as! BindSuccess
        v.titleLabel.text = title
        
        
        v.center = (backgroundView?.center)!
        var size = v.frame.size
        size.width = 175
        size.height = 155
        v.frame.size = size
        
        
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
