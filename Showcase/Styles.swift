//
//  Styles.swift
//  Showcase
//
//  Created by Lawrence Lin on 7/4/20.
//  SBU ID: 112801579
//  Copyright © 2020 Lawrence Lin. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Any styles used in the app
class Styles {
    
    // Styles the text field
    static func styleTextField(_ textfield:UITextField) {
        
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height:2)
        
        bottomLine.backgroundColor = UIColor.init(red: 48/255, green: 131/255, blue: 173/255, alpha: 1).cgColor
        
        textfield.borderStyle = .none
        
        textfield.layer.addSublayer(bottomLine)
    }
    
    // Styles a button (filled with color)
    static func styleButton(_ button:UIButton) {
        button.backgroundColor = UIColor.init(red: 48/255, green: 131/255, blue: 173/255, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    // STyles a button (hollow)
    static func styleHollowButton(_ button:UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
}
