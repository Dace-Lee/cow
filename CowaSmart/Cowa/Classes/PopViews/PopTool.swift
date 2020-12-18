//
//  PopTool.swift
//  Cowa
//
//  Created by gaojun on 2017/9/12.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit

class PopTool: NSObject {

    
    static let tool = PopTool()
    
    var backgroundView:UIView?
    
    func show(inView superView:UIView, withView subView:UIView, width:CGFloat, height:CGFloat){
        
        if backgroundView == nil {
            backgroundView = UIView.init(frame: superView.bounds)
        }
        
        backgroundView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        subView.center = (backgroundView?.center)!
        var size = subView.frame.size
        size.width = width
        size.height = height
        subView.frame.size = size
        
        if (backgroundView?.subviews.count)! > 0 {
            for subView in (backgroundView?.subviews)! {
                subView.removeFromSuperview()
            }
        }
        
        backgroundView?.addSubview(subView)
        superView.addSubview(backgroundView!)
        
    }
    
    func dismiss(){
        if backgroundView != nil {
            backgroundView?.removeFromSuperview()
            backgroundView = nil
        }
    }
    
}
