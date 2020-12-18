//
//  TBgImageManager.swift
//  Cowa
//
//  Created by MX on 16/5/27.
//  Copyright © 2016年 MX. All rights reserved.
//

import UIKit

class TBgImageManager: NSObject {
    
    static let sharedBgImgManager = TBgImageManager()
    let imgView = UIImageView.init()
    
    fileprivate override init() {
        super.init()
    }
    
    func assembleImgInView(_ view: UIView!, bgPic picStr:String!) {
        imgView.frame = view.bounds;
        view.insertSubview(imgView, at: 0)
        updateImg(picStr: picStr)
    }
    
    func updateImg(picStr:String) {
        let img = UIImage.init(named: picStr)
        imgView.image = img
    }
    
}
