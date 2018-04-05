//
//  UserInfoVC.swift
//  JustAThought
//
//  Created by Grumpy1211 on 1/11/18.
//  Copyright © 2018 MuSquared. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class UserProfileVC: UIViewController {

    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLbl.text = "Username: " + mainInstance.currentUsername
        emailLbl.text = "Email: " + (Auth.auth().currentUser?.email)!
        usernameLbl.sizeToFit();
        emailLbl.sizeToFit();
    }
    @IBAction func movetoResetV(sender: AnyObject){
        mainInstance.profile = true
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
