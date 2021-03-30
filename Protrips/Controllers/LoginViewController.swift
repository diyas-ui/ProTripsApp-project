//
//  LoginViewController.swift
//  Protrips
//
//  Created by mac on 12/13/20.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    var currentUser: User?
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        indicator.isHidden = true
        super.viewDidLoad()
        signButton.layer.cornerRadius = 10
        signButton.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        currentUser = Auth.auth().currentUser
        if currentUser != nil && currentUser!.isEmailVerified{
            goToMainPage()
        }
        
    }
    
    @IBAction func signInPressed(_ sender: UIButton) {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        indicator.startAnimating()
        indicator.isHidden = false
        if email != "" && password != ""{
            Auth.auth().signIn(withEmail: email!, password: password!) { [weak self] (result, error) in
                self?.indicator.stopAnimating()
                self?.indicator.isHidden = true
                if error == nil {
                    if Auth.auth().currentUser!.isEmailVerified {
                        
                        self?.goToMainPage()
                        
                    }else{
                        self?.showMessage(title: "Warnings", message: "Your email is not verified")
                    }
                    
                }else{
                    
                }
            }
        }
    }
    

    func showMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        let ok = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
        }
        alert.addAction(ok)
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func goToMainPage(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let mainPage = storyboard.instantiateViewController(identifier: "TabBarController") as? TabBarController{
            mainPage.modalPresentationStyle = .fullScreen
            present(mainPage, animated: true, completion: nil)
        }
        
    }
}
