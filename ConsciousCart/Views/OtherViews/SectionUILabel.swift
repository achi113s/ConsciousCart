//
//  SectionUILabel.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/4/23.
//

import UIKit

class SectionUILabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        super.drawText(in: rect.inset(by: insets))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        font = UIFont.ccFont(textStyle: .semibold, fontSize: 13)
        textColor = UIColor.secondaryLabel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
