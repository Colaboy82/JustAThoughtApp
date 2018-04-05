//
//  FeedVC.swift
//  JustAThought
//
//  Created by Grumpy1211 on 12/20/17.
//  Copyright © 2017 MuSquared. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet var tableView: UITableView!

    var posts = [Post]()
    var post: Post!
    var userName: String!
    
    var refPosts: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        //getting a reference to the node posts
        refPosts = Database.database().reference().child("posts")
        
        //observing the data changes
        refPosts.observe(DataEventType.value, with: { (snapshot) in
            
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.posts.removeAll()
                
                //iterating through all the values
                for data in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let postObject = data.value as? [String: AnyObject]
                    let id = postObject?["id"]
                    let thought = postObject?["thought"]
                    let likes = postObject?["likes"]
                    
                    //creating artist object with model and fetched values
                    let post = Post(_id: id as! String, _thought: thought as! String?, _likes: likes as! Int?)
                    //appending it to list
                    self.posts.append(post)
                    
                }
                
                //reloading the tableview
                self.tableView.reloadData()
            }
        })
        
        
        /*refPosts.observe(.value, with: {(snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] { //all objects in snapshot
                
                self.posts.removeAll()
                
                for data in snapshot {
                    print(data)
                    if let postDict = data.value as? Dictionary<String, AnyObject>{
                        let key = data.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })*/
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.configCell(post: post)
        
        return cell
    }
    
    func PostToFirebase(imgUrl: String){
        let userID = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let data = snapshot.value as? Dictionary<String, AnyObject>{
            //if let snap = snapshot.value as? [String:Any] {
                let data = snapshot.value as! Dictionary<String, AnyObject>
                
                let username = data["username"]
                                
                let post: Dictionary<String, AnyObject> = [
                    "username": username as AnyObject,
                    "likes": 0 as AnyObject
                ]
                let firebasePost = Database.database().reference().child("posts").childByAutoId()
                firebasePost.setValue(post)
                self.tableView.reloadData()
            }
        })
    }
    
    @IBAction func postImageTapped(_ sender: AnyObject){//leads to text field box -> What are you thinking?
    
    }
    
    @IBAction func SignOut (_ sender: AnyObject){
        
        try! Auth.auth().signOut()
        
        KeychainWrapper.standard.removeObject(forKey: "uid")
        
    }
}

