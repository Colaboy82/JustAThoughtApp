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
import KeychainSwift

extension String {
    
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }
    
    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else {
            return nil
        }
        return self[indexPosition]
    }
}
class UserProfileVC: UIViewController {

    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    @IBOutlet weak var signOutB: UIButton!
    @IBOutlet weak var resetB: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //usernameLbl.adjustsFontSizeToFitWidth = true
        //emailLbl.adjustsFontSizeToFitWidth = true
        setNavigationBar()
        usernameLbl.text = "Username: " + setUpShortUserName()//mainInstance.currentUsername
        emailLbl.text = "Email: " + (Auth.auth().currentUser?.email)!
        usernameLbl.adjustsFontSizeToFitWidth = true
        emailLbl.adjustsFontSizeToFitWidth = true
        
        signOutB.layer.shadowColor = UIColor.black.cgColor
        signOutB.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        signOutB.layer.masksToBounds = false
        signOutB.layer.shadowRadius = 1.0
        signOutB.layer.shadowOpacity = 0.5
        signOutB.layer.cornerRadius = 7
        signOutB.showsTouchWhenHighlighted = true
        
        resetB.layer.shadowColor = UIColor.black.cgColor
        resetB.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        resetB.layer.masksToBounds = false
        resetB.layer.shadowRadius = 1.0
        resetB.layer.shadowOpacity = 0.5
        resetB.layer.cornerRadius = 7
        resetB.showsTouchWhenHighlighted = true
    }
    @IBAction func movetoResetV(sender: AnyObject){
        mainInstance.profile = true
    }
    
    @IBAction func logOutAction(sender: AnyObject) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                KeychainSwift().delete("uid")
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginPage")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    func setNavigationBar() {
        self.navigationItem.title = "User Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "Menlo", size: 21)!]
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: nil)
        backButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: "Menlo", size: 20)!], for: [])//UIControlState.Normal)
        navigationItem.backBarButtonItem = backButton
    }
    func setUpShortUserName() -> String{
        let result = String(mainInstance.currentUsername.characters.prefix(10))
        return result
    }
}
