//
//  EditViewController.swift
//  Protrips
//
//  Created by mac on 12/18/20.
//



import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class EditViewController: UIViewController {

    
    let database = Database.database().reference()
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var indcator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        indcator.stopAnimating()
        indcator.isHidden = true
        saveButton.layer.cornerRadius = 10
        saveButton.layer.borderWidth = 1.5
        saveButton.layer.borderColor = UIColor.white.cgColor
        saveButton.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        nameTextField.center.x = self.view.frame.width + 50
        UIView.animate(withDuration: 1.5, delay: 00, usingSpringWithDamping: 1.0 , initialSpringVelocity: 1.0, options: .allowAnimatedContent, animations: {
            self.nameTextField.center.x = self.view.frame.width / 2 - 100
        }, completion: nil)
        surnameTextField.center.x = self.view.frame.width - 500
        UIView.animate(withDuration: 1.5, delay: 00, usingSpringWithDamping: 1.0 , initialSpringVelocity: 1.0, options: .allowAnimatedContent, animations: {
            self.surnameTextField.center.x = self.view.frame.width / 2 - 100
        }, completion: nil)
        
        saveButton.alpha = 0
        UIView.animate(withDuration: 2.0, animations: {
            self.saveButton.alpha = 1
        }, completion: nil)
    }
    

    @IBAction func savePressed(_ sender: UIButton) {
        indcator.isHidden = false
        let name = nameTextField.text
        let surname = surnameTextField.text
        let phone = phoneTextField.text
        
        indcator.startAnimating()
        
        
        database.child("user_info").observeSingleEvent(of: .value) { [self] (snapshot) in
            self.database.child("user_profile").child(Auth.auth().currentUser!.uid).child("name").setValue(name)
            self.database.child("user_profile").child(Auth.auth().currentUser!.uid).child("surname").setValue(surname)
            self.database.child("user_profile").child(Auth.auth().currentUser!.uid).child("phone").setValue(phone)
            showMessage(title: "Success", message: "Changed Info Successfuly")
        }
        
                }
    
    func showMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        let ok = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            if title != "Error" {
                let orderVC = self.storyboard?.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
                self.navigationController?.pushViewController(orderVC, animated: true)
            }
            self.indcator.stopAnimating()
        }
        alert.addAction(ok)
        // show the alert
        self.present(alert, animated: true, completion: nil)
        


    }
    
}
