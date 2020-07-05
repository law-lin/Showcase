//
//  Card.swift
//  Showcase
//
//  Created by Lawrence Lin on 6/26/20.
//  SBU ID: 112801579
//  Copyright © 2020 Lawrence Lin. All rights reserved.
//

import Foundation

// MARK: - The class to represent a Card
class Card {
    var cardID: String?
    var cardTitle: String?
    var cardDescription: String?
    var cardImageURL: String?
    
    init(cardTitle: String?, cardDescription: String?){
        self.cardTitle = cardTitle
        self.cardDescription = cardDescription
    }
}
