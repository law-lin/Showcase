//
//  User.swift
//  Showcase
//
//  Created by Lawrence Lin on 6/28/20.
//  SBU ID: 112801579
//  Copyright © 2020 Lawrence Lin. All rights reserved.
//

import Foundation

// MARK: - A class to represent a User
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
