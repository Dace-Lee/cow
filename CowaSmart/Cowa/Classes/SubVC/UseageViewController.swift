//
//  UseageViewController.swift
//  Cowa
//
//  Created by gaojun on 2017/2/21.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit
import WebKit


class UseageViewController: SubVC {

    let webView:WKWebView = WKWebView()
    
    var totalScale:CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.isNavRoot = true
        createNavi()
        
        
        let pinch = UIPinchGestureRecognizer(target: self,action: #selector(pinch(_:)))
        self.view.addGestureRecognizer(pinch)
        
        let slide = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        self.view.addGestureRecognizer(slide)
        
        let items = [NSLocalizedString("BagUse", comment: ""),NSLocalizedString("AppUse", comment: "")]
        let segment = UISegmentedControl(items:items)
        //segment.backgroundColor = UIColor.white
        segment.selectedSegmentIndex = 0
        segment.tintColor = UIColor.white
        segment.addTarget(self, action: #selector(segmentAction(_:)), for: .valueChanged)
        self.navigationItem.titleView = segment
        
        webView.frame = CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: self.view.frame.size.height)
        self.view.addSubview(webView)
        
        _ = segmentAction(segment)
    }
    
    func createNavi(){
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
    }
    
    @objc func pinch(_ recognizer:UIPinchGestureRecognizer){
       
        let scale:CGFloat = recognizer.scale
        //放大情况
        if scale > 1.0 {
            if(self.totalScale > 2.0){
            return
            }
        }
        
        //缩小情况
        if scale < 1.0 {
            if (self.totalScale < 0.5)
            {
            return;
            }
        }
        
        self.view.transform = self.view.transform.scaledBy(x: scale, y: scale);
        self.totalScale *= scale;
        recognizer.scale = 1.0;
        
       
    }
    
    @objc func pan(_ recognizer:UIPanGestureRecognizer){
        if recognizer.state == .began || recognizer.state == .changed
        {
            let pt = recognizer.translation(in: self.view)
            recognizer.view?.center = CGPoint(x: (recognizer.view?.center.x)! + pt.x, y: (recognizer.view?.center.y)! + pt.y)
            recognizer .setTranslation(CGPoint.zero, in: self.view)
        }
        
    }

    @objc func segmentAction(_ segmented:UISegmentedControl){
        
        var urlPath:String = ""
        
        if segmented.selectedSegmentIndex == 0 {

            let lang = getLocalLanguage()


            print("\(lang)")
            if lang.hasPrefix("zh-Hans") {
                urlPath = "http://a3.rabbitpre.com/m/BFRNvu9"
            }else if lang.hasPrefix("ko"){
                urlPath = "http://a3.rabbitpre.com/m/JZFbq2l"
            }else if lang.hasPrefix("zh-Hant"){
                urlPath = "http://a2.rabbitpre.com/m2/aUe1ZjFd9y"
            }else{
                urlPath = "http://a2.rabbitpre.com/m/yVBQI3jb5"
            }

            let url = URL.init(string: urlPath)
            webView.load(URLRequest.init(url: url!))
        }else{

            let lang = getLocalLanguage()


            if lang.hasPrefix("zh-Hans") {
                urlPath = "http://a3.rabbitpre.com/m/Y3Vvq6eMB"
            }else if lang.hasPrefix("ko"){
                urlPath = "http://a2.rabbitpre.com/m/JRIBAuirz"
            }else if lang.hasPrefix("zh-Hant"){
                urlPath = "http://a2.rabbitpre.com/m2/aUe1ZjFgpr"
            }else{
                urlPath = "http://a2.rabbitpre.com/m/BB3YRfE"
            }

            let url = URL.init(string: urlPath)
            webView.load(URLRequest.init(url: url!))
        }
        
    }
    
    func getLocalLanguage() -> String{
        let defs = UserDefaults.standard
        let languages = defs.object(forKey: "AppleLanguages")
        let preferredLanguage = (languages! as AnyObject).object(at: 0)
        return String(describing: preferredLanguage)
    }

}
