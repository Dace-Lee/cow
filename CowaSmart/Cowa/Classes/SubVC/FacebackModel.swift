//
//  FacebackModel.swift
//  Cowa
//
//  Created by 李来伟 on 2018/2/9.
//  Copyright © 2018年 MX. All rights reserved.
//

import UIKit
import SwiftyJSON
struct FacebackModel {

    var question: String
    var opition: String
    var rowHeight: CGFloat = 0
    init(json: JSON) {
//        self.question = "为什么手环插上电源没有红灯"
//        self.opition = "方格网瑞福特我让他热问题维特如果二个人二个人个人Greg二个人个人个二个人 Greg二个人个二个如果热个人个人股二Greg而过二 GREGRE个热个个人个人股热个李来伟"
////        self.opition = json["opition"].stringValue
        self.question = json["question"].stringValue
        self.opition = json["opition"].stringValue
       let h1 = (self.question as NSString).boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width - 100, height: 990), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont .systemFont(ofSize: 17)]), context: nil).size.height
        let h2 = (self.opition as NSString).boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width - 100, height: 990), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont .systemFont(ofSize: 15)]), context: nil).size.height
        rowHeight = h1 + h2 + 80
    }
}
//struct FacebackModelFrame {
//    var modelarr = [FacebackModel]()
//    var rowHeight: Float
//
//}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
