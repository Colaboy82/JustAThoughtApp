//
//  SpecificTopicVCViewController.swift
//  JustAThought
//
//  Created by Grumpy1211 on 12/27/17.
//  Copyright © 2017 MuSquared. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class SpecificCityVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityLbl: UILabel!
    
    var thoughtList = [ThoughtModel]()//list to store all the thought
    var refThoughts: DatabaseReference!
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return thoughtList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        var alreadyLikedBool: Bool!
        //creating a cell using the custom class
        let cell = tableView.dequeueReusableCell(withIdentifier: "specificCityCell", for: indexPath) as! VCTableViewCell
        
        //the thought object
        let thought: ThoughtModel
        
        //getting the thought of selected position
        thought = thoughtList[indexPath.row]
        cell.configCell(thought: thought)
        let numToString = (thought._likes).toString()
        
        cell.topicLbl.adjustsFontSizeToFitWidth = true
        cell.userLbl.adjustsFontSizeToFitWidth = true
        cell.locationLbl.adjustsFontSizeToFitWidth = true
        cell.timeStampLbl.adjustsFontSizeToFitWidth = true
        cell.numOfLikes.adjustsFontSizeToFitWidth = true
        
        //adding values to labels
        //cell.thoughtLbl.text = thought.typedThought
        cell.topicLbl.text = thought.typedTopic
        cell.userLbl.text = thought.userName
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
                if  alreadyLikedBool == true || mainInstance.likeBtnShow == true{
                    cell.likeBtn.isHidden = true
                    cell.unlikeBtn.isHidden = false
                }
                if alreadyLikedBool == false || mainInstance.likeBtnShow == false{
                    cell.likeBtn.isHidden = false
                    cell.unlikeBtn.isHidden = true
                }*/
            })
        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentThoughtCell = tableView.cellForRow(at: indexPath) as! VCTableViewCell
        let thought: ThoughtModel
        //getting the thought of selected position
        thought = thoughtList[(indexPath.row)]
        currentThoughtCell.configCell(thought: thought)
    
        let numToString = (thought._likes).toString()
        mainInstance.thought = thought.typedThought!
        mainInstance.username = thought.userName!
        mainInstance.location = thought.city! + ", " + thought.country!
        mainInstance.timeStamps = thought.timeStamp!
        mainInstance.topic = thought.typedTopic!
        mainInstance.numLikes = numToString
        mainInstance.uid = thought.uid
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SpecificThoughtVC") as! SpecificThoughtVC
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("global class is " + mainInstance.selectedCity)
        cityLbl.text = mainInstance.selectedCity
        
        refThoughts = Database.database().reference().child("thoughts"); //"artists"
        
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
                    let thought = ThoughtModel(uid: id as! String?, typedThought: thoughtText as! String?, typedTopic: topicText as! String?, userName: userName as! String?, timeStamp: timeStamp as! String?, city: city as! String, country: country as! String, _likes: likes as! Int?)
                    
                    //appending it to list
                    //self.thoughtList.append(thought)
                    if city as! String? == mainInstance.selectedCity{
                        self.thoughtList.insert(thought, at: 0)
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
    
}

