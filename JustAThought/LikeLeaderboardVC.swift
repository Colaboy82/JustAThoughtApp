//
//  LikeLeaderboardVC.swift
//  JustAThought
//
//  Created by Grumpy1211 on 1/3/18.
//  Copyright © 2018 MuSquared. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
/*
 subtopicsArray.removeAll()
 subtopicInputSearchView.reloadData()
 */

class LikeLeaderboardVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var dropDownBtn: UIButton!
    @IBOutlet weak var tblLeaderboardList: UITableView!
    @IBOutlet weak var tenThoughtsTableView: UITableView!
    @IBOutlet weak var toolbarView: UIView!
    
    @IBOutlet weak var BackToMainTopicBtn: UIButton!
    
    @IBOutlet var dropDownConstraint: NSLayoutConstraint!
    @IBOutlet var dropDownSubTopicConstraint: NSLayoutConstraint!
    @IBOutlet var dropDownTopicConstraint: NSLayoutConstraint!
    @IBOutlet var dropDownCityConstraint: NSLayoutConstraint!
    
    var refThoughts: DatabaseReference!
    var refMainTopics: DatabaseReference!
    var topicRef = Database.database().reference()
    var refLocation = Database.database().reference()
    
    @IBOutlet weak var citySearchTableView: UITableView!
    var cityArray = [NSDictionary?]()
    var filteredCities = [NSDictionary?]()//ones in search bar
    var citySearchController: UISearchController!

    @IBOutlet weak var subtopicSearchView: UITableView!
    var subtopicsArray = [NSDictionary?]()
    var filteredSubtopics = [NSDictionary?]()
    var filteredSelectedSubtopics = [NSDictionary?]()
    var subtopicSearchController: UISearchController!
    
    @IBOutlet weak var topicSearchView: UITableView!
    var topicsArray = [NSDictionary?]()//all in database
    var filteredTopics = [NSDictionary?]()//ones in search bar
    var filteredSelectedTopics = [NSDictionary?]()
    var searchController: UISearchController!
    
    let arrayLeaderboards: NSMutableArray = ["Most Liked Thought (All Time)", "Most Liked Thought (Daily)", "Most Liked Thought (Topic)", "Most Liked Thought (Location)"]
    
    var dropDownShowing: Bool!
    var topicSearchShowing: Bool!
    var subtopicSearchShowing: Bool!
    var locationSearchShowing: Bool!
    
    var thoughtList = [ThoughtModel]()//list to store all the thought
    
    var mostLikedAllTimeList = [ThoughtModel]()
    var mostLikedDaily = [ThoughtModel]()
    var mostLikedPerTopic = [ThoughtModel]()
    var mostLikedByLocation = [ThoughtModel]()
    
    var selectedItem: NSString!
    var selectedTopicThought: String!
    var selectedCity: String!
    var selectedSubTopic: String!
    var timer: Timer!
    var searchTimers: Timer!
    var firstPart: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        dropDownConstraint.constant = -200
        dropDownShowing = false
        dropDownTopicConstraint.constant = -200
        topicSearchShowing = false
        dropDownSubTopicConstraint.constant = -200
        subtopicSearchShowing = false
        dropDownCityConstraint.constant = -200
        locationSearchShowing = false
        
        dropDownBtn.layer.cornerRadius = 5
        dropDownBtn.layer.borderWidth = 1
        dropDownBtn.layer.borderColor = UIColor.black.cgColor
        
        tblLeaderboardList.layer.cornerRadius = 5
        tblLeaderboardList.layer.borderWidth = 1
        tblLeaderboardList.layer.borderColor = UIColor.black.cgColor
        
        citySearchTableView.layer.cornerRadius = 5
        citySearchTableView.layer.borderWidth = 1
        citySearchTableView.layer.borderColor = UIColor.black.cgColor
        
        topicSearchView.layer.cornerRadius = 5
        topicSearchView.layer.borderWidth = 1
        topicSearchView.layer.borderColor = UIColor.black.cgColor
        
        subtopicSearchView.layer.cornerRadius = 5
        subtopicSearchView.layer.borderWidth = 1
        subtopicSearchView.layer.borderColor = UIColor.black.cgColor
        
        loadMostLikedAllTime()
        loadCities()
        loadMainTopics()
        timer = Timer.scheduledTimer(timeInterval: 0.05, target:self, selector: #selector(refreshLeaderboard), userInfo: nil, repeats: true)
        //self.navigationController?.isToolbarHidden = true
        toolbarView.isHidden = true
        BackToMainTopicBtn.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backToLeaderboard (sender: AnyObject){
        BackToMainTopicBtn.isHidden = true
        dropDownBtn.setTitle("Choose a Leaderboard", for: UIControlState.normal)
        dropDownConstraint.constant = 50
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        dropDownCityConstraint.constant = -200
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        dropDownTopicConstraint.constant = -200
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        dropDownSubTopicConstraint.constant = -200
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        self.citySearchController.isActive = false
        self.searchController.isActive = false
        self.subtopicSearchController.isActive = false
    }
    @IBAction func dropDownBtnPressed (sender: AnyObject){
        BackToMainTopicBtn.isHidden = true
        if dropDownShowing{
            dropDownConstraint.constant = -200
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            dropDownCityConstraint.constant = -200
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            dropDownTopicConstraint.constant = -200
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            dropDownSubTopicConstraint.constant = -200
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            self.citySearchController.isActive = false
            self.searchController.isActive = false
            self.subtopicSearchController.isActive = false
        }else{
            dropDownConstraint.constant = 50
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
        self.citySearchController.isActive = false
        self.searchController.isActive = false
        self.subtopicSearchController.isActive = false
        dropDownShowing = !dropDownShowing
    }
    @IBAction func backToMainTopics(_ sender: UIButton){
        searchController.isActive = false
        subtopicSearchController.isActive = false
        dropDownSubTopicConstraint.constant = -200
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        dropDownTopicConstraint.constant = 50
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        selectedTopicThought = ""
        BackToMainTopicBtn.isHidden = true
    }
    func updateSearchResults(for searchController: UISearchController) {
        if searchController == self.searchController {
            filterContent(searchText: self.searchController.searchBar.text!)
        }else if searchController == self.citySearchController{
            filterContent(searchText: self.citySearchController.searchBar.text!)
        }else if searchController == self.subtopicSearchController{
            filterContent(searchText: self.subtopicSearchController.searchBar.text!)
        }
    }
    func filterContent(searchText: String){
        if searchController.isActive && searchController.searchBar.text != ""{
            self.filteredTopics = self.topicsArray.filter{topic in
                let topic = topic!["TopicName"] as? String
                return (topic?.lowercased().contains(searchText.lowercased()))!
            }
            topicSearchView.reloadData()
        }else if subtopicSearchController.isActive && subtopicSearchController.searchBar.text != ""{
            self.filteredSubtopics = self.subtopicsArray.filter{subtopic in
                let subtopic = subtopic!["subtopicName"] as? String
                return (subtopic?.lowercased().contains(searchText.lowercased()))!
            }
            subtopicSearchView.reloadData()
        }else if citySearchController.isActive && citySearchController.searchBar.text != ""{
            self.filteredCities = self.cityArray.filter{city in
                let cityStuff = city!["cityName"] as? String
                return (cityStuff?.lowercased().contains(searchText.lowercased()))!
            }
            citySearchTableView.reloadData()
        }else{
            topicSearchView.reloadData()
            subtopicSearchView.reloadData()
            citySearchTableView.reloadData()
        }
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == tblLeaderboardList{
            return arrayLeaderboards.count
        }else if tableView == tenThoughtsTableView && selectedItem == "Most Liked Thought (Daily)"{
            return mostLikedDaily.count
        }else if tableView == subtopicSearchView{
            if subtopicSearchController.isActive && subtopicSearchController.searchBar.text != ""{
                return filteredSubtopics.count
            }
            return self.subtopicsArray.count
        }else if tableView == topicSearchView{
            if searchController.isActive && searchController.searchBar.text != ""{
                return filteredTopics.count
            }
            return self.topicsArray.count
        }else if tableView == citySearchTableView{
            if citySearchController.isActive && citySearchController.searchBar.text != ""{
                return filteredCities.count
            }
            return self.cityArray.count
        }else if tableView == topicSearchView{
            if searchController.isActive && searchController.searchBar.text != ""{
                return filteredTopics.count
            }
            return self.topicsArray.count
        }else if tableView == subtopicSearchView{
            if subtopicSearchController.isActive && subtopicSearchController.searchBar.text != ""{
                return filteredSubtopics.count
            }
            return self.subtopicsArray.count
        }else if tableView == tenThoughtsTableView && selectedItem == "Most Liked Thought (Location)"{
            return mostLikedByLocation.count
        }else if tableView == tenThoughtsTableView && selectedItem == "Most Liked Thought (Topic)"{
            return mostLikedPerTopic.count
        }else{
            return mostLikedAllTimeList.count
        }
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if tableView == self.topicSearchView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopicSearchCell", for: indexPath) as! UITableViewCell
            let topic: NSDictionary?
            
            if searchController.isActive && searchController.searchBar.text != ""{
                topic = filteredTopics[indexPath.row]
            }else{
                topic = self.topicsArray[indexPath.row]
            }
            cell.textLabel?.text = topic?["TopicName"] as? String
            cell.detailTextLabel?.text = topic?["NumOfPosts"] as? String //use to show how many posts are in the topic
            //print(topic?["NumOfPosts"] as? String)
            //returning cell
            return cell
        }else if tableView == self.subtopicSearchView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubTopicSearchCell", for: indexPath) as! UITableViewCell
            let subtopic: NSDictionary?
            if subtopicSearchController.isActive && subtopicSearchController.searchBar.text != ""{
                subtopic = filteredSubtopics[indexPath.row]
            }else{
                subtopic = self.subtopicsArray[indexPath.row]
            }
            cell.textLabel?.text = subtopic?["subtopicName"] as? String
            //cell.detailTextLabel?.text = topic?["NumOfPosts"] as? String //use to show how many posts are in the topic
            return cell
        }else if tableView == self.citySearchTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CitySearchCell", for: indexPath) as! UITableViewCell
            let city: NSDictionary?

            if citySearchController.isActive && citySearchController.searchBar.text != ""{
                city = filteredCities[indexPath.row]
            }else{
                city = cityArray[indexPath.row]
            }
            cell.textLabel?.text = city?["cityName"] as? String
            //returning cell
            return cell
        }else if tableView == tblLeaderboardList{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath) as UITableViewCell
            cell.textLabel?.text = arrayLeaderboards[indexPath.row] as? String
            return cell
        }else if tableView == tenThoughtsTableView && selectedItem == "Most Liked Thought (Topic)"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThoughtCells", for: indexPath) as! VCTableViewCell
            let thought: ThoughtModel
            var alreadyLikedBool: Bool!
            
            //getting the thought of selected position
            thought = mostLikedPerTopic[indexPath.row]
            cell.configCell(thought: thought)
            let numToString = (thought._likes).toString()
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
        }else if tableView == tenThoughtsTableView && selectedItem == "Most Liked Thought (Location)"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThoughtCells", for: indexPath) as! VCTableViewCell
            let thought: ThoughtModel
            var alreadyLikedBool: Bool!
            
            //getting the thought of selected position
            thought = mostLikedByLocation[indexPath.row]
            cell.configCell(thought: thought)
            let numToString = (thought._likes).toString()
            //adding values to labels
            //cell.thoughtLbl.text = thought.typedThought
            cell.topicLbl.text = thought.typedTopic
            cell.userLbl.text = thought.userName
            cell.timeStampLbl.text = thought.timeStamp
            cell.locationLbl.text = thought.city! + ", " + thought.country!
            cell.numOfLikes.text = numToString
            /*Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { snapshot in
                guard let dict = snapshot.value as? [String:Any] else {
                    print("Error")
                    return
                }
                let tempUid = "\(thought.uid!)"
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
                }
            })*/
            return cell
        }else if tableView == tenThoughtsTableView && selectedItem == "Most Liked Thought (Daily)"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThoughtCells", for: indexPath) as! VCTableViewCell
            let thought: ThoughtModel
            var alreadyLikedBool: Bool!

            //getting the thought of selected position
            thought = mostLikedDaily[indexPath.row]
            cell.configCell(thought: thought)
            let numToString = (thought._likes).toString()
            //adding values to labels
            //cell.thoughtLbl.text = thought.typedThought
            cell.topicLbl.text = thought.typedTopic
            cell.userLbl.text = thought.userName
            cell.timeStampLbl.text = thought.timeStamp
            cell.locationLbl.text = thought.city! + ", " + thought.country!
            cell.numOfLikes.text = numToString
            /*Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { snapshot in
                    guard let dict = snapshot.value as? [String:Any] else {
                        print("Error")
                        return
                    }
                    let tempUid = "\(thought.uid!)"
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
                    }
                })*/
            return cell
        }else if tableView == tenThoughtsTableView  && selectedItem == "Most Liked Thought (All Time)"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThoughtCells", for: indexPath) as! VCTableViewCell
            let thought: ThoughtModel
            var alreadyLikedBool: Bool!
            
            //getting the thought of selected position
            thought = mostLikedAllTimeList[indexPath.row]
            cell.configCell(thought: thought)
            let numToString = (thought._likes).toString()
            //adding values to labels
            //cell.thoughtLbl.text = thought.typedThought
            cell.topicLbl.text = thought.typedTopic
            cell.userLbl.text = thought.userName
            cell.timeStampLbl.text = thought.timeStamp
            cell.locationLbl.text = thought.city! + ", " + thought.country!
            cell.numOfLikes.text = numToString
            /*Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { snapshot in
                guard let dict = snapshot.value as? [String:Any] else {
                    print("Error")
                    return
                }
                let tempUid = "\(thought.uid!)"
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
                }
            })*/
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ThoughtCells", for: indexPath) as! VCTableViewCell
            let thought: ThoughtModel
            var alreadyLikedBool: Bool!
            
            //getting the thought of selected position
            thought = mostLikedAllTimeList[indexPath.row]
            cell.configCell(thought: thought)
            let numToString = (thought._likes).toString()
            //adding values to labels
            //cell.thoughtLbl.text = thought.typedThought
            cell.topicLbl.text = thought.typedTopic
            cell.userLbl.text = thought.userName
            cell.timeStampLbl.text = thought.timeStamp
            cell.locationLbl.text = thought.city! + ", " + thought.country!
            cell.numOfLikes.text = numToString
            /*Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { snapshot in
                guard let dict = snapshot.value as? [String:Any] else {
                    print("Error")
                    return
                }
                let tempUid = "\(thought.uid!)"
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
                }
            })*/
            return cell
        }
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        if tableView == tblLeaderboardList{
            let currentCell = tableView.cellForRow(at: indexPath!) as! UITableViewCell
            selectedItem = arrayLeaderboards.object(at:(indexPath?.row)!) as! NSString
            if selectedItem == "Most Liked Thought (All Time)"{
                toolbarView.isHidden = true
                dropDownBtn.setTitle(selectedItem as String, for: UIControlState.normal)
                loadMostLikedAllTime()
            }
            if selectedItem == "Most Liked Thought (Daily)"{
                dropDownBtn.setTitle(selectedItem as String, for: UIControlState.normal)
                toolbarView.isHidden = true
                loadMostLikedDaily()
            }
            if selectedItem == "Most Liked Thought (Location)"{
                dropDownBtn.setTitle("Choose a Location" as String, for: UIControlState.normal)
                //self.navigationController?.isToolbarHidden = true
                toolbarView.isHidden = true
                self.citySearchTableView.isHidden = false
                dropDownCityConstraint.constant = 50
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            }
            if selectedItem == "Most Liked Thought (Topic)"{
                dropDownBtn.setTitle("Choose a Topic" as String, for: UIControlState.normal)
                //self.navigationController?.isToolbarHidden = true
                toolbarView.isHidden = false
                self.topicSearchView.isHidden = false
                dropDownTopicConstraint.constant = 50
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            }
            dropDownConstraint.constant = -200
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            dropDownShowing = false
        }
        if tableView == topicSearchView {
            let currentCell = tableView.cellForRow(at: indexPath!) as! UITableViewCell
            BackToMainTopicBtn.isHidden = false
            selectedTopicThought = currentCell.textLabel!.text
            subtopicsArray.removeAll()
            subtopicSearchView.reloadData()
            loadSubTopics(MainTopic: selectedTopicThought, table: self.subtopicSearchView)
            self.searchController.isActive = false//
            self.subtopicSearchView.isHidden = false
            //self.navigationController?.isToolbarHidden = false
            toolbarView.isHidden = false
            dropDownTopicConstraint.constant = -200
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            dropDownSubTopicConstraint.constant = 50
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
        if tableView == subtopicSearchView{
            let currentCell = tableView.cellForRow(at: indexPath!) as! UITableViewCell
            toolbarView.isHidden = true
            BackToMainTopicBtn.isHidden = true
            selectedSubTopic = currentCell.textLabel!.text!
            self.subtopicSearchController.isActive = false//
            //self.navigationController?.isToolbarHidden = true
            toolbarView.isHidden = true
            loadMostLikedThoughtinTopic()
            dropDownSubTopicConstraint.constant = -200
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
        if tableView == citySearchTableView{
            let currentCell = tableView.cellForRow(at: indexPath!) as! UITableViewCell
            toolbarView.isHidden = true
            selectedCity = currentCell.textLabel!.text!
            loadMostLikedByLocation()
            self.citySearchController.isActive = false//
            //self.navigationController?.isToolbarHidden = true
            toolbarView.isHidden = true
            dropDownCityConstraint.constant = -200
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
        }
        if tableView == tenThoughtsTableView{
            let currentThoughtCell = tableView.cellForRow(at: indexPath!) as! VCTableViewCell
            let thought: ThoughtModel
            //getting the thought of selected position
            thought = thoughtList[(indexPath?.row)!]
            currentThoughtCell.configCell(thought: thought)
            
            let numToString = (thought._likes).toString()
            mainInstance.thought = thought.typedThought!
            mainInstance.username = thought.userName!
            mainInstance.location = thought.city! + ", " + thought.country!
            mainInstance.timeStamps = thought.timeStamp!
            mainInstance.topic = thought.typedTopic!
            mainInstance.numLikes = numToString
            mainInstance.uid = thought.uid
            
            performSegue(withIdentifier:"ToSpecificThoughtVCLeader", sender: nil)
        }
    }
    public func loadMostLikedAllTime(){
        mostLikedByLocation.removeAll()
        mostLikedDaily.removeAll()
        mostLikedAllTimeList.removeAll()
        mostLikedPerTopic.removeAll()
        self.tenThoughtsTableView.reloadData()
        
        self.citySearchTableView.isHidden = true
        
        refThoughts = Database.database().reference().child("thoughts")
        
        refThoughts.queryOrdered(byChild:"likes").observe(DataEventType.value, with: { (snapshot) in
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
                    self.thoughtList.insert(thought, at: 0)
                    }
                let i = 0
                var arraySize = 0
                if self.thoughtList.count <= 10 {
                    for i in i ..< (self.thoughtList.count){
                        self.mostLikedAllTimeList.insert(self.thoughtList[i], at: i)
                    }
                }else{
                    for i in i ..< 10{//10 elements
                        self.mostLikedAllTimeList.insert(self.thoughtList[i], at: arraySize)
                        arraySize = arraySize + 1
                    }
                }
                //reloading the tableview
                self.tenThoughtsTableView.reloadData()
            }
        })
    }
    public func loadMostLikedDaily(){
        mostLikedByLocation.removeAll()
        mostLikedDaily.removeAll()
        mostLikedAllTimeList.removeAll()
        mostLikedPerTopic.removeAll()
        self.tenThoughtsTableView.reloadData()
        
        refThoughts = Database.database().reference().child("thoughts")
        
        refThoughts.queryOrdered(byChild:"likes").observe(DataEventType.value, with: { (snapshot) in
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
                    self.thoughtList.insert(thought, at: 0)
                }
                let i = 0
                var shortTimeStampThought: String! //convert time stamp to just MM/DD/YY
                var arraySize = 0
                if self.thoughtList.count <= 10 {
                    for i in i ..< (self.thoughtList.count){
                        shortTimeStampThought = self.thoughtList[i].timeStamp
                        if let range = self.getTimeStamp().range(of:",") {
                            self.firstPart = String(self.getTimeStamp()[self.getTimeStamp().startIndex..<range.lowerBound])
                        }
                        if let range = shortTimeStampThought.range(of:",") {
                            shortTimeStampThought = String(shortTimeStampThought[shortTimeStampThought.startIndex..<range.lowerBound])
                        }
                        if self.firstPart == shortTimeStampThought {
                            self.mostLikedDaily.insert(self.thoughtList[i], at: arraySize)
                            arraySize = arraySize + 1
                        }
                    }
                }else{
                    for i in i ..< 10{//10 elements
                        shortTimeStampThought = self.thoughtList[i].timeStamp
                        if let range = self.getTimeStamp().range(of:",") {
                            self.firstPart = String(self.getTimeStamp()[self.getTimeStamp().startIndex..<range.lowerBound])
                        }
                        if let range = shortTimeStampThought.range(of:",") {
                            shortTimeStampThought = String(shortTimeStampThought[shortTimeStampThought.startIndex..<range.lowerBound])
                        }
                        if self.firstPart == shortTimeStampThought {
                            self.mostLikedDaily.insert(self.thoughtList[i], at: arraySize)
                            arraySize = arraySize + 1
                        }
                    }
                }
                //reloading the tableview
                self.tenThoughtsTableView.reloadData()
            }
        })
    }
    public func loadMostLikedThoughtinTopic(){
        mostLikedByLocation.removeAll()
        mostLikedDaily.removeAll()
        mostLikedAllTimeList.removeAll()
        mostLikedPerTopic.removeAll()
        self.tenThoughtsTableView.reloadData()
        
        refThoughts = Database.database().reference().child("thoughts")
        
        refThoughts.queryOrdered(byChild:"likes").observe(DataEventType.value, with: { (snapshot) in
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
                    self.thoughtList.insert(thought, at: 0)
                }
                let i = 0
                var arraySize = 0
                if self.thoughtList.count <= 10 {
                    for i in i ..< (self.thoughtList.count){
                        if self.thoughtList[i].typedTopic == self.selectedSubTopic {
                            self.mostLikedPerTopic.insert(self.thoughtList[i], at: arraySize)
                            arraySize = arraySize + 1
                        }
                    }
                }else{
                    for i in i ..< 10{//10 elements
                        if self.thoughtList[i].typedTopic == self.selectedSubTopic {
                            self.mostLikedPerTopic.insert(self.thoughtList[i], at: arraySize)
                            arraySize = arraySize + 1
                        }
                    }
                }
                //reloading the tableview
                self.tenThoughtsTableView.reloadData()
            }
        })
    }
    func loadMostLikedByLocation(){
        mostLikedByLocation.removeAll()
        mostLikedDaily.removeAll()
        mostLikedAllTimeList.removeAll()
        mostLikedPerTopic.removeAll()
        self.tenThoughtsTableView.reloadData()
        
        refThoughts = Database.database().reference().child("thoughts")
        
        refThoughts.queryOrdered(byChild:"likes").observe(DataEventType.value, with: { (snapshot) in
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
                    self.thoughtList.insert(thought, at: 0)
                }
                let i = 0
                var arraySize = 0
                if self.thoughtList.count <= 10 {
                    for i in i ..< (self.thoughtList.count){
                        if self.thoughtList[i].city == self.selectedCity {
                            self.mostLikedByLocation.insert(self.thoughtList[i], at: arraySize)
                            arraySize = arraySize + 1
                        }
                    }
                }else{
                    for i in i ..< 10{//10 elements
                        if self.thoughtList[i].city == self.selectedCity {
                            self.mostLikedByLocation.insert(self.thoughtList[i], at: arraySize)
                            arraySize = arraySize + 1
                        }
                    }
                }
                //reloading the tableview
                self.tenThoughtsTableView.reloadData()
            }
        })
    }
    @objc func refreshLeaderboard(){
        if mainInstance.refreshLeaderboard == true && selectedItem == "Most Liked Thought (All Time)" {
            loadMostLikedAllTime()
            mainInstance.refreshLeaderboard = false
        }
        if mainInstance.refreshLeaderboard == true && selectedItem == "Most Liked Thought (Daily)" {
            loadMostLikedDaily()
            mainInstance.refreshLeaderboard = false
        }
        if mainInstance.refreshLeaderboard == true && selectedItem == "Most Liked Thought (Topic)" {
            loadMostLikedThoughtinTopic()
            mainInstance.refreshLeaderboard = false
        }
        if mainInstance.refreshLeaderboard == true && selectedItem == "Most Liked Thought (Location)"{
            loadMostLikedByLocation()
            mainInstance.refreshLeaderboard = false
        }
    }
    func getTimeStamp() -> String{
        var time: String!
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return "\(formatter.string(from: date))"
    }
    func loadMainTopics(){
        topicRef.child("MainTopics").queryOrdered(byChild:"TopicName").observe(.childAdded, with: {(snapshot) in
            
            self.topicsArray.append(snapshot.value as? NSDictionary)
            
            //insert the rows
            self.topicSearchView.insertRows(at: [IndexPath(row:self.topicsArray.count - 1,section: 0)], with: UITableViewRowAnimation.automatic)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func loadSubTopics(MainTopic: String!, table: UITableView!){
        topicRef.child(MainTopic).queryOrdered(byChild:"subtopicName").observe(.childAdded, with: {(snapshot) in
            
            self.subtopicsArray.append(snapshot.value as? NSDictionary)
            //insert the rows
            table.insertRows(at: [IndexPath(row:self.subtopicsArray.count - 1,section: 0)], with: UITableViewRowAnimation.automatic)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func loadCities(){
        refLocation.child("Cities").queryOrdered(byChild:"cityName").observe(.childAdded, with: {(snapshot) in
            
            self.cityArray.append(snapshot.value as? NSDictionary)
            
            //insert the rows
            self.citySearchTableView.insertRows(at: [IndexPath(row:self.cityArray.count - 1,section: 0)], with: UITableViewRowAnimation.automatic)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        topicSearchView.tableHeaderView = searchController.searchBar
        
        citySearchController = UISearchController(searchResultsController: nil)
        citySearchController.searchResultsUpdater = self
        citySearchController.dimsBackgroundDuringPresentation = false
        citySearchController.searchBar.delegate = self
        citySearchTableView.tableHeaderView = citySearchController.searchBar
        
        subtopicSearchController = UISearchController(searchResultsController: nil)
        subtopicSearchController.searchResultsUpdater = self
        subtopicSearchController.dimsBackgroundDuringPresentation = false
        subtopicSearchController.searchBar.delegate = self
        subtopicSearchView.tableHeaderView = subtopicSearchController.searchBar
    }
}
