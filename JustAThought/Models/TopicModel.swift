//
//  TopicModel.swift
//  JustAThought
//
//  Created by Grumpy1211 on 12/25/17.
//  Copyright © 2017 MuSquared. All rights reserved.
//

import Foundation

class TopicModel{
    var topicName: String?
    var username: String?
    var userEmail: String?
    
    init(topicName: String?, userEmail: String?){
        self.userEmail = userEmail
        //self.username = username
        self.topicName = topicName
    }
    
}
