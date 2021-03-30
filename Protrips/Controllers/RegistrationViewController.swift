//
//  RegistrationViewController.swift
//  Protrips
//
//  Created by mac on 12/13/20.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class RegistrationViewController: UIViewController {
    
    
    var databaseRef = Database.database().reference()
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        let email = emailTextField.text
        let name = nameTextField.text
        let password = passwordTextField.text
        let surname = surnameTextField.text
        let phoneNumber = phoneTextField.text
        
        
        if email != "" && password != "" && name != "" && surname != "" {
            indicator.startAnimating()
            indicator.isHidden = false
            Auth.auth().createUser(withEmail: email!, password: password!) { [weak self] (result, error) in
                self?.indicator.stopAnimating()
                self?.indicator.isHidden = true
                Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                
                if error == nil {
                    self?.databaseRef.child("user_profile").child(Auth.auth().currentUser!.uid).child("email").setValue(email)
                    self?.databaseRef.child("user_profile").child(Auth.auth().currentUser!.uid).child("name").setValue(name)
                    self?.databaseRef.child("user_profile").child(Auth.auth().currentUser!.uid).child("surname").setValue(surname)
                    self?.databaseRef.child("user_profile").child(Auth.auth().currentUser!.uid).child("phone").setValue(phoneNumber)
                    self?.showMessage(title: "Success", message: "Please verify you email!")
                } else {
                    self?.showMessage(title: "Error", message: "Ohhh! Some problems ocurred!")
                    self?.indicator.stopAnimating()
                    self?.indicator.isHidden = true
                }
            }
        }
        
    }
    
    func showMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        let ok = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            if title != "Error" {
                self.dismiss(animated: true, completion: nil)
            }
        }
        alert.addAction(ok)
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
}
