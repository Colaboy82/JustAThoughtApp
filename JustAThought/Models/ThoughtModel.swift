//
//  ThoughtModel.swift
//  JustAThought
//
//  Created by Grumpy1211 on 12/21/17.
//  Copyright © 2017 MuSquared. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ThoughtModel{
    var typedThought: String?
    var typedTopic: String?
    var userID: String?
    var timeStamp: String?
    var city: String?
    var country: String?
    var _likes: Int!
    var uid: String!
    //var peopleWhoLike: [String] = [String]()
    var thought: ThoughtModel!

    var likes: Int!{
        return _likes
    }
    init(uid: String?, typedThought: String?, typedTopic: String?, userID: String?, timeStamp: String?, city: String?, country: String?, _likes: Int?){
        self.typedThought = typedThought
        self.typedTopic = typedTopic
        self.timeStamp = timeStamp
        self.city = city
        self.country = country
        self._likes = _likes
        self.userID = userID
        self.uid = uid
    }
    func adjustLikes(addLike: Bool, thoughtID: String){
        var alreadyLiked: Bool!
        if addLike {
            _likes = likes + 1
            alreadyLiked = true
            mainInstance.numLikes = (_likes?.toString())!
        }else{
            _likes = likes - 1
            alreadyLiked = false
            mainInstance.numLikes = (_likes?.toString())!
        }
        Database.database().reference().root.child("users").child((Auth.auth().currentUser?.uid)!)
            .updateChildValues(["\(thoughtID)": alreadyLiked])
        Database.database().reference().root.child("thoughts").child(self.uid).updateChildValues(["likes": _likes])
        mainInstance.refreshLeaderboard = true
    }
}
