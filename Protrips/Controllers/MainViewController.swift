//
//  MainViewController.swift
//  Protrips
//
//  Created by mac on 12/12/20.
//

import UIKit


class MainViewController: UIViewController {

    @IBOutlet weak var proTripsLabel: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.borderWidth = 1.0
        signUpButton.layer.borderColor = UIColor.white.cgColor
        signUpButton.clipsToBounds = true
        
        signInButton.layer.cornerRadius = 10
        signInButton.layer.borderWidth = 1.0
        signInButton.layer.borderColor = UIColor.white.cgColor
        signInButton.clipsToBounds = true
        // Do any additional setup after loading the view.
        
        // animation title
        proTripsLabel.text = ""
        var charIndex = 0.0
        let titleText = "ProTrips"
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.5 * charIndex, repeats: false)  { [weak self] (timer) in
                self?.proTripsLabel.text?.append(letter)
            }
            charIndex += 1
        }
        
        // animation button
        signInButton.alpha = 0
        UIView.animate(withDuration: 2.0, animations: {
            self.signInButton.alpha = 1
        }, completion: nil)
        
        signUpButton.alpha = 0
        UIView.animate(withDuration: 2.0, animations: {
            self.signUpButton.alpha = 1
        }, completion: nil)
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
