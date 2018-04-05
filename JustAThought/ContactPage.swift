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

class ContactPage: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var messageInput: UITextField!
    @IBOutlet weak var successMessage: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    
    var refTopics: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        successMessage.isHidden = true
        self.hideKeyboardWhenTappedAround()
        self.messageInput.delegate = self
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
    func sendMsg(){
        refTopics = Database.database().reference().child("MsgToUs")
        
        let key = refTopics.childByAutoId().key
        
        //topicName: String?, username: String?, userEmail: String?
        //creating thought with the given values
        let msgToMe = ["Msg": messageInput.text! as String,
                       "userEmail": Auth.auth().currentUser!.email as! String
        ]
        
        //adding the thought inside the generated unique key
        refTopics.child(key).setValue(msgToMe)
        successMessage.isHidden = false
        submitBtn.isHidden = true
        successMessage.text = "Message Succesfully Sent"
        /*if Error.self == nil {
            successMessage.isHidden = false
            submitBtn.isHidden = true
            successMessage.text = "Message Succesfully Sent"
        }else{
            successMessage.isHidden = false
            successMessage.text = "Error"
        }*/
    }
    @IBAction func sendMsgBtn(_ sender: UIButton) {
        sendMsg()
    }
    
    
}

