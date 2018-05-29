//
//  TopicChooseVC.swift
//  JustAThought
//
//  Created by Grumpy1211 on 12/22/17.
//  Copyright © 2017 MuSquared. All rights reserved.
//

import UIKit
import  Firebase
import  FirebaseDatabase
import  FirebaseAuth

class TopicCreateVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var topicInput: UITextField!
    @IBOutlet weak var successMessage: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    
    var refTopics: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        successMessage.isHidden = true
        self.hideKeyboardWhenTappedAround()
        self.topicInput.delegate = self
        submitBtn.isHidden = false
        
        submitBtn.layer.shadowColor = UIColor.black.cgColor
        submitBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        submitBtn.layer.masksToBounds = false
        submitBtn.layer.shadowRadius = 1.0
        submitBtn.layer.shadowOpacity = 0.5
        submitBtn.layer.cornerRadius = 7
        submitBtn.showsTouchWhenHighlighted = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func addTopic(){
        refTopics = Database.database().reference().child("RequestedTopics")

        let key = refTopics.childByAutoId().key
        
        //topicName: String?, username: String?, userEmail: String?
        //creating thought with the given values
        let requestedTopic = ["RequestedTopic": topicInput.text! as String,
                              "userEmail": Auth.auth().currentUser!.email as! String
        ]
        
        //adding the thought inside the generated unique key
        refTopics.child(key).setValue(requestedTopic)
        successMessage.isHidden = false
        submitBtn.isHidden = true
        successMessage.text = "Topic Succesfully Sent"
        /*if Error.self == nil {
            successMessage.isHidden = false
            submitBtn.isHidden = true
            successMessage.text = "Topic Succesfully Requested"
        }else{
            successMessage.isHidden = false
            successMessage.text = "Error"
        }*/
    }
    @IBAction func buttonAddTopic(_ sender: UIButton) {
        addTopic()
    }
    func setNavigationBar() {
        self.navigationItem.title = "Request Topic"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "Menlo", size: 21)!]
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Menlo", size: 20)!], for: [])//UIControlState.Normal)
        navigationItem.backBarButtonItem = backButton
    }

}
