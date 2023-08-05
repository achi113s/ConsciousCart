//
//  ActiveImpulseTableViewCell.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/4/23.
//

import UIKit

class ActiveImpulseTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layer.cornerRadius = 10.0
        layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        layer.borderWidth = 1.0
        // Clip all layers that are bigger than the superlayer.
        // Forces cell highlighting to have the same corner radius.
        layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        layer.cornerRadius = 10.0
        layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        layer.borderWidth = 1.0
        // Clip all layers that are bigger than the superlayer.
        // Forces cell highlighting to have the same corner radius.
        layer.masksToBounds = true
    }
}
