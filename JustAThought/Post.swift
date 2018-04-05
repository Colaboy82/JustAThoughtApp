//
//  Posts.swift
//  JustAThought
//
//  Created by Grumpy1211 on 12/20/17.
//  Copyright © 2017 MuSquared. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class Post {
    var _thought: String?
    var _likes: Int?
    var _id: String?
    
    
    var _username: String?
    private var _userImg: String!
    private var _postImg: String!
    private var _postKey: String!
    private var _postRef: DatabaseReference!
    
    var id: String!{
        return _id
    }
    
    
    var username: String!{
        return _username
    }
    var userImg: String!{
        return _userImg
    }
    var postImg: String!{
        get{
            return _postImg
        }set{
            _postImg = newValue
        }
    }
    var likes: Int!{
        return _likes
    }
    var postKey: String!{
        return _postKey
    }
    init(_id: String?, _thought: String?, _likes: Int?){
        self._id = id
        self._thought = nil
        self._likes = likes
    }
    init(imgUrl: String, likes: Int, username: String, userImg: String){
        
        _postImg = imgUrl
        _likes = likes
        _username = username
        _userImg = userImg
        _postKey = nil
    }
    
    /*init(postKey: String, postData: Dictionary<String, AnyObject>) {
        _postKey = postKey
        
        if let username = postData["username"] as? String{
            _username = username
        }
        
        if let userImg = postData["userImg"] as? String{
            _userImg = userImg
        }
        if let postImage = postData["imageUrl"] as? String{
            _postImg = postImage
        }
        if let likes = postData["likes"] as? Int {
            _likes = likes
        }
        
        _postRef = Database.database().reference().child("posts").child(_postKey)
    }*/
    
    func adjustLikes(addLike: Bool){
        
        if addLike {
            _likes = likes + 1
        }else{
            _likes = likes - 1
        }
        _postRef.child("likes").setValue(_likes)
    }
    
}
