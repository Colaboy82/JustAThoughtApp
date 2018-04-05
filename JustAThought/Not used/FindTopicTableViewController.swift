//
//  FindTopicTableViewController.swift
//  JustAThought
//
//  Created by Grumpy1211 on 12/25/17.
//  Copyright © 2017 MuSquared. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FindTopicTableViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var topicsTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var topicsArray = [NSDictionary?]()//all in database
    var filteredTopics = [NSDictionary?]()//ones in search bar
    
    var topicRef = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        topicRef.child("MainTopics").queryOrdered(byChild: "TopicName").observe(.childAdded, with: {(snapshot) in
            
            self.topicsArray.append(snapshot.value as? NSDictionary)
            
            //insert the rows
            self.topicsTableView.insertRows(at: [IndexPath(row:self.topicsArray.count - 1,section: 0)], with: UITableViewRowAnimation.automatic)

        }) { (error) in
            print(error.localizedDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if searchController.isActive && searchController.searchBar.text != ""{
            return filteredTopics.count
        }
        return self.topicsArray.count
    }
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(searchText: self.searchController.searchBar.text!)
    }
    func filterContent(searchText: String){
        self.filteredTopics = self.topicsArray.filter{topic in
            let topic = topic!["TopicName"] as? String
            return (topic?.lowercased().contains(searchText.lowercased()))!
        }
        tableView.reloadData()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        let topic: NSDictionary?
        if searchController.isActive && searchController.searchBar.text != ""{
            topic = filteredTopics[indexPath.row]
        }else{
            topic = self.topicsArray[indexPath.row]
        }
        
        cell.textLabel?.text = topic?["TopicName"] as? String
        //cell.detailTextLabel?.text = topic?["handle"] as? String //use to show how many posts are in the topic
        
        return cell

    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
