//
//  SignUpViewController.swift
//  Showcase
//
//  Created by Lawrence Lin on 6/24/20.
//  SBU ID: 112801579
//  Copyright © 2020 Lawrence Lin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

// MARK: - The controller for the sign up screen
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
    
    // Initializes the sign up screen
    func initSignUp(){
        // Hide error label
        errorLabel.alpha = 0
        
        Styles.styleTextField(usernameTextField)
        Styles.styleTextField(emailTextField)
        Styles.styleTextField(passwordTextField)
        Styles.styleButton(signUpButton)
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
                    ref.child("users").child(authResult!.user.uid).setValue(["username": username, "biography": "", "isPrivate": false])
                    self.transitionToHome()
                }
            }
        }
    }
    
    // Checks if the required fields are filled out
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
    
    // Displays an error
    func displayError(_ errorMsg:String){
        errorLabel.text = errorMsg
        errorLabel.alpha = 1
    }
    
    // Segue from sign up screen to home screen
    func transitionToHome(){
        let tabBarController = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController
        view.window?.rootViewController = tabBarController
    }
    
}
