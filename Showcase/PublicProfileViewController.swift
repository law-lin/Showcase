//
//  PublicProfileViewController.swift
//  Showcase
//
//  Created by Lawrence Lin on 6/26/20.
//  SBU ID: 112801579
//  Copyright © 2020 Lawrence Lin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

// MARK: - The controller for a public profile
class PublicProfileViewController: UITableViewController {
    
    @IBOutlet weak var usernameTextLabel: UILabel!
    @IBOutlet weak var biographyTextLabel: UILabel!
    @IBOutlet weak var profilePictureView: UIImageView!
    
    var selectedUser : User?
    
    var cards = [Card]()
    
    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        usernameTextLabel.text = selectedUser?.username
        biographyTextLabel.text = selectedUser?.biography
        
        if let profilePictureURL = selectedUser?.profilePictureURL{
            profilePictureView.loadImageUsingCache(urlString: profilePictureURL)
            
        }
    
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
        // Set top title to the selected user's username
        self.navigationItem.title = selectedUser?.username
        if let userID = selectedUser?.userID{
            
            // Retreive data from Firebase
            ref.child("cards").child(userID).queryOrderedByKey().observe(DataEventType.value, with: { (snapshot) in
                if let dict = snapshot.children.allObjects as? [DataSnapshot]{
                    self.cards.removeAll()
                    for result in dict {
                        let results = result.value as? [String : AnyObject]
                        let cardID = result.key
                        let cardTitle = results?["cardTitle"] as? String
                        let cardDescription = results?["cardDescription"] as? String
                        let cardImageURL = results?["cardImageURL"] as? String
                        let card = Card(cardTitle: cardTitle, cardDescription: cardDescription)
                        card.cardID = cardID
                        card.cardImageURL = cardImageURL
                        self.cards.append(card)
                        self.tableView.reloadData()
                    }
                }
               
            })
        }
        
    }
        
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of row
        return cards.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PublicCardCell", for: indexPath) as! PublicCardCell

        // Configure the cell...
        let card = cards[indexPath.row]
        cell.cardTitleLabel?.text = card.cardTitle
        cell.cardDescriptionLabel?.text = card.cardDescription
        cell.cardImageView?.contentMode = .scaleAspectFill
        if let cardImageURL = card.cardImageURL{
            cell.cardImageView.loadImageUsingCache(urlString:
                cardImageURL)
        }
//        if card.cardImageURL != nil{
//
//            let url = URL(string: card.cardImageURL!)
//            if let imgData = try? Data(contentsOf: url!){
//                print("there is image data")
//                cell.cardImageView?.image = UIImage(data: imgData)
//            }
//        }
        return cell
    }
    
    // When user selects a card, display card title and card description
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = cards[indexPath.row]
        let cardTitle = card.cardTitle
        let cardDescription = card.cardDescription
        let alertController = UIAlertController(title: "\(cardTitle!)", message: " \(cardDescription!)", preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        alertController.addAction(actionCancel)
        present(alertController, animated: true, completion: nil)
    }
   
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250.0;
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
            let selectedRow = tableView.indexPathForSelectedRow?.row
            let selectedCard = cards[selectedRow!]
            taskController?.currentCard = selectedCard
        }
    }
    
}

