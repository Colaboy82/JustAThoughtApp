//
//  LoginVC.swift
//  JustAThought
//
//  Created by Grumpy1211 on 12/22/17.
//  Copyright © 2017 MuSquared. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
class LoginVC: UIViewController, UITextFieldDelegate {
    
    //Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var pwdBtn: UIButton!
    @IBOutlet weak var createAcctBtn: UIButton!
    
    var refUsers: DatabaseReference!
    
    let service = "Just A Thought"
    
    override func viewDidAppear(_ animated: Bool){
        //keychainService code
        let keyChain = DataService().keyChain
        if keyChain.get("uid") != nil {//if user existss automatically sign in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Feed")
            self.present(vc!, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        mainInstance.profile = false
        
        loginBtn.layer.shadowColor = UIColor.black.cgColor
        loginBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        loginBtn.layer.masksToBounds = false
        loginBtn.layer.shadowRadius = 1.0
        loginBtn.layer.shadowOpacity = 0.5
        loginBtn.layer.cornerRadius = 7
        loginBtn.showsTouchWhenHighlighted = true
        
        pwdBtn.layer.shadowColor = UIColor.black.cgColor
        pwdBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        pwdBtn.layer.masksToBounds = false
        pwdBtn.layer.shadowRadius = 1.0
        pwdBtn.layer.shadowOpacity = 0.5
        pwdBtn.layer.cornerRadius = 7
        pwdBtn.showsTouchWhenHighlighted = true
        
        createAcctBtn.layer.shadowColor = UIColor.black.cgColor
        createAcctBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        createAcctBtn.layer.masksToBounds = false
        createAcctBtn.layer.shadowRadius = 1.0
        createAcctBtn.layer.shadowOpacity = 0.5
        createAcctBtn.layer.cornerRadius = 7
        createAcctBtn.showsTouchWhenHighlighted = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func completeSignIn(id: String){
        let keyChain = DataService().keyChain
        keyChain.set(id, forKey: "uid")
    }
    //Login Action
    @IBAction func loginAction(_ sender: AnyObject) {
        
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                if error == nil {
                    self.completeSignIn(id: user!.uid)
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    //Go to the HomeViewController if the login is sucessful
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Feed")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Wrong Information", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
