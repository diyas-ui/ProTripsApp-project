//
//  InfoViewController.swift
//  Protrips
//
//  Created by mac on 12/17/20.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseStorage

class InfoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var surnameLabel: UILabel!
    

    
    var current_user : User?
    var databaseRef = Database.database().reference()
    var storageRef = Storage.storage().reference()
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.current_user = Auth.auth().currentUser
        
        databaseRef.child("user_profile").child(self.current_user!.uid).observeSingleEvent(of: .value) { [weak self] (snapshot: DataSnapshot) in
            let value = snapshot.value as? NSDictionary
            
            let snapshot = snapshot.value as! [String: AnyObject]
            
            self?.nameLabel.text = value?["name"] as? String ?? ""
            self?.surnameLabel.text = value?["surname"] as? String ?? ""
            self?.emailLabel.text = value?["email"] as? String ?? ""
            self?.phoneNumberLabel.text = value?["phone"] as? String ?? ""
            
            
            if(snapshot["profile_pic"] !== nil)
            {
                let databaseProfilePic = snapshot["profile_pic"]
                    as! String
                
                let data = try? Data(contentsOf: URL(string: databaseProfilePic)!)
                
                self?.setProfilePicture((self?.profilePicture)!,imageToSet:UIImage(data:data!)!)
            }
            
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func gotoEdit(_ sender: UIButton) {
        let orderVC = self.storyboard?.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        self.navigationController?.pushViewController(orderVC, animated: true)
    }
    
    //logout
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do{
        try Auth.auth().signOut()
        } catch {
            print("Error message")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    internal func setProfilePicture(_ imageView:UIImageView,imageToSet:UIImage)
    {
        imageView.layer.cornerRadius = 10.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.masksToBounds = true
        imageView.image = imageToSet
    }
    
    
    
    
    @IBAction func didTapProfilePicture(_ sender: UITapGestureRecognizer) {
        
        //create the action sheet
        
        let myActionSheet = UIAlertController(title:"Profile Picture",message:"Select",preferredStyle: UIAlertController.Style.actionSheet)
        
        let viewPicture = UIAlertAction(title: "View Picture", style: UIAlertAction.Style.default) { (action) in
            
            let imageView = sender.view as! UIImageView
            let newImageView = UIImageView(image: imageView.image)
            
            newImageView.frame = self.view.frame
            
            newImageView.backgroundColor = UIColor.black
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target:self,action:#selector(self.dismissFullScreenImage))
            
            newImageView.addGestureRecognizer(tap)
            self.view.addSubview(newImageView)
        }
        
        let photoGallery = UIAlertAction(title: "Photos", style: UIAlertAction.Style.default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable( UIImagePickerController.SourceType.savedPhotosAlbum)
            {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true
                    , completion: nil)
            }
        }
        
        let camera = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable( UIImagePickerController.SourceType.camera)
            {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.allowsEditing = true
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        myActionSheet.addAction(viewPicture)
        myActionSheet.addAction(photoGallery)
        myActionSheet.addAction(camera)
        
        myActionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(myActionSheet, animated: true, completion: nil)
        
    }
    @objc func dismissFullScreenImage(_ sender:UITapGestureRecognizer)
        {
            //remove the larger image from the view
            sender.view?.removeFromSuperview()
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        

        setProfilePicture(self.profilePicture,imageToSet: image)
        
        let imageData: Data = self.profilePicture.image!.pngData()!
        
        
        let profilePicStorageRef = storageRef.child("user_profile/\(self.current_user!.uid)/profile_pic")
        
        _ = profilePicStorageRef.putData(imageData, metadata: nil){ (metadata, error) in
            profilePicStorageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                self.databaseRef.child("user_profile").child(self.current_user!.uid).child("profile_pic").setValue(downloadURL.absoluteString)
            }
        }
    }
    
}
