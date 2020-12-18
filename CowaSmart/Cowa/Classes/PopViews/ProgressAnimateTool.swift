//
//  ProgressAnimateTool.swift
//  Cowa
//
//  Created by gaojun on 2017/9/12.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit

class ProgressAnimateTool: NSObject {

    static let tool = ProgressAnimateTool()
    
    var imageView:UIImageView?
    
    func show(inView:UIView){
        
        for subView in inView.subviews {
            if subView.tag == 1000 {
                subView.removeFromSuperview()
            }
        }
        let image = UIImage.sd_animatedGIFNamed("加载动画")
        if imageView == nil {
            imageView = UIImageView.init(image: image)
        }
        
        imageView?.tag = 1000
        var size = imageView?.frame.size
        size?.width = 80
        size?.height = 80
        imageView?.frame.size = size!
        
        imageView?.center = inView.center
        
        inView.addSubview(imageView!)
    }
    
    func dismiss(){
        if imageView != nil {
            imageView?.removeFromSuperview()
            imageView = nil
        }
    }
    
}
