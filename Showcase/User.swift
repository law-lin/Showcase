//
//  User.swift
//  Showcase
//
//  Created by Lawrence Lin on 6/28/20.
//  Copyright © 2020 Lawrence Lin. All rights reserved.
//

import Foundation

class User {
    var userID: String?
    var username: String?
    var biography: String?
    var profilePictureURL: String?
    
    init(username: String?){
        self.username = username
        self.biography = ""
        self.profilePictureURL = ""
    }
}
