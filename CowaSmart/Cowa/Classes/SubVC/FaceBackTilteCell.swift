//
//  FaceBackTilteCell.swift
//  Cowa
//
//  Created by 李来伟 on 2018/2/9.
//  Copyright © 2018年 MX. All rights reserved.
//

import UIKit
import SnapKit

class FaceBackTilteCell: UITableViewCell {
    @IBOutlet weak var contentImageV: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleImageV: UIImageView!
    var rowHeight: CGFloat = 0
    var model: FacebackModel? {
        didSet {
            if let model = model {
                titleLabel.text = model.question
                contentLabel.text = model.opition
                
                let titleHeight =  (model.question as NSString).boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width - 100, height: 990), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):UIFont .systemFont(ofSize: 17)]), context: nil).size.height
                titleImageV.frame = CGRect(x: 35, y: 37, width: 16, height: 16)
                titleLabel.frame = CGRect(x: 61, y: 30, width: UIScreen.main.bounds.size.width - 110, height: titleHeight + 10)
                titleLabel.numberOfLines = 0
            let contentHeight =   (model.opition as NSString).boundingRect(with: CGSize(width: UIScreen.main.bounds.size.width - 110, height: 990), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: nil, context: nil).size.height
                contentImageV.frame = CGRect(x: 37, y: titleLabel.frame.maxY + 18, width: 14, height: 14)
                contentLabel.frame = CGRect(x:  61, y: titleLabel.frame.maxY + 10 , width: UIScreen.main.bounds.size.width - 110, height: contentHeight + 20)
                contentLabel.numberOfLines = 0
//            rowHeight = titleHeight + contentHeight + 20
                
            }
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
	return input.rawValue
}
