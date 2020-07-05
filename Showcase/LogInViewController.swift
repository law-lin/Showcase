//
//  LogInViewController.swift
//  Showcase
//
//  Created by Lawrence Lin on 6/24/20.
//  SBU ID: 112801579
//  Copyright © 2020 Lawrence Lin. All rights reserved.
//

import UIKit
import FirebaseAuth

// MARK: - The controller for the login screen
class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLogIn()
        // Do any additional setup after loading the view.
    }
    
    // Initializes login screen
    func initLogIn(){
        errorLabel.alpha = 0
        
        Styles.styleTextField(emailTextField)
        Styles.styleTextField(passwordTextField)
        Styles.styleButton(loginButton)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func loginButtonTapped(_ sender: Any) {
       let error = validate()
        
        if error != nil {
            displayError(error!)
        }
        else{
            // Trim any white spaces and new lines in the text
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if error != nil{
                    self.displayError("Invalid username or password")
                }
                else{
                    self.transitionToHome()
                }
            }
          
        }
    }
    
    // Checks if the required fields are filled out
    func validate() -> String? {
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
       
        return nil
    }
    
    // Displays an error
    func displayError(_ errorMsg:String){
        errorLabel.text = errorMsg
        errorLabel.alpha = 1
    }
    
    // Segue from login screen to home screen
    func transitionToHome(){
        let tabBarController = storyboard?.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController
        view.window?.rootViewController = tabBarController
    }
}
