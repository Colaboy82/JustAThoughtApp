//
//  ViewController.swift
//  JustAThought
//
//  Created by Grumpy1211 on 12/21/17.
//  Copyright © 2017 MuSquared. All rights reserved.
//
/////DELEGATE CONNECT DATA SOURCE TABLE VIEW
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class SpecificThoughtVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    //defining firebase reference var
    
    var refUsers: DatabaseReference!
    var refThoughts: DatabaseReference!
    
    @IBOutlet weak var tableView: UITableView!
    
    var thoughtList = [ThoughtModel]()//list to store all the thought
   
    var userNameText: String!
    var userNameTextHolder: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        // Input data into the Array:
        refThoughts = Database.database().reference().child("thoughts");
        //observing the data changes
        refThoughts.observe(DataEventType.value, with: { (snapshot) in
            //if the reference have some values
            if snapshot.childrenCount > 0 {
                
                //clearing the list
                self.thoughtList.removeAll()
                
                //iterating through all the values
                for thoughts in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let thoughtObject = thoughts.value as? [String: AnyObject]
                    let thoughtText  = thoughtObject?["thought"]
                    let topicText = thoughtObject?["topic"]
                    let userName = thoughtObject?["users"]
                    let timeStamp = thoughtObject?["time"]
                    let city = thoughtObject?["city"]
                    let country = thoughtObject?["country"]
                    let likes = thoughtObject?["likes"]
                    let id = thoughtObject?["id"]
                    //creating artist object with model and fetched values
                    let thought = ThoughtModel(uid: id as! String?, typedThought: thoughtText as! String?, typedTopic: topicText as! String?, userName: userName as! String?, timeStamp: timeStamp as! String?, city: city as! String?, country: country as! String?, _likes: likes as! Int?)
                    
                    //adding it to list
                    if id as! String? == mainInstance.uid{
                        self.thoughtList.insert(thought, at: 0)
                    }
                }
                
                //reloading the tableview
                self.tableView.reloadData()
            }
        })
    }
    public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return thoughtList.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            var alreadyLikedBool: Bool!
            refUsers = Database.database().reference()
            //creating a cell using the custom class
            let cell = tableView.dequeueReusableCell(withIdentifier: "SpecificThoughtCell", for: indexPath) as! VCTableViewCell
            //the thought object
            let thought: ThoughtModel
            //getting the thought of selected position
            thought = thoughtList[indexPath.row]
            cell.configCell(thought: thought)
        
            //adding values to labels
            cell.thoughtLbl.text = mainInstance.thought
            cell.topicLbl.text = mainInstance.topic
            cell.userLbl.text = mainInstance.username
            cell.timeStampLbl.text = mainInstance.timeStamps
            cell.locationLbl.text = mainInstance.location
            cell.numOfLikes.text = mainInstance.numLikes
        
        
            Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { snapshot in
                guard let dict = snapshot.value as? [String:Any] else {
                    print("Error")
                    return
                }
                //let tempUid = "\(thought.uid)"
                let alreadyLiked = dict[thought.uid] as! Bool!
                if(alreadyLiked != nil){
                    alreadyLikedBool = alreadyLiked!
                }else{
                    alreadyLikedBool = false
                }
                if alreadyLikedBool == true {
                    cell.likeBtn.isHidden = true
                    cell.unlikeBtn.isHidden = false
                }
                if alreadyLikedBool == false{
                    cell.likeBtn.isHidden = false
                    cell.unlikeBtn.isHidden = true
                }
            })
            return cell
    }
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool{
        return false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
