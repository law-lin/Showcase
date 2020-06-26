//
//  Card.swift
//  Showcase
//
//  Created by Lawrence Lin on 6/26/20.
//  Copyright © 2020 Lawrence Lin. All rights reserved.
//

import Foundation

class Card {
    var cardID: String?
    var cardTitle: String?
    var cardDescription: String?
    
    init(cardTitle: String?, cardDescription: String?){
        self.cardTitle = cardTitle
        self.cardDescription = cardDescription
    }
}
