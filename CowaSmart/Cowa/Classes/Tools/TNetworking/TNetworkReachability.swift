//
//  TNetworkReachability.swift
//  weather-Swift
//
//  Created by MX on 16/3/26.
//  Copyright © 2016年 MX. All rights reserved.
//

import UIKit
import ReachabilitySwift

class TNetworkReachability: NSObject {
    static let sharedInstance = TNetworkReachability()
    
    var reachability: Reachability?
    
    //首先默认网络是可以连通的
    var reachable: Bool = true
    
    fileprivate override init() {
        super.init()
        self.setup()
    }
    
    deinit {
        self.reachability?.stopNotifier()
    }
    
    fileprivate func setup() {
        
        let reach = Reachability()
        self.reachability = reach
        
        self.reachability?.whenReachable = { [weak self] reachability in
            DispatchQueue.main.async(execute: {
                if let strongSelf = self {
                    strongSelf.reachable = true
                    //print("网络开启")
                }
            })
        }
        self.reachability?.whenUnreachable = { [weak self] reachability in
            DispatchQueue.main.async(execute: {
                if let strongSelf = self {
                    strongSelf.reachable = false
                    //print("网络关闭")
                }
            })
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            
        }
    }
}
