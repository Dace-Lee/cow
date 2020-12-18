//
//  RecommendVC.swift
//  Cowa
//
//  Created by gaojun on 2017/9/14.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit

class RecommendVC: SubVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.isNavRoot = true
        view.backgroundColor = UIColor.white
        
        createNavi()
        
        var urlPa:String = ""
        
        let lang = getLocalLanguage()
        if lang.hasPrefix("zh-Hans") {
            urlPa = "http://www.cowarobot.com"
        }else if lang.hasPrefix("ko"){
            urlPa = "http://www.cowarobot.co.kr"
        }else{
            urlPa = "http://www.cowarobot.com"
        }
        
        let url = URL.init(string: urlPa)!
        
        let webView = UIWebView()
        webView.frame = CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: self.view.frame.size.height)
        webView.loadRequest(URLRequest.init(url: url))
        view.addSubview(webView)
    }


    func createNavi(){
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        
        title = NSLocalizedString("MenuProducts", comment: "")
    }
    
    func getLocalLanguage() -> String{
        let defs = UserDefaults.standard
        let languages = defs.object(forKey: "AppleLanguages")
        let preferredLanguage = (languages! as AnyObject).object(at: 0)
        return String(describing: preferredLanguage)
    }
    
}
