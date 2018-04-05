//
//  CircleImage.swift
//  JustAThought
//
//  Created by Grumpy1211 on 12/20/17.
//  Copyright © 2017 MuSquared. All rights reserved.
//

import UIKit

class CircleImage: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true //makes sure the image goes into a circle
    }

}
