//
//  UserProfileVC.swift
//  JustAThought
//
//  Created by Grumpy1211 on 12/31/17.
//  Copyright © 2017 MuSquared. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class UserDiaryVC: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var postCount: UILabel!
    
    var thoughtList = [ThoughtModel]()//list to store all the thought
    var refThoughts: DatabaseReference!
    var refLikes = Database.database().reference()

    var likeArray = [UserModel]()
    var sortedLikeArray = [UserModel]()
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return thoughtList.count
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        _ = tableView.cellForRow(at: indexPath!) as! UITableViewCell
        let currentThoughtCell = tableView.cellForRow(at: indexPath!) as! VCTableViewCell
        let thought: ThoughtModel
        //getting the thought of selected position
        thought = thoughtList[(indexPath?.row)!]
        currentThoughtCell.configCell(thought: thought)
        
        let numToString = (thought._likes).toString()
        mainInstance.thought = thought.typedThought!
        mainInstance.username = thought.userID!
        mainInstance.location = thought.city! + ", " + thought.country!
        mainInstance.timeStamps = thought.timeStamp!
        mainInstance.topic = thought.typedTopic!
        mainInstance.numLikes = numToString
        mainInstance.uid = thought.uid
        //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        //let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SpecificThoughtVC") as! SpecificThoughtVC
        //self.navigationController?.pushViewController(nextViewController, animated: true)
        performSegue(withIdentifier:"ToSpecificThoughtVC", sender: nil)
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSpecificCell", for: indexPath) as! VCTableViewCell
        var alreadyLikedBool: Bool!

        //the thought object
        let thought: ThoughtModel
        
        //getting the thought of selected position
        thought = thoughtList[indexPath.row]
        cell.configCell(thought: thought)
        let numToString = (thought._likes).toString()
        //adding values to labels
        //cell.thoughtLbl.text = thought.typedThought
        cell.topicLbl.text = thought.typedTopic
        cell.userLbl.text = thought.userID
        cell.timeStampLbl.text = thought.timeStamp
        cell.locationLbl.text = thought.city! + ", " + thought.country!
        cell.numOfLikes.text = numToString
        
        Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { snapshot in
            guard let dict = snapshot.value as? [String:Any] else {
                print("Error")
                return
            }
            /*let tempUid = "\(thought.uid!)"
            let alreadyLiked = dict[tempUid] as! Bool!
            if(alreadyLiked != nil){
                alreadyLikedBool = alreadyLiked!
            }else{
                alreadyLikedBool = false
            }
            if  alreadyLikedBool == true {
                cell.likeBtn.isHidden = true
                cell.unlikeBtn.isHidden = false
            }
            if alreadyLikedBool == false{
                cell.likeBtn.isHidden = false
                cell.unlikeBtn.isHidden = true
            }*/
        })
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("global class is " + mainInstance.currentUsername)
        userNameLbl.adjustsFontSizeToFitWidth = true
        userNameLbl.text = setUpShortUserName()//mainInstance.currentUsername
        navigationController?.isNavigationBarHidden = false

        refThoughts = Database.database().reference().child("thoughts");
        
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
                    let userID = thoughtObject?["UID"]
                    let timeStamp = thoughtObject?["time"]
                    let city = thoughtObject?["city"]
                    let country = thoughtObject?["country"]
                    let likes = thoughtObject?["likes"]
                    let id = thoughtObject?["id"]
                    
                    //creating artist object with model and fetched values
                    let thought = ThoughtModel(uid: id as! String?, typedThought: thoughtText as! String?, typedTopic: topicText as! String?, userID: userID as! String?, timeStamp: timeStamp as! String?, city: city as! String, country: country as! String, _likes: likes as! Int?)
                    
                    //appending it to list
                    //self.loadNumOfLikes(thoughtID: (id as! String?)!)
                    if userID as! String? == mainInstance.currentUsername{
                        self.thoughtList.insert(thought, at: 0)
                        let s = (self.thoughtList.count).toString()
                        self.postCount.text = "Num of Posts: \(s)"
                    }
                }
                //reloading the tableview
                self.tableView.reloadData()
            }
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logOutAction(sender: AnyObject) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginPage")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    func setUpShortUserName() -> String{
        let result = String(mainInstance.currentUsername.characters.prefix(10))
        return result
    }
}
