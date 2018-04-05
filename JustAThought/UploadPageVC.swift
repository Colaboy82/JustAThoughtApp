//
//  UploadPageViewController.swift
//  JustAThought
//
//  Created by Grumpy1211 on 12/21/17.
//  Copyright © 2017 MuSquared. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class UploadPageVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var wordInput: UITextField!
    @IBOutlet weak var topicPicker: UIPickerView!
    @IBOutlet weak var successMessage: UILabel!
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Connect data:
        topicPicker.delegate = self
        topicPicker.dataSource = self
        
        // Input data into the Array:
        pickerData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6"]
    }

    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func addThought (){
        //generating a new key inside posts node
        //and also getting the generated key
        let key = Database.database().reference().child("posts").childByAutoId().key
        
        //creating new post with the given thought
        let post = ["id":key,
                      "thought": wordInput.text! as String,
        ]
        
        //adding the thought inside the generated unique key
        Database.database().reference().child("posts").child(key).setValue(post)
        
        //displaying message
        successMessage.text = "Thought Posted"
    }
    
    @IBAction func enterThought(_ sender: UIButton){
        addThought()
    }
}
