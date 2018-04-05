//
//  SearchTopicViewCell.swift
//  JustAThought
//
//  Created by Grumpy1211 on 12/26/17.
//  Copyright © 2017 MuSquared. All rights reserved.
//

import UIKit

class SearchTopicViewCell: UITableViewCell {

    //labels connected
    @IBOutlet weak var topicName: UILabel!
    @IBOutlet weak var numOfPosts: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
