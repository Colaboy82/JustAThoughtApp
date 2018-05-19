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
    }

}
