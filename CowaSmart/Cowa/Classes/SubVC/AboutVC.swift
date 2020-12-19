//
//  AboutVC.swift
//  Cowa
//
//  Created by gaojun on 2017/9/14.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit
import WebKit

class AboutVC: SubVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.isNavRoot = true
        view.backgroundColor = UIColor.white
        
        createNavi()
        
        var urlPa:String = ""
        
        let lang = getLocalLanguage()
        if lang.hasPrefix("zh-Hans") {
            urlPa = "http://123.206.201.57/text/privacy_cn.html"
        }else if lang.hasPrefix("ko"){
            urlPa = "http://123.206.201.57/text/privacy_ko.html"
        }else if lang.hasPrefix("zh-Hant"){
            urlPa = "http://server.cowarobot.com/text/privacy_tw.html"
        }else{
            urlPa = "http://123.206.201.57/text/privacy_en.html"
        }
        
        
        let url = URL.init(string: urlPa)!
        
        let webView = WKWebView()
        webView.frame = CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: self.view.frame.size.height)
        webView.load(URLRequest.init(url: url))
        view.addSubview(webView)
        
    }
    
    func createNavi(){
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        
        title = NSLocalizedString("MenuAbout", comment: "")
    }
    
    func getLocalLanguage() -> String{
        let defs = UserDefaults.standard
        let languages = defs.object(forKey: "AppleLanguages")
        let preferredLanguage = (languages! as AnyObject).object(at: 0)
        return String(describing: preferredLanguage)
    }


}
