//
//  AvoidView.swift
//  Cowa
//
//  Created by gaojun on 2017/10/27.
//  Copyright © 2017年 MX. All rights reserved.
//

import UIKit

class AvoidView: UIView {

    var title = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var showView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.insertSubview(showView, aboveSubview: imageView)
        
    }
    
    func setTitleLabel(){
        titleLabel.text = title;
    }

}
