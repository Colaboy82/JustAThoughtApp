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
    @IBOutlet weak var thoughtLbl: UILabel!
    @IBOutlet weak var topicLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var numOfLikes: UILabel!
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var unlikeBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    
    var thoughtList = [ThoughtModel]()//list to store all the thought
   
    var userNameText: String!
    var userNameTextHolder: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
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
                    let userId = thoughtObject?["UID"]
                    let timeStamp = thoughtObject?["time"]
                    let city = thoughtObject?["city"]
                    let country = thoughtObject?["country"]
                    let likes = thoughtObject?["likes"]
                    let id = thoughtObject?["id"]
                    //creating artist object with model and fetched values
                    let thought = ThoughtModel(uid: id as! String?, typedThought: thoughtText as! String?, typedTopic: topicText as! String?, userID: userId as! String?, timeStamp: timeStamp as! String?, city: city as! String?, country: country as! String?, _likes: likes as! Int?)
                    
                    //adding it to list
                    if id as! String? == mainInstance.uid{
                        self.thoughtList.insert(thought, at: 0)
                    }
                }
                self.thoughtLbl.adjustsFontSizeToFitWidth = true
                self.topicLbl.adjustsFontSizeToFitWidth = true
                self.userLbl.adjustsFontSizeToFitWidth = true
                self.locationLbl.adjustsFontSizeToFitWidth = true
                self.timeStampLbl.adjustsFontSizeToFitWidth = true
                self.numOfLikes.adjustsFontSizeToFitWidth = true
                
                //adding values to labels
                self.thoughtLbl.text = mainInstance.thought
                self.topicLbl.text = mainInstance.topic
                self.userLbl.text = self.convertToShortUserName(s: mainInstance.username)
                self.timeStampLbl.text = mainInstance.timeStamps
                self.locationLbl.text = mainInstance.location
                self.numOfLikes.text = mainInstance.numLikes
                
                //unlike and like Btn code
                var alreadyLikedBool: Bool!
                let thought: ThoughtModel
                thought = self.thoughtList[0];
                
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
                        self.likeBtn.isHidden = true
                        self.unlikeBtn.isHidden = false
                    }
                    if alreadyLikedBool == false{
                        self.likeBtn.isHidden = false
                        self.unlikeBtn.isHidden = true
                    }
                })
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
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.black.cgColor
        
            cell.thoughtLbl.adjustsFontSizeToFitWidth = true
            cell.topicLbl.adjustsFontSizeToFitWidth = true
            cell.userLbl.adjustsFontSizeToFitWidth = true
            cell.locationLbl.adjustsFontSizeToFitWidth = true
            cell.timeStampLbl.adjustsFontSizeToFitWidth = true
            cell.numOfLikes.adjustsFontSizeToFitWidth = true
            
            //adding values to labels
            cell.thoughtLbl.text = mainInstance.thought
            cell.topicLbl.text = mainInstance.topic
            cell.userLbl.text = convertToShortUserName(s: mainInstance.username)
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
    @IBAction func likePressed(_ sender: Any){
        let likeRef = Database.database().reference().child("thoughts").child("likes")
        
        likeRef.observeSingleEvent(of: .value, with:  { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.thoughtList[0].adjustLikes(addLike: true, thoughtID: self.thoughtList[0].uid)
            }
        })
        var a:Int? = Int(mainInstance.numLikes)
        a = a!+1
        mainInstance.numLikes = (a?.toString())!
        
        likeBtn.isHidden = true
        unlikeBtn.isHidden = false
    }
    @IBAction func unlikePressed(_ sender: Any){
        let likeRef = Database.database().reference().child("thoughts").child("likes")
        
        likeRef.observeSingleEvent(of: .value, with:  { (snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.thoughtList[0].adjustLikes(addLike: false, thoughtID: self.thoughtList[0].uid)
            }
        })
        var a:Int? = Int(mainInstance.numLikes)
        a = a!-1
        mainInstance.numLikes = (a?.toString())!
        likeBtn.isHidden = false
        unlikeBtn.isHidden = true
    }
    func setNavigationBar() {
        self.navigationItem.title = "The Thought"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "Menlo", size: 21)!]
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Menlo", size: 20)!], for: [])//UIControlState.Normal)
        navigationItem.backBarButtonItem = backButton
    }
    func convertToShortUserName(s: String) -> String{
        let result = String(s.characters.prefix(10))
        return result
    }
}
