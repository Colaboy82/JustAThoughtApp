//
//  UserVC.swift
//  JustAThought
//
//  Created by Grumpy1211 on 12/19/17.
//  Copyright © 2017 MuSquared. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SwiftKeychainWrapper

class UserVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userImagePicker: UIButton!
    @IBOutlet weak var completeSignInBtn: UIButton!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var userImgView: UIImageView!

    var userUid: String!
    var emailField: String!
    var passwordField: String!
    var imagePicker : UIImagePickerController!
    var imageSelected = false;
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController();
        imagePicker.delegate = self
        imagePicker.allowsEditing = true

    }
    
    func keychain(){
        KeychainWrapper.standard.set(userUid, forKey: "uid")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            userImgView.image = image
            imageSelected = true
        }else{
            print("image wasn't selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func setUpUser(img: String){
        let userData = [
            "username": username!,
            "userImg": img
        ]
        keychain()
        let setLocation = Database.database().reference().child("users").child(userUid)
        setLocation.setValue(userData)
    }
    
    func uploadImg(){
        if usernameField.text == nil{
            print("must have username")
            completeSignInBtn.isEnabled = false
        }else{
            username = usernameField.text
            completeSignInBtn.isEnabled = true
        }
        guard let img = userImagePicker.currentImage, imageSelected == true else {
            print("image must be selected")
            return
        }
        
        if let imgData = UIImageJPEGRepresentation(img, 0.2){
            let imgUid = NSUUID().uuidString
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            Storage.storage().reference().child(imgUid).putData(imgData, metadata: metadata) { (metadata, error) in
                if error != nil {
                    print("did not upload")
                }else{
                    print("uploaded")
                    let downloadURL = metadata?.downloadURL()?.absoluteString
                    if let url = downloadURL{
                        self.setUpUser(img: url)
                    }
                }
            }
        }
    }
    
    @IBAction func completeAccount(_ sender: Any){
        Auth.auth().createUser(withEmail: emailField, password: passwordField, completion: { (user, error) in
            if error != nil{
                print("can't create user \(error)")
            }else{//no error and user is succesfully created
                if let user = user {
                    self.userUid = user.uid
                }
            }
            self.uploadImg()
        })
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectedImagePicker(_ sender: Any){
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func cancel(_ sender: AnyObject){
        dismiss(animated: true, completion: nil)
    }
    
}
