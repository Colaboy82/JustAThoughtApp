//
//  Global.swift
//  JustAThought
//
//  Created by Grumpy1211 on 12/27/17.
//  Copyright © 2017 MuSquared. All rights reserved.
//

import Foundation

class Main {
    var selectedTopic:String
    var selectedCity: String
    var currentUsername: String
    var likeBtnShow: Bool
    var toolbarShow: Bool
    var refreshLeaderboard: Bool
    var thought: String
    var username: String
    var numLikes: String
    var timeStamps: String
    var location: String
    var topic: String
    var uid: String
    var profile: Bool //for reset password view controller
    
    init(selectedTopic:String,selectedCity:String,currentUsername: String, likeBtnShow: Bool, toolbarShow: Bool, refreshLeaderboard: Bool, thought: String, username: String, numLikes: String, timeStamps: String, location: String, topic: String, uid: String, profile: Bool) {
        self.selectedTopic = selectedTopic
        self.selectedCity = selectedCity
        self.currentUsername = currentUsername
        self.likeBtnShow = likeBtnShow
        self.toolbarShow = toolbarShow
        self.refreshLeaderboard = refreshLeaderboard
        self.thought = thought
        self.username = username
        self.numLikes = numLikes
        self.timeStamps = timeStamps
        self.location = location
        self.topic = topic
        self.uid = uid
        self.profile = profile
    }
}
var mainInstance = Main(selectedTopic:"My Global Class", selectedCity: "", currentUsername: "", likeBtnShow: true, toolbarShow: false, refreshLeaderboard: false, thought: "", username: "", numLikes: "", timeStamps: "", location: "", topic: "", uid: "", profile: false)

