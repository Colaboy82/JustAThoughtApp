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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    @IBAction func backTo(){//presssing back when logged in
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
}
