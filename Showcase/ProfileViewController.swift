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

class CardCell: UITableViewCell {
    
    @IBOutlet weak var cardTitleLabel: UILabel!
    @IBOutlet weak var cardDescriptionLabel: UILabel!
    @IBOutlet weak var cardImageView: UIImageView!
}

class ProfileViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  
    @IBOutlet weak var editProfileButton: UIBarButtonItem!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var biographyTextView: UITextView!
    @IBOutlet weak var changeProfilePicture: UIButton!
    @IBOutlet weak var profilePictureView: UIImageView!
    
    var cards = [Card]()
    
    let userID = Auth.auth().currentUser?.uid
    var ref = Database.database().reference()
    var storageRef = Storage.storage().reference()
    
    var imagePicker = UIImagePickerController()
    
    var loading = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        showLoadingIndicator()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool){
        loadDataFromDatabase()
        tableView.reloadData()
    }
    
    func showLoadingIndicator() {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    
    func loadDataFromDatabase() {
        ref.child("users").queryOrderedByKey().observe(DataEventType.value, with: { (snapshot) in
            if let dict = snapshot.children.allObjects as? [DataSnapshot]{
                for result in dict {
                    let results = result.value as? [String : AnyObject]
                    if(result.key == self.userID){
                        self.usernameTextField.text = results?["username"] as? String
                        self.biographyTextView.text = results?["biography"] as? String
                        
                        if let profilePictureURL = results?["profilePictureURL"] as? String{
                            print("Loading profile picture")
                            print(profilePictureURL)
                            self.profilePictureView?.loadImageUsingCache(urlString: profilePictureURL)
                            }
                        return
                    }
                }
            }
        })
                
        ref.child("cards").child(userID!).queryOrderedByKey().observe(DataEventType.value, with: { (snapshot) in
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
                    self.dismiss(animated: false, completion: nil)
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
        // #warning Incomplete implementation, return the number of row
        return cards.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell

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
//                print("setting image")
//                cell.cardImageView?.image = UIImage(data: imgData)
//            }
//        }
        return cell
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

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let card = cards[indexPath.row]
            ref.child("cards").child(userID!).child(card.cardID!).removeValue()
            cards.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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
    
    
    @IBAction func editProfileButtonTapped(_ sender: Any) {
        if(editProfileButton.title == "Edit Profile"){
            editProfileButton.title = "Save"
            usernameTextField.isEnabled = true
            usernameTextField.borderStyle = UITextField.BorderStyle.roundedRect
            biographyTextView.isEditable = true
            biographyTextView.layer.borderColor = UIColor.lightGray.cgColor
            biographyTextView.layer.borderWidth = 1
            
            changeProfilePicture.setTitle("Change Profile Picture", for: .normal)
            changeProfilePicture.isEnabled = true
            changeProfilePicture.layer.borderWidth = 2
            changeProfilePicture.layer.borderColor = UIColor.black.cgColor
            changeProfilePicture.tintColor = UIColor.black
        }
        else{
            editProfileButton.title = "Edit Profile"
            usernameTextField.isEnabled = false
            usernameTextField.borderStyle = UITextField.BorderStyle.none
            biographyTextView.isEditable = false
            biographyTextView.layer.borderColor = nil
            biographyTextView.layer.borderWidth = 0
            
            changeProfilePicture.setTitle("", for: .normal)
            changeProfilePicture.isEnabled = false
            changeProfilePicture.layer.borderWidth = 0
            changeProfilePicture.layer.borderColor = nil
            changeProfilePicture.tintColor = nil
            
            let updateRef = self.ref.child("users/\(userID!)")
            let imgRef = self.storageRef.child("profilePictures/\(userID!)")
           
            if profilePictureView?.image != nil{
                if let uploadData = profilePictureView.image!.pngData(){
                    imgRef.putData(uploadData, metadata: nil) { (metadata, error) in
                        if(error != nil){
                            print(error!)
                            return
                        }
                        imgRef.downloadURL(completion: { (url, error) in
                            if(error != nil){
                                print(error!)
                                return
                            }
                            updateRef.updateChildValues(["username": self.usernameTextField.text!, "biography": self.biographyTextView.text!, "profilePictureURL": url!.absoluteString])
                             print("Profile picture update success")
                        })
                    }
                }
            }
            else{
                let updateRef = self.ref.child("users/\(userID!)")
                updateRef.updateChildValues(["username": usernameTextField.text!, "biography": biographyTextView.text!])
            }
        }
    }
    
    
    @IBAction func profilePictureTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = false
                
                present(imagePicker, animated: true, completion: nil)
            }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePictureView.contentMode = .scaleAspectFit
            profilePictureView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
}



