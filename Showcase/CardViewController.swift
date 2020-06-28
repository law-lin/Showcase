//
//  CardViewController.swift
//  Showcase
//
//  Created by Lawrence Lin on 6/26/20.
//  Copyright © 2020 Lawrence Lin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class CardViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var currentCard: Card?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cardTitle: UITextField!
    @IBOutlet weak var cardDescription: UITextField!
    @IBOutlet weak var cardImage: UIImageView! = nil
    @IBOutlet weak var sgmtEditMode: UISegmentedControl!
    @IBOutlet weak var chooseImgBtn: UIButton!
    
    var imagePicker = UIImagePickerController()
    
    var dbRef = Database.database().reference()
    var storageRef = Storage.storage().reference()
    
    @IBAction func changeEditMode(_ sender: Any){
           let textFields: [UITextField] = [cardTitle, cardDescription]
           if sgmtEditMode.selectedSegmentIndex == 0 {
               for textField in textFields {
                   textField.isEnabled = false
                   textField.borderStyle = UITextField.BorderStyle.none
               }
               chooseImgBtn.isHidden = true
           }
           else if sgmtEditMode.selectedSegmentIndex == 1{
               for textField in textFields {
                   textField.isEnabled = true
                   textField.borderStyle = UITextField.BorderStyle.roundedRect
               }
            chooseImgBtn.isHidden = false
               navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
               target: self,
               action: #selector(self.saveCard))
           }
       }
       
    @IBAction func chooseImgBtnTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            cardImage.contentMode = .scaleAspectFit
            cardImage.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveCard() {
        // save card in Firebase
        let userID = Auth.auth().currentUser?.uid
        if currentCard == nil {
            currentCard = Card(cardTitle: self.cardTitle.text, cardDescription: self.cardDescription.text)
            let newRef = self.dbRef.child("cards/\(userID!)/").childByAutoId()
            let currentCardID : String = newRef.key!
            currentCard?.cardID = currentCardID
            
            print("success")
            let imgRef = self.storageRef.child("cardImages/\(userID!)/\(currentCardID))")
            if cardImage.image != nil{
                if let uploadData = cardImage.image!.pngData(){
                    imgRef.putData(uploadData, metadata: nil) { (metadata, error) in
                        imgRef.downloadURL(completion: { (url, error) in
                            self.currentCard?.cardImageURL = url?.absoluteString
                            newRef.setValue(["cardTitle": self.cardTitle.text!, "cardDescription": self.cardDescription.text!, "cardImageURL": url!.absoluteString])
                            print("cardimage success")
                        })
                    }
                }
            }
            else{
                newRef.setValue(["cardTitle": self.cardTitle.text!, "cardDescription": self.cardDescription.text!])
            }
        }
        else {
            let currentCardID : String = (currentCard?.cardID!)!
            let updateRef = self.dbRef.child("cards/\(userID!)/\(currentCardID)")
          
            let imgRef = self.storageRef.child("cardImages/\(userID!)/\(currentCardID)")
            print("update success")
            if cardImage.image != nil{
                if let uploadData = cardImage.image!.pngData(){
                    imgRef.putData(uploadData, metadata: nil) { (metadata, error) in
                        imgRef.downloadURL(completion: { (url, error) in
                            updateRef.updateChildValues(["cardTitle": self.cardTitle.text!, "cardDescription": self.cardDescription.text!, "cardImageURL": url!.absoluteString])
                             print("cardimage update success")
                        })
                    }
                }
            }
            else {
                  updateRef.updateChildValues(["cardTitle": self.cardTitle.text!, "cardDescription": self.cardDescription.text!])
            }
           
        }
        sgmtEditMode.selectedSegmentIndex = 0
        changeEditMode(self)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
     
        if currentCard != nil{
            cardTitle.text = currentCard?.cardTitle
            cardDescription.text = currentCard?.cardDescription
            print(cardTitle.text!)
           
            if currentCard?.cardImageURL != nil {
//                let imgURL = URL(string: (currentCard?.cardImageURL)!)
                let imgRef = Storage.storage().reference(forURL: (currentCard?.cardImageURL)!)
                imgRef.downloadURL(completion: { (url, error) in
                    if(error != nil){
                        print(error!)
                        return
                    }
                    else{
                        do{
                            let imgData = try Data(contentsOf: url!) as Data
                            let img = UIImage(data: imgData)
                            self.cardImage.contentMode = .scaleToFill
                            self.cardImage.image = img
                           
                        }
                        catch{
                            self.cardImage.image = nil
                        }
                    }
                })
            }
        }
        
        print("after load")
        self.changeEditMode(self)
    }
    
       override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           self.registerKeyboardNotifications()
       }
       
       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           self.unregisterKeyboardNotifications()
       }
       
       func registerKeyboardNotifications() {
           NotificationCenter.default.addObserver(self, selector: #selector(CardViewController.keyboardDidShow(notification:)), name:
               UIResponder.keyboardDidShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector:
               #selector(CardViewController.keyboardWillHide(notification:)), name:
               UIResponder.keyboardWillHideNotification, object: nil)
       }

       func unregisterKeyboardNotifications() {
           NotificationCenter.default.removeObserver(self)
       }
       
       @objc func keyboardDidShow(notification: NSNotification) {
           let userInfo: NSDictionary = notification.userInfo! as NSDictionary
           let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
           let keyboardSize = keyboardInfo.cgRectValue.size
           
           // Get the existing contentInset for the scrollView and set the bottom property to
           //be the height of the keyboard
           var contentInset = self.scrollView.contentInset
           contentInset.bottom = keyboardSize.height
           
           self.scrollView.contentInset = contentInset
           self.scrollView.scrollIndicatorInsets = contentInset
       }
       
       @objc func keyboardWillHide(notification: NSNotification) {
           var contentInset = self.scrollView.contentInset
           contentInset.bottom = 0
           
           self.scrollView.contentInset = contentInset
           self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
       }
       
//       override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//     }

}
