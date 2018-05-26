//
//  UserModel.swift
//  JustAThought
//
//  Created by Grumpy1211 on 12/24/17.
//  Copyright © 2017 MuSquared. All rights reserved.
//

import Foundation

class UserModel{
    var userEmail: String?
    var username: String?
    var firstName: String?
    var lastName: String?
    var middleName: String?
    var uid: String?
    
    init(userEmail: String?, username: String?, uid: String?){//, firstName: String?, middleName: String?, lastName:String?){
        self.userEmail = userEmail
        self.username = username
        self.uid = uid
        //self.firstName = firstName
        //self.middleName = middleName
        //self.lastName = lastName
    }
    
}
