//
//  SignUpViewController.swift
//  Showcase
//
//  Created by Lawrence Lin on 6/24/20.
//  Copyright © 2020 Lawrence Lin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        initSignUp()
        // Do any additional setup after loading the view.
    }
    
    func initSignUp(){
        // Hide error label
        errorLabel.alpha = 0
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        // Validate text fields
        let error = validate()
        
        if error != nil {
            displayError(error!)
        }
        else{
            let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            // Create user in Firebase
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if error != nil{
                    self.displayError("Error creating user")
                }
                else{
                    // Store user in Cloud Firestore
                    let ref = Database.database().reference()
                    ref.child("users").child(authResult!.user.uid).setValue(["username": username])
                    self.transitionToHome()
                }
            }
        }
    }
    
    func validate() -> String? {
        if usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill in all fields"
        }
        
        let trimmedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        
        if passwordTest.evaluate(with: trimmedPassword) == false {
            return "Password must be at least 8 characters, contain a special character, and contain a number."
        }
        return nil
    }
    
    func displayError(_ errorMsg:String){
        errorLabel.text = errorMsg
        errorLabel.alpha = 1
    }
    
    func transitionToHome(){
        let tabBarController = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController
        view.window?.rootViewController = tabBarController
    }
    
}
