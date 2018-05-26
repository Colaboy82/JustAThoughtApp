//
//  ResetPasswordVC.swift
//  JustAThought
//
//  Created by Grumpy1211 on 12/22/17.
//  Copyright © 2017 MuSquared. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class ResetPasswordVC: UIViewController, UITextFieldDelegate {
    // Outlets
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var ToolbarView: UIView!
    @IBOutlet weak var BacktoFeed: UIButton!
    @IBOutlet weak var BackToProf: UIButton!
    
    @IBOutlet weak var backB: UIButton!
    @IBOutlet weak var resetB: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setToolbar()
        self.hideKeyboardWhenTappedAround()
        self.emailTextField.delegate = self
        if(mainInstance.profile == true){
            ToolbarView.isHidden = false
            backB.isHidden = true
        }else{
            ToolbarView.isHidden = true
            backB.isHidden = false
        }
        self.emailTextField.delegate = self
        
        backB.layer.shadowColor = UIColor.black.cgColor
        backB.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        backB.layer.masksToBounds = false
        backB.layer.shadowRadius = 1.0
        backB.layer.shadowOpacity = 0.5
        backB.layer.cornerRadius = 7
        backB.showsTouchWhenHighlighted = true
        
        resetB.layer.shadowColor = UIColor.black.cgColor
        resetB.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        resetB.layer.masksToBounds = false
        resetB.layer.shadowRadius = 1.0
        resetB.layer.shadowOpacity = 0.5
        resetB.layer.cornerRadius = 7
        resetB.showsTouchWhenHighlighted = true
        
        BacktoFeed.layer.shadowColor = UIColor.black.cgColor
        BacktoFeed.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        BacktoFeed.layer.masksToBounds = false
        BacktoFeed.layer.shadowRadius = 1.0
        BacktoFeed.layer.shadowOpacity = 0.5
        BacktoFeed.layer.cornerRadius = 7
        BacktoFeed.showsTouchWhenHighlighted = true

        BackToProf.layer.shadowColor = UIColor.black.cgColor
        BackToProf.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        BackToProf.layer.masksToBounds = false
        BackToProf.layer.shadowRadius = 1.0
        BackToProf.layer.shadowOpacity = 0.5
        BackToProf.layer.cornerRadius = 7
        BackToProf.showsTouchWhenHighlighted = true
        
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
    // Reset Password Action
    @IBAction func submitAction(_ sender: AnyObject) {
        
        if self.emailTextField.text == "" {
            let alertController = UIAlertController(title: "Uh-Oh!", message: "Please enter an email. Otherwise we cannot find you :)", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!, completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "Error!"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.emailTextField.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    func setNavigationBar() {
        self.navigationItem.title = "Reset Password"
    }
    func setToolbar(){
        self.ToolbarView.layer.borderWidth = 2
        self.ToolbarView.layer.borderColor = UIColor(red:77/255, green:46/255, blue:113/255, alpha: 1).cgColor
    }
    @IBAction func backToFeed(_ sender: AnyObject){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Feed")
        present(vc, animated: true, completion: nil)
    }
    @IBAction func backtoUserProf(_ sender:AnyObject){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserProfileVC")
        present(vc, animated: true, completion: nil)
    }
}
