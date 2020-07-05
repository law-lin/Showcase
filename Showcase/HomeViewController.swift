//
//  HomeViewController.swift
//  Showcase
//
//  Created by Lawrence Lin on 6/28/20.
//  SBU ID: 112801579
//  Copyright © 2020 Lawrence Lin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

// MARK: - The controller for the home view with all public profiles shown
class HomeViewController: UITableViewController {
    
    var users = [User]()
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDataFromDatabase()
        tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool){
        loadDataFromDatabase()
        tableView.reloadData()
    }
    
    // MARK: - Load data from Firebase Realtime Database
    func loadDataFromDatabase() {
        
        let userID = Auth.auth().currentUser?.uid
        users.removeAll()
        ref.child("users").queryOrderedByKey().observe(DataEventType.value, with: { (snapshot) in
            if let dict = snapshot.children.allObjects as? [DataSnapshot]{
                self.users.removeAll()
                for result in dict {
                    if(result.key == userID){
                        continue
                    }
                    let results = result.value as? [String : AnyObject]
                    let isPrivate = results?["isPrivate"] as? Bool
                    if(isPrivate == true){
                        continue
                    }
                    let username = results?["username"] as? String
                    let user = User(username: username)
                    user.userID = result.key
                    user.biography = results?["biography"] as? String
                    user.profilePictureURL = results?["profilePictureURL"] as? String
                    self.users.append(user)
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
       
        // Configure the cell...
        let user = users[indexPath.row]
        cell.textLabel?.text = user.username
    
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewUser"{
            let taskController = segue.destination as? PublicProfileViewController
            let selectedRow = tableView.indexPathForSelectedRow?.row
            let selectedUser = users[selectedRow!]
            taskController?.selectedUser = selectedUser
        }
    }
}
