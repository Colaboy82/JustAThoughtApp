//
//  PostCell.swift
//  JustAThought
//
//  Created by Grumpy1211 on 12/20/17.
//  Copyright © 2017 MuSquared. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftKeychainWrapper

class PostCell: UITableViewCell {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var wordCloud: UILabel!
    
    var post: Post!
    var userPostKey: DatabaseReference!
    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(post: Post){//= nil means they do not have to have pictures
        self.post = post
        //self.likesLbl.text = "\(post.likes)"
        //self.username.text = post.username
        
    }
    @IBAction func liked(_ sender: AnyObject){
        let likeRef = Database.database().reference().child("users").child(currentUser!).child("likes").child(post.postKey)

        likeRef.observeSingleEvent(of: .value, with:  { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.post.adjustLikes(addLike: true)
                
                likeRef.setValue(true)
                
            }else{
                self.post.adjustLikes(addLike: false)
                likeRef.removeValue()
            }
            })
        
    }
}
