//
//  InitialViewController.swift
//  Showcase
//
//  Created by Lawrence Lin on 7/4/20.
//  Copyright © 2020 Lawrence Lin. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Styles.styleButton(loginButton)
        Styles.styleHollowButton(signupButton)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
