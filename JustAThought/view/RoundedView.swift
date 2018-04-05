//
//  RoundedView.swift
//  JustAThought
//
//  Created by Grumpy1211 on 12/20/17.
//  Copyright © 2017 MuSquared. All rights reserved.
//

import UIKit

class RoundedView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
    }

}
