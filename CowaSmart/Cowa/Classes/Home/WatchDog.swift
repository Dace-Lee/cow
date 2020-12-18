//
//  WatchDog.swift
//  Cowa
//
//  Created by gaojun on 2017/7/10.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit

class WatchDog: NSObject {
    
    static let dog = WatchDog()
    
    var TTL = 3*60
    
    var timer:Timer?
    
    func start(){
        
        TTL = 3*60
        
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(clockEvent), userInfo: nil, repeats: true)
        }
        
    }
    
    func stop(){
        
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
        
        
    }
    
    func clockEvent(){
        
        if TTL <= 0 {
            
            syncnise()
            
            TTL = 3*60
            
        }
        
        TTL -= 1
        
    }
    
    func syncnise(){
        
           DataSycnizeHelper.helper.startSycn((TBLEManager.sharedManager.dev?.status.imeiString)!)
    }
    
}
