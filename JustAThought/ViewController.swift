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
import CoreLocation


extension Int
{
    func toString() -> String
    {
        var myString = String(self)
        return myString
    }
}
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate, CLLocationManagerDelegate, UITextFieldDelegate, UITextViewDelegate {
        //defining firebase reference var
        var refThoughts: DatabaseReference!
        var refUsers: DatabaseReference!
        var refMainTopics: DatabaseReference!
        var topicRef = Database.database().reference()
        var refLocation = Database.database().reference()
    
        //Main Bar Buttons
        @IBOutlet weak var menuBtn: UIButton!
        @IBOutlet weak var profileBtn: UIButton!
        @IBOutlet weak var diaryBtn: UIButton!
        @IBOutlet weak var locationBtn: UIButton!
    
        @IBOutlet weak var mainBar: UIView!
        @IBOutlet weak var searchMenuView: UIView!
        @IBOutlet weak var searchView: UIView!
        @IBOutlet weak var enterThoughtView: UIView!
        @IBOutlet weak var searchCityView: UIView!
    
        @IBOutlet weak var thoughtInput: UITextView!
    
        @IBOutlet weak var topicSelectedMessage: UILabel!
        @IBOutlet weak var tableView: UITableView!
        @IBOutlet weak var topicSearchView: UITableView!
        @IBOutlet weak var topicInputSearchView: UITableView!
        @IBOutlet weak var citySearchTableView: UITableView!
        @IBOutlet weak var subtopicInputSearchView: UITableView!
        @IBOutlet weak var subtopicSearchView: UITableView!
        @IBOutlet weak var toolbarView: UIView!
        
        @IBOutlet var leadingConstraint: NSLayoutConstraint!
        @IBOutlet var upperConstraint: NSLayoutConstraint!
        @IBOutlet var upperConstraintSearchView: NSLayoutConstraint!
        @IBOutlet var upperConstraintCitySearchView: NSLayoutConstraint!
    
        var searchCityShowing = false
        var searchShowing = false
        var searchMenuShowing = false
        var enterThoughtShowing = false
        var userNameText: String!
    
        var thoughtList = [ThoughtModel]()//list to store all the thought
        var thoughtUIDList = [String!]()//stores all uids for posts
        var filteredThoughtList = [ThoughtModel]()//list meant to store the posts from a user chosen post
        var userList = [UserModel]()
        var alreadyLikedList = [NSDictionary]()
    
        var subtopicsArray = [NSDictionary?]()
        var filteredSubtopics = [NSDictionary?]()
        var filteredSelectedSubtopics = [NSDictionary?]()
    
        var topicsArray = [NSDictionary?]()//all in database
        var filteredTopics = [NSDictionary?]()//ones in search bar
        var filteredSelectedTopics = [NSDictionary?]()
    
        var cityArray = [NSDictionary?]()
        var filteredCities = [NSDictionary?]()//ones in search bar
        var filteredSelectedCities = [NSDictionary?]()
    
        var userNameTextHolder: String!
        //search
        var searchController: UISearchController!
        var topicInputSearchController: UISearchController!
        var citySearchController: UISearchController!
        var subtopicInputSearchController: UISearchController!
        var subtopicSearchController: UISearchController!
        //var selectedTopic: String!
        var selectedTopicThought: String!
        var selectedSubtopicThought: String!
        var selectedCity: String!
        var numOfPosts: Int!
        var mainTopicChosen: Bool!
    
        //location constants
        let locationManager = CLLocationManager()
        var location: CLLocation?
        let geocoder = CLGeocoder()
        var placemark: CLPlacemark?
        var city: String?
        var country: String?
        var region: String?
        var countryShortName: String?
    
        @IBOutlet weak var backToMainTopicBtn: UIButton!
    
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
            
            topicInputSearchController = UISearchController(searchResultsController: nil)
            topicInputSearchController.searchResultsUpdater = self
            topicInputSearchController.dimsBackgroundDuringPresentation = false
            topicInputSearchController.searchBar.delegate = self
            topicInputSearchView.tableHeaderView = topicInputSearchController.searchBar
            
            subtopicInputSearchController = UISearchController(searchResultsController: nil)
            subtopicInputSearchController.searchResultsUpdater = self
            subtopicInputSearchController.dimsBackgroundDuringPresentation = false
            subtopicInputSearchController.searchBar.delegate = self
            subtopicInputSearchView.tableHeaderView = subtopicInputSearchController.searchBar
            
            subtopicSearchController = UISearchController(searchResultsController: nil)
            subtopicSearchController.searchResultsUpdater = self
            subtopicSearchController.dimsBackgroundDuringPresentation = false
            subtopicSearchController.searchBar.delegate = self
            subtopicSearchView.tableHeaderView = subtopicSearchController.searchBar
        }
        func updateSearchResults(for searchController: UISearchController) {
            if searchController == self.searchController {
                filterContent(searchText: self.searchController.searchBar.text!)
            }else if searchController == self.topicInputSearchController{
                filterContent(searchText: self.topicInputSearchController.searchBar.text!)
            }else if searchController == self.citySearchController{
                filterContent(searchText: self.citySearchController.searchBar.text!)
            }else if searchController == self.subtopicInputSearchController{
                filterContent(searchText: self.subtopicInputSearchController.searchBar.text!)
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
            }else if topicInputSearchController.isActive && topicInputSearchController.searchBar.text != ""{
                self.filteredTopics = self.topicsArray.filter{topic in
                    let topic = topic!["TopicName"] as? String
                    return (topic?.lowercased().contains(searchText.lowercased()))!
                }
                topicInputSearchView.reloadData()
            }else if subtopicInputSearchController.isActive && subtopicInputSearchController.searchBar.text != ""{
                self.filteredSubtopics = self.subtopicsArray.filter{subtopic in
                    let subtopic = subtopic!["subtopicName"] as? String
                    return (subtopic?.lowercased().contains(searchText.lowercased()))!
                }
                subtopicInputSearchView.reloadData()
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
                topicInputSearchView.reloadData()
                subtopicInputSearchView.reloadData()
                citySearchTableView.reloadData()
            }
        }
    
        public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
            return 1
        }
    
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{

            if tableView == self.topicSearchView {
                if searchController.isActive && searchController.searchBar.text != ""{
                    return filteredTopics.count
                }
                return self.topicsArray.count
            }else if tableView == self.topicInputSearchView{
                if topicInputSearchController.isActive && topicInputSearchController.searchBar.text != ""{
                    return filteredTopics.count
                }
                return self.topicsArray.count
            }else if tableView == self.subtopicInputSearchView{
                if subtopicInputSearchController.isActive && subtopicInputSearchController.searchBar.text != ""{
                    return filteredSubtopics.count
                }
                return self.subtopicsArray.count
            }else if tableView == self.subtopicSearchView{
                if subtopicSearchController.isActive && subtopicSearchController.searchBar.text != ""{
                    return filteredSubtopics.count
                }
                return self.subtopicsArray.count
            }else if tableView == self.citySearchTableView{
                if citySearchController.isActive && citySearchController.searchBar.text != ""{
                    return filteredCities.count
                }
                return self.cityArray.count
            }
            return thoughtList.count
        }
        public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
            if tableView == self.topicSearchView {
                let currentCell = tableView.cellForRow(at: indexPath!) as! UITableViewCell
                selectedTopicThought = currentCell.textLabel!.text
                subtopicsArray.removeAll()
                subtopicSearchView.reloadData()
                loadSubTopics(MainTopic: selectedTopicThought, table: self.subtopicSearchView)
                self.searchController.isActive = false///
                self.topicSearchView.isHidden = true
                self.subtopicSearchView.isHidden = false
                toolbarView.isHidden = false;
            }else if tableView == self.subtopicSearchView{
                let currentCell = tableView.cellForRow(at: indexPath!) as! UITableViewCell
                mainInstance.selectedTopic = currentCell.textLabel!.text!
                toolbarView.isHidden = false;
                self.subtopicSearchController.isActive = false//
                performSegue(withIdentifier: "SwitchSpecificFeedVC", sender: nil)
            }else if tableView == self.topicInputSearchView{
                let currentCell = tableView.cellForRow(at: indexPath!) as! UITableViewCell
                backToMainTopicBtn.isHidden = false
                toolbarView.isHidden = false;
                selectedTopicThought = currentCell.textLabel!.text
                self.topicInputSearchController.isActive = false//
                subtopicsArray.removeAll()
                subtopicInputSearchView.reloadData()
                loadSubTopics(MainTopic: selectedTopicThought, table: self.subtopicInputSearchView)
                self.subtopicInputSearchView.isHidden = false
                self.topicInputSearchView.isHidden = true
            }else if tableView == self.subtopicInputSearchView{
                let currentCell = tableView.cellForRow(at: indexPath!) as! UITableViewCell
                selectedSubtopicThought = currentCell.textLabel!.text
                self.subtopicInputSearchController.isActive = false//
                topicSelectedMessage.text = selectedSubtopicThought as! String
            }else if tableView == self.citySearchTableView{
                let currentCell = tableView.cellForRow(at: indexPath!) as! UITableViewCell
                mainInstance.selectedCity = currentCell.textLabel!.text!
                self.citySearchController.isActive = false//
                //self.navigationController?.isToolbarHidden = false
                toolbarView.isHidden = false;
                performSegue(withIdentifier:"SwitchSpecificCityFeedVC", sender: nil)
            }else{
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
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SpecificThoughtVC") as! SpecificThoughtVC
                self.navigationController?.pushViewController(nextViewController, animated: true)
                //performSegue(withIdentifier:"SpecificPost", sender: nil)
            }
        }
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            if tableView == self.topicSearchView {

                let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! UITableViewCell
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
            }else if tableView == self.topicInputSearchView{
                let cell = tableView.dequeueReusableCell(withIdentifier: "selectedTopicCell", for: indexPath) as! UITableViewCell
                let topic: NSDictionary?
                if topicInputSearchController.isActive && topicInputSearchController.searchBar.text != ""{
                    topic = filteredTopics[indexPath.row]
                }else{
                    topic = self.topicsArray[indexPath.row]
                }
                cell.textLabel?.text = topic?["TopicName"] as? String
                //returning cell
                return cell
            }else if tableView == self.subtopicInputSearchView{
                let cell = tableView.dequeueReusableCell(withIdentifier: "selectedSubtopicCell", for: indexPath) as! UITableViewCell
                let subtopic: NSDictionary?
                //backToMainTopicBtn.isEnabled = true
                //backToMainTopicBtn.title = "Back To Main Topics"
                backToMainTopicBtn.isHidden = false
                if subtopicInputSearchController.isActive && subtopicInputSearchController.searchBar.text != ""{
                    subtopic = filteredSubtopics[indexPath.row]
                }else{
                    subtopic = self.subtopicsArray[indexPath.row]
                }
                cell.textLabel?.text = subtopic?["subtopicName"] as? String
                //cell.detailTextLabel?.text = topic?["NumOfPosts"] as? String //use to show how many posts are in the topic
                return cell
            }else if tableView == self.subtopicSearchView{
                let cell = tableView.dequeueReusableCell(withIdentifier: "subtopicSearchCell", for: indexPath) as! UITableViewCell
                let subtopic: NSDictionary?
                //backToMainTopicBtn.isEnabled = true
                //backToMainTopicBtn.title = "Back To Main Topics"
                backToMainTopicBtn.isHidden = false
                if subtopicSearchController.isActive && subtopicSearchController.searchBar.text != ""{//subtopicINputSearchController
                    subtopic = filteredSubtopics[indexPath.row]
                }else{
                    subtopic = self.subtopicsArray[indexPath.row]
                }
                cell.textLabel?.text = subtopic?["subtopicName"] as? String
                //cell.detailTextLabel?.text = topic?["NumOfPosts"] as? String //use to show how many posts are in the topic
                return cell
            }else if tableView == self.citySearchTableView{
                let cell = tableView.dequeueReusableCell(withIdentifier: "selectedCityCell", for: indexPath) as! UITableViewCell
                let city: NSDictionary?
                
                if citySearchController.isActive && citySearchController.searchBar.text != ""{
                    city = filteredCities[indexPath.row]
                }else{
                    city = cityArray[indexPath.row]
                }
                cell.textLabel?.text = city?["cityName"] as? String
                //returning cell
                return cell
            }else{
                var alreadyLikedBool: Bool!
                refUsers = Database.database().reference()
                //creating a cell using the custom class
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VCTableViewCell
                //the thought object
                let thought: ThoughtModel
                //getting the thought of selected position
                thought = thoughtList[indexPath.row]
                cell.configCell(thought: thought)
                let numToString = (thought._likes).toString()
                
                //adding values to labels
                //cell.thoughtLbl.text = thought.typedThought
                cell.topicLbl.text = thought.typedTopic
                cell.userLbl.text = thought.userName
                cell.timeStampLbl.text = thought.timeStamp
                cell.locationLbl.text = thought.city! + ", " + thought.country!
                cell.numOfLikes.text = numToString
                
                cell.topicLbl.sizeToFit()
                cell.topicLbl.numberOfLines = 1;
                cell.userLbl.sizeToFit()
                cell.timeStampLbl.sizeToFit()
                cell.locationLbl.sizeToFit()
                cell.locationLbl.numberOfLines = 1;
                cell.numOfLikes.sizeToFit()
                
                Database.database().reference().child("users").child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { snapshot in
                        guard let dict = snapshot.value as? [String:Any] else {
                            print("Error")
                            return
                        }
                       /* let tempUid = "\(thought.uid!)"
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
        }
        func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool{
            return false
        }
        @IBAction func openSearchMenu(_ sender: Any){
            if searchMenuShowing {
                leadingConstraint.constant = 800//-140
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            }else{
                leadingConstraint.constant = 270//0
                
                UIView.animate(withDuration: 0.3, animations: {
                        self.view.layoutIfNeeded()
                    })
            }
            searchMenuShowing = !searchMenuShowing
        }
        @IBAction func openEnterThought(_ sender: Any){
            selectedTopicThought = ""
            selectedSubtopicThought = ""
            topicSelectedMessage.text = ""
            thoughtInput.text = ""
            subtopicInputSearchView.isHidden = true
            topicInputSearchView.isHidden = false
            if enterThoughtShowing {
               
                toolbarView.isHidden = false;
                backToMainTopicBtn.isHidden = true
                upperConstraint.constant = 0
                subtopicInputSearchController.isActive = false
                topicInputSearchController.isActive = false
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
                if leadingConstraint.constant == 270{//0{
                    leadingConstraint.constant = 800//-140
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.layoutIfNeeded()
                    })
                    searchMenuShowing = !searchMenuShowing
                }
                if upperConstraintSearchView.constant == 0{
                    upperConstraintSearchView.constant = 1500
                    UIView.animate(withDuration: 0.5, animations: {
                        self.view.layoutIfNeeded()
                    })
                    searchShowing = !searchShowing
                }
                if upperConstraintCitySearchView.constant == 0 {
                    upperConstraintCitySearchView.constant = 1500
                    UIView.animate(withDuration: 0.5, animations: {
                        self.view.layoutIfNeeded()
                    })
                    searchCityShowing = !searchCityShowing
                }
            }else{
                //self.navigationController?.isToolbarHidden = true
                //backToMainTopicBtn.isEnabled = false
                //backToMainTopicBtn.title = ""
                backToMainTopicBtn.isHidden = true
                toolbarView.isHidden = true
                upperConstraint.constant = 1500
                
                UIView.animate(withDuration: 0.5, animations: {
                   self.view.layoutIfNeeded()
                })
            }

            enterThoughtShowing = !enterThoughtShowing
        }
        @IBAction func openSearchBar(_ sender: Any){
            self.topicSearchView.isHidden = false
            self.subtopicSearchView.isHidden = true
            //backToMainTopicBtn.isEnabled = false
            //backToMainTopicBtn.title = ""
            backToMainTopicBtn.isHidden = true
            if searchShowing {
                //toolbarView.isHidden = true
                searchController.isActive = false
                subtopicSearchController.isActive = false
                upperConstraintSearchView.constant = 0
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
                if leadingConstraint.constant == 270{//0{
                    leadingConstraint.constant = 800//-140
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.layoutIfNeeded()
                    })
                    searchMenuShowing = !searchMenuShowing
                }
                if upperConstraint.constant == 0{
                    upperConstraint.constant = 1500
                    UIView.animate(withDuration: 0.5, animations: {
                        self.view.layoutIfNeeded()
                    })
                    enterThoughtShowing = !enterThoughtShowing
                }
                if upperConstraintCitySearchView.constant == 0 {
                    upperConstraintCitySearchView.constant = 1500
                    UIView.animate(withDuration: 0.5, animations: {
                        self.view.layoutIfNeeded()
                    })
                    searchCityShowing = !searchCityShowing
                }
            }else{
               //self.navigationController?.isToolbarHidden = false
                toolbarView.isHidden = false
                upperConstraintSearchView.constant = 1500
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
            }
            /*if self.navigationController?.isToolbarHidden == true{
                self.navigationController?.isToolbarHidden = false
            }else{
                self.navigationController?.isToolbarHidden = true
            }*/
            if toolbarView.isHidden == true {
                toolbarView.isHidden = false
            }else{
                toolbarView.isHidden = true
            }

            searchShowing = !searchShowing
        }
        @IBAction func openCitySearchBar(_ sender: Any){
            if searchCityShowing {
                citySearchController.isActive = false
                //self.navigationController?.isToolbarHidden = true
                toolbarView.isHidden = true
                upperConstraintCitySearchView.constant = 0
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
                if leadingConstraint.constant == 270{//0{
                    leadingConstraint.constant = 800//-140
                    UIView.animate(withDuration: 0.3, animations: {
                        self.view.layoutIfNeeded()
                    })
                    searchMenuShowing = !searchMenuShowing
                }
                if upperConstraint.constant == 0{
                    upperConstraint.constant = 1500
                    UIView.animate(withDuration: 0.5, animations: {
                        self.view.layoutIfNeeded()
                    })
                    enterThoughtShowing = !enterThoughtShowing
                }
                if upperConstraintSearchView.constant == 0{
                    upperConstraintSearchView.constant = 1500
                    UIView.animate(withDuration: 0.5, animations: {
                        self.view.layoutIfNeeded()
                    })
                    searchShowing = !searchShowing
                }
            }else{
                //backToMainTopicBtn.isEnabled = false
                //backToMainTopicBtn.title = ""
                backToMainTopicBtn.isHidden = true
                toolbarView.isHidden = false
                //self.navigationController?.isToolbarHidden = false
                upperConstraintCitySearchView.constant = 1500
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
            }
            /*if self.navigationController?.isToolbarHidden == true{
             self.navigationController?.isToolbarHidden = false
             }else{
             self.navigationController?.isToolbarHidden = true
             }*/
            if toolbarView.isHidden == true {
                toolbarView.isHidden = false
            }else{
                toolbarView.isHidden = true
            }
            
            searchCityShowing = !searchCityShowing
        }
        @IBAction func buttonAddThought(_ sender: UIButton) {
            if selectedTopicThought == "" {
                let alertController = UIAlertController(title: "Error", message: "Please Select a Topic", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }else if !CLLocationManager.locationServicesEnabled() {
                showLocationDisabledPopUp()
            }else if selectedSubtopicThought == nil{
                let alertController = UIAlertController(title: "Error", message: "Please Select a SubTopic", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            }else{
                addThought()
            }
        }
        @IBAction func buttonBackToFeed(_ sender: UIButton){
            searchController.isActive = false
            subtopicSearchController.isActive = false
            citySearchController.isActive = false
            topicInputSearchController.isActive = false
            subtopicInputSearchController.isActive = false
            leadingConstraint.constant = 800//-140
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            searchMenuShowing = !searchMenuShowing
            upperConstraint.constant = 1500
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            enterThoughtShowing = !enterThoughtShowing
            
            upperConstraintCitySearchView.constant = 1500
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            searchCityShowing = !searchCityShowing
            
            upperConstraintSearchView.constant = 1500
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            searchShowing = !searchShowing
            //self.navigationController?.isToolbarHidden = true
            toolbarView.isHidden = true
    }
    @IBAction func backToMainTopics(_ sender: UIButton){
            searchController.isActive = false
            subtopicSearchController.isActive = false
            topicInputSearchController.isActive = false
            subtopicInputSearchController.isActive = false
            
            if topicSearchView.isHidden == true{
                topicSearchView.isHidden = false
                subtopicSearchView.isHidden = true
            }
            if topicInputSearchView.isHidden == true{
                topicInputSearchView.isHidden = false
                subtopicInputSearchView.isHidden = true
            }
            selectedTopicThought = ""
            selectedSubtopicThought = ""
            topicSelectedMessage.text = ""
            //backToMainTopicBtn.isEnabled = false
            //backToMainTopicBtn.title = ""
            backToMainTopicBtn.isHidden = true
    }
    
        //location functions
        func startLocationManager() {
            // always good habit to check if locationServicesEnabled
            if CLLocationManager.locationServicesEnabled() {
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.startUpdatingLocation()
            }
        }
        func stopLocationManager() {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
        }
        func showLocationDisabledPopUp() {
            let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                    message: "You cannot post a thought without location",
                                                    preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
                if let url = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            alertController.addAction(openAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            // print the error to see what went wrong
            print("didFailwithError\(error)")
            // stop location manager if failed
            stopLocationManager()
        }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            // if you need to get latest data you can get locations.last to check it if the device has been moved
            let latestLocation = locations.last!
            
            // here check if no need to continue just return still in the same place
            if latestLocation.horizontalAccuracy < 0 {
                return
            }
            // if it location is nil or it has been moved
            if location == nil || location!.horizontalAccuracy > latestLocation.horizontalAccuracy {//lastLocation
                
                location = latestLocation //lastLocation
                // stop location manager
                stopLocationManager()
                
                // Here is the place you want to start reverseGeocoding
                geocoder.reverseGeocodeLocation(latestLocation, completionHandler: { (placemarks, error) in //lastLocation
                    // always good to check if no error
                    // also we have to unwrap the placemark because it's optional
                    if error == nil, let placemark = placemarks, !placemark.isEmpty {
                        self.placemark = placemark.last
                    }
                })
            }
        }
        func parsePlacemarksCity() -> String {
            // here we check if location manager is not nil using a _ wild card
            if let _ = location {
                // unwrap the placemark
                if let placemark = placemark {
                    // locality means city
                    if let city = placemark.locality, !city.isEmpty {
                        self.city = city
                        print(city)
                        let ref = Database.database().reference()
                        
                        ref.child("Cities").queryOrdered(byChild: "cityName").queryEqual(toValue: city).observeSingleEvent(of: .value, with: { snapshot in
                            if !snapshot.exists(){                        //do stuff with unique username
                                print("city doesn't exist")
                                let key = self.refLocation.childByAutoId().key
                                let saveCity = ["cityName":city]
                                self.refLocation.child(key).setValue(saveCity)
                            }else{
                                print("city exists")
                            }
                        })
                    }
                }
            } else {
                return "unknown"
            }
            print(city!)
            return city!
        }
        func parsePlacemarksState() -> String {
            // here we check if location manager is not nil using a _ wild card
            if let _ = location {
                // unwrap the placemark
                if let placemark = placemark {
                    if let region = placemark.locality, !region.isEmpty {
                        self.region = region
                        print(region)
                    }
                }
            } else {
                return "unknown"
            }
            print(region!)
            return region!
        }
        func parsePlacemarksCountry() -> String {
            if let _ = location {
                // unwrap the placemark
                if let placemark = placemark {
                    // locality means city
                    if let country = placemark.country, !country.isEmpty {
                        self.country = country
                        print(country)
                    }
                }
            } else {
                return "unknown"
            }
            return country!
        }
    @objc func handleSwipes(sender: UISwipeGestureRecognizer){
            if (sender.direction == .left){
                
            }
            if (sender.direction == .right){
                
            }
            if (sender.direction == .up){
                leadingConstraint.constant = 270//0
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
                searchMenuShowing = true
            }
            if (sender.direction == .down){
                leadingConstraint.constant = 800//-140
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
                searchMenuShowing = false
            }
        }
        override func viewDidLoad() {
            super.viewDidLoad()
            self.hideKeyboardWhenTappedAround()
            self.thoughtInput.delegate = self
            
            var image = UIImage(named: "searchMenu.png")
            image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: self, action: #selector(openSearchMenu(_:)))
            
            menuBtn.layer.cornerRadius = 5;
            menuBtn.layer.borderWidth = 4;
            menuBtn.layer.borderColor = UIColor.red.cgColor
            
            profileBtn.layer.cornerRadius = 5;
            profileBtn.layer.borderWidth = 4;
            profileBtn.layer.borderColor = UIColor.red.cgColor
            
            diaryBtn.layer.cornerRadius = 5;
            diaryBtn.layer.borderWidth = 4;
            diaryBtn.layer.borderColor = UIColor.red.cgColor
            
            locationBtn.layer.cornerRadius = 5;
            locationBtn.layer.borderWidth = 4;
            locationBtn.layer.borderColor = UIColor.red.cgColor

            //var leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(sender:)))//Selector("handleSwipes:"))
            //var rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(sender:)))//Selector("handleSwipes:"))
            var upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(sender:)))
            var downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes(sender:)))

            //leftSwipe.direction = .left
            //rightSwipe.direction = .right
            upSwipe.direction = .up
            downSwipe.direction = .down
            
            //view.addGestureRecognizer(leftSwipe)
            //view.addGestureRecognizer(rightSwipe)
            view.addGestureRecognizer(upSwipe)
            view.addGestureRecognizer(downSwipe)
            mainBar.isHidden = false
            backToMainTopicBtn.isHidden = true

            upperConstraint.constant = 1500
            enterThoughtShowing = true
            
            upperConstraintCitySearchView.constant = 1500
            searchCityShowing = true
            
            upperConstraintSearchView.constant = 1500
            searchShowing = true
            
            leadingConstraint.constant = 800
            searchMenuShowing = false
            
            toolbarView.isHidden = true
            
            configureSearchController()
            let authStatus = CLLocationManager.authorizationStatus()
            if authStatus == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            }
            
            if authStatus == .denied || authStatus == .restricted {
                showLocationDisabledPopUp()
            }
            startLocationManager()

            searchMenuView.layer.opacity = 1.0
            searchMenuView.layer.shadowRadius = 6
            
            // Input data into the Array:
            refThoughts = Database.database().reference().child("thoughts");
            refUsers = Database.database().reference()
            refLocation = refLocation.child("Cities")
            refMainTopics = Database.database().reference().child("MainTopic")
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
                        self.thoughtList.insert(thought, at: 0)
                    }
                    
                    //reloading the tableview
                    self.tableView.reloadData()
                }
            })
            loadMainTopics()
            loadCities()
            createUsersUsername()
        }
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.view.endEditing(true)
            return false
        }
        func createUsersUsername(){
            if Auth.auth().currentUser?.uid == nil{
                do {
                    try Auth.auth().signOut()
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginPage")
                    present(vc, animated: true, completion: nil)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            if let uid = Auth.auth().currentUser?.uid{
                refUsers.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dict = snapshot.value as? [String: AnyObject]
                    {
                        self.userNameText = dict["username"] as? String
                        self.userNameTextHolder =  Auth.auth().currentUser?.displayName
                        self.userNameTextHolder = self.userNameText
                        mainInstance.currentUsername = self.userNameText
                        
                    }
                })
            }
        }
        func loadMainTopics(){
            topicRef.child("MainTopics").queryOrdered(byChild:"TopicName").observe(.childAdded, with: {(snapshot) in
                
                self.topicsArray.append(snapshot.value as? NSDictionary)
                    
                //insert the rows
                self.topicSearchView.insertRows(at: [IndexPath(row:self.topicsArray.count - 1,section: 0)], with: UITableViewRowAnimation.automatic)
                self.topicInputSearchView.insertRows(at:[IndexPath(row:self.topicsArray.count - 1,section: 0)], with: UITableViewRowAnimation.automatic)
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
            refLocation.queryOrdered(byChild:"cityName").observe(.childAdded, with: {(snapshot) in
                
                self.cityArray.append(snapshot.value as? NSDictionary)
                
                //insert the rows
                self.citySearchTableView.insertRows(at: [IndexPath(row:self.cityArray.count - 1,section: 0)], with: UITableViewRowAnimation.automatic)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        func getTimeStamp() -> String!{
            var time: String!
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return "\(formatter.string(from: date))"
            //let calendar = Calendar.current
        }
        func addThought(){
            //generating a new key inside thought node
            //and also getting the generated key
            let key = refThoughts.childByAutoId().key
            
            //12/25/17, 8:44 PM
            //creating thought with the given values
            let thought = ["id":key,
                          "thought": thoughtInput.text! as String,//thoughtText
                          "topic": selectedSubtopicThought,
                          "users": self.userNameText as String,
                          "time": getTimeStamp(),
                          "city": parsePlacemarksCity(),
                          "country": parsePlacemarksCountry(),
                          "likes": 0
                ] as [String : Any]
            //adding the thought inside the generated unique key
            refThoughts.child(key).setValue(thought)
            
            upperConstraint.constant = 1500
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            enterThoughtShowing = !enterThoughtShowing
            toolbarView.isHidden = true
    }
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
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
}
