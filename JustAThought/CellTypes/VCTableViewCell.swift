//
//  VCTableViewCell.swift
//  JustAThought
//
//  Created by Grumpy1211 on 12/21/17.
//  Copyright © 2017 MuSquared. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class VCTableViewCell: UITableViewCell {

    //labels connected
    @IBOutlet weak var thoughtLbl: UILabel!
    @IBOutlet weak var topicLbl: UILabel!
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var numOfLikes: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var unlikeBtn: UIButton!
   
    var thought: ThoughtModel!
    var parentTableViewController : ViewController!
    var indexPathForRow : Int!
    var likeRef = Database.database().reference()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configCell(thought: ThoughtModel){//= nil means they do not have to have pictures
        self.thought = thought
        
    }
    @IBAction func likePressed(_ sender: Any){
        let likeRef = Database.database().reference().child("thoughts").child("likes")
        
        likeRef.observeSingleEvent(of: .value, with:  { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.thought.adjustLikes(addLike: true, thoughtID: self.thought.uid)
            }
        })
        var a:Int? = Int(mainInstance.numLikes)
        a = a!+1
        mainInstance.numLikes = (a?.toString())!
        
        //likeBtn.isHidden = true
        //unlikeBtn.isHidden = false
    }
    @IBAction func unlikePressed(_ sender: Any){
        let likeRef = Database.database().reference().child("thoughts").child("likes")

        likeRef.observeSingleEvent(of: .value, with:  { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.thought.adjustLikes(addLike: false, thoughtID: self.thought.uid)
            }
        })
        var a:Int? = Int(mainInstance.numLikes)
        a = a!-1
        mainInstance.numLikes = (a?.toString())!
        //likeBtn.isHidden = false
        //unlikeBtn.isHidden = true
    }
}
