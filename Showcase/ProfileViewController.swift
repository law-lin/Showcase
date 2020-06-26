//
//  ProfileViewController.swift
//  Showcase
//
//  Created by Lawrence Lin on 6/26/20.
//  Copyright © 2020 Lawrence Lin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ProfileViewController: UITableViewController {

    var cards = [Card]()
    

    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromDatabase()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool){
        loadDataFromDatabase()
        tableView.reloadData()
    }
    
    func loadDataFromDatabase() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("cards").queryOrdered(byChild: "userID!").queryEqual(toValue: userID!).observe(.childAdded, with: { (snapshot) in
            if snapshot.childrenCount > 0{
                self.cards.removeAll()
                for result in snapshot.children.allObjects as! [DataSnapshot]{
                    let results = result.value as? [String : AnyObject]
                    let cardTitle = results?["cardTitle"]
                    let cardDescription = results?["cardDescription"]
                    let card = Card(cardTitle: cardTitle as! String?, cardDescription: cardDescription as! String?)
                    self.cards.append(card)
                }
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of row
        return cards.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath)

        // Configure the cell...
        let card = cards[indexPath.row]
        cell.textLabel?.text = card.cardTitle
        cell.detailTextLabel?.text = card.cardDescription

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
        if segue.identifier == "EditCard"{
            let taskController = segue.destination as? CardViewController
            let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
            let selectedCard = cards[selectedRow!]
            taskController?.currentCard = selectedCard
        }
    }
}
