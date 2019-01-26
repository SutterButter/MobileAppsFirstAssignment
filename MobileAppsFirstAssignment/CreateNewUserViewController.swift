//
//  CreateNewUserViewController.swift
//  MobileAppsFirstAssignment
//
//  Created by Noah Sutter on 1/24/19.
//  Copyright © 2019 Noah Sutter. All rights reserved.
//

import UIKit
//import FirebaseAuth
import Firebase

class CreateNewUserViewController: UIViewController {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var db: Firestore!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func createUserPressed(_ sender: Any) {
        // check email not empty
        if let firstName = self.firstNameField.text, firstName != "",
            let lastName = self.lastNameField.text, lastName != "",
            let email = self.emailField.text, email != "",
            let password = self.passwordField.text, password != "" {
            
            // Start creating the user
            loadingIndicator.startAnimating()
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                // Done loading user
                self.loadingIndicator.stopAnimating()
                
                // If error show error
                if let error = error {
                    let alert = UIAlertController(title: "Problems creating a new user", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else if let userId = authResult?.uid {
                    
                    // Store name in user database
                    self.db.collection("users").document(userId).setData([
                        "firstName": firstName,
                        "lastName": lastName
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            // Document written, go to landing screen
                            print("Document successfully written!")
                            self.performSegue(withIdentifier: "createUserToLandingSegue", sender: self)
                        }
                    }
                } else {
                    print("SOMETHING WEIRD IS HAPPENING")
                }
            }
        } else { // if either name,email or password is emtpy display message
            let alert = UIAlertController(title: "Missing Information", message: "all fields required", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
