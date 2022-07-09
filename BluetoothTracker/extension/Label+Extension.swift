//
//  Label+Extension.swift
//  BluetoothTracker
//
//  Created by link on 13.05.2022.
//

import UIKit

public class AppTextStyles {

    public func body(_ text: String = "") -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        label.textColor = UIColor.gray
        label.text = text
        return label
    }
}

extension UILabel {
    public static let app = AppTextStyles()
    
    var numberOfVisibleLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let textHeight = sizeThatFits(maxSize).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
    
    var maxNumberOfLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}
