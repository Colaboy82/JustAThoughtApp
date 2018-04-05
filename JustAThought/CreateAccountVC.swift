//
//  UserVCViewController.swift
//  JustAThought
//
//  Created by Grumpy1211 on 12/22/17.
//  Copyright © 2017 MuSquared. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class CreateAccountVC: UIViewController, UITextFieldDelegate {

    let databaseRef = Database.database().reference(fromURL: "https://just-a-thought-76ed7.firebaseio.com/")
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var middleNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.usernameTextField.delegate = self
        self.firstNameTextField.delegate = self
        self.middleNameTextField.delegate = self
        self.lastNameTextField.delegate = self
    }
    func containsSwearWord(text: String, swearWords: [String]) -> Bool {
        return swearWords
            .reduce(false) { $0 || text.contains($1.lowercased()) }
    }
    func textField(_ textFieldToChange: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let characterSetNotAllowed = CharacterSet.punctuationCharacters
        let spaces = CharacterSet.whitespaces
        let symbols = CharacterSet.symbols
        let curseWords = ["fuck", "Fuck", "shit", "Shit", "Dick", "dick", "Bitch", "bitch", "Whore", "whore", "dyke", "Dyke"]

        if let _ = string.rangeOfCharacter(from: characterSetNotAllowed, options: .caseInsensitive){
            if textFieldToChange != emailTextField{
                return false
            }else{
                return true
            }
        }else if let _ = string.rangeOfCharacter(from: spaces, options: .caseInsensitive) {
            return false
        }else if let _ = string.rangeOfCharacter(from: symbols, options: .caseInsensitive) {
            return false
        }else {
            return true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
   
    @IBAction func createAccountAction(_ sender: AnyObject) {
        
        if emailTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else if passwordTextField.text == ""{
            let alertController = UIAlertController(title: "Error", message: "Please enter your password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        } else if usernameTextField.text == ""{
            let alertController = UIAlertController(title: "Error", message: "Please enter your username", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        } else if firstNameTextField.text == "" || lastNameTextField.text == ""{
            let alertController = UIAlertController(title: "Error", message: "Please enter your name", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }else {
            let ref = Database.database().reference()
        
            ref.child("users").queryOrdered(byChild: "username").queryEqual(toValue: usernameTextField.text).observeSingleEvent(of: .value, with: { snapshot in
                if !snapshot.exists() && ((self.usernameTextField.text?.count)! < 15){                        //do stuff with unique username
                        print("username doesn't exist")
                        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                            if error == nil {
                                print("You have successfully signed up")
                                
                                guard let uid = user?.uid else{
                                    return
                                }
                                let userRef = self.databaseRef.child("users").child(uid)
                                let values = ["username": self.usernameTextField.text,
                                              "email": self.emailTextField.text,
                                              "firstName": self.firstNameTextField.text,
                                              "middleName": self.middleNameTextField.text,
                                              "lastName": self.lastNameTextField.text]
                                userRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                                    if error != nil{
                                        print(error!)
                                        return
                                    }
                                })
                                
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Feed")
                                self.present(vc!, animated: true, completion: nil)
                                
                            } else {
                                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                                
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertController.addAction(defaultAction)
                                
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    }else if !snapshot.exists() && ((self.usernameTextField.text?.count)! > 15){
                        print("username exists")
                        let alertController = UIAlertController(title: "Error", message: "Username must be 15 or less characters. Choose a shorter one.", preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }else{
                        print("username exists")
                        let alertController = UIAlertController(title: "Error", message: "That username is taken already. Choose a new one.", preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
        
                }
            })
        }
    }/*else{//not unique username
                        print("username exists")
                        let alertController = UIAlertController(title: "Error", message: "That username is taken already. Choose a new one.", preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    
                    }) {error in
                        print(error.localizedDescription)
                    }
            
            
            Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChild("username"){
                    
                    print("username exists")
                    let alertController = UIAlertController(title: "Error", message: "That username is taken already. Choose a new one.", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }else{
                    
                    print("username doesn't exist")
                    Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                        if error == nil {
                            print("You have successfully signed up")
                            
                            guard let uid = user?.uid else{
                                return
                            }
                            let userRef = self.databaseRef.child("users").child(uid)
                            let values = ["username": self.usernameTextField.text, "email": self.emailTextField.text]
                            userRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                                if error != nil{
                                    print(error!)
                                    return
                                }
                            })
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Feed")
                            self.present(vc!, animated: true, completion: nil)
                            
                        } else {
                            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                            
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
                
                
            })*/
    
    //}

}
