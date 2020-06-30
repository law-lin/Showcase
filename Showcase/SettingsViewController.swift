//
//  SettingsViewController.swift
//  Showcase
//
//  Created by Lawrence Lin on 6/26/20.
//  Copyright © 2020 Lawrence Lin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SettingsViewController: UIViewController {

    @IBOutlet weak var privateModeSwitch: UISwitch!
    
    var ref = Database.database().reference()
    
    let auth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            print(value!)
            self.privateModeSwitch.setOn((value?["isPrivate"] as? Bool)!, animated: true)
            print((value?["isPrivate"])!)
        })
    }

    @IBAction func setPrivateMode(_ sender: Any) {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users/\(userID!)").updateChildValues(["isPrivate": privateModeSwitch.isOn])
    }
    @IBAction func signOutButtonTapped(_ sender: Any) {
        do{
            try auth.signOut()
            transitionToMainView()
        } catch let error as NSError {
            print("Error signing out: %@", error)
            
        }
    }
    
    func transitionToMainView(){
        let mainViewController = storyboard?.instantiateViewController(withIdentifier: "MainViewController")
        view.window?.rootViewController = mainViewController
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
