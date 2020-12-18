//
//  BaseFloatingDrawerVC.swift
//  Cowa
//
//  Created by MX on 16/4/28.
//  Copyright © 2016年 MX. All rights reserved.
//

import UIKit
import DynamicButton
import RESideMenu

///需要更改边栏状态
let kBaseFloatingDrawerNeedChangeSideStatus = "kBaseFloatingDrawerNeedChangeSideStatus"

//基础视图，用来管理和实现侧滑效果的视图。为了实现特定的效果，所以center（home）视图是集成的一个navigation 视图，而left视图是一个menu。
class BaseVC: RESideMenu, RESideMenuDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        addListener()
        navigationController?.setNavigationBarHidden(true, animated: false)
        scaleContentView = false
        scaleMenuView = false
        delegate = self
        contentViewShadowColor = UIColor.gray
        contentViewShadowOpacity = 0.6
        panGestureEnabled = true
        panFromEdge = true
        let sideWidth: CGFloat = UIScreen.main.bounds.width / 2.0 - 75.0
        contentViewInPortraitOffsetCenterX = sideWidth
        
        let ge = UISwipeGestureRecognizer.init(target: self, action: #selector(geAction))
        ge.direction = .left
        view.addGestureRecognizer(ge)
    }
    
    func geAction(){
        self.hideViewController()
    }
    
    //MARK: Event
    @objc fileprivate func eReceviceNitifyForChangeSideStatus() {
        self.presentLeftMenuViewController()
    }
    
    
    //MARK: Private methods
    fileprivate func addListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.eReceviceNitifyForChangeSideStatus), name: NSNotification.Name(rawValue: kBaseFloatingDrawerNeedChangeSideStatus), object: nil)
        self.addObserver(self, forKeyPath: "currentlyOpenedSide", options: .new, context: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.removeObserver(self, forKeyPath: "currentlyOpenedSide")
    }
    
    
    func sideMenu(_ sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
        leftMenuViewController.viewWillAppear(false)
    }
    
}
