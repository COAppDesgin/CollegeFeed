//
//  AccountViewController.swift
//  CollegeFeed
//
//  Created by Tyler Jordan Cagle on 7/20/17.
//  Copyright © 2017 COAppDesign. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    
    var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        
        profileImageView.image = UIImage(named: "profile")
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        profileImageView.isUserInteractionEnabled = true

    }
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        //        let uid = Auth.auth().currentUser?.uid
        //        let data = UIImageJPEGRepresentation(profileImageView.image!, 0.6)
        //        let ref = Database.database().reference(fromURL: "https://collegefeed-de9f0.firebaseio.com/")
        //        ref.child("users").child(uid!).setValue(["profilePicture": data])
        //
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let imageName = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
        if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
            storageRef.putData(uploadData, metadata: nil, completion: {  (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                    let values = ["picture": profileImageURL]
                    self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                }
            })
        }
    
        dismiss(animated: true, completion: nil)
        
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            
        if (snapshot.value as? [String: AnyObject]) != nil {
            let user = Users()
        
            if let userProfileImageURL = user.picture {
                let url = URL(string: userProfileImageURL)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.profileImageView.image = UIImage(data: data!)
                    })
                    
                }).resume()
            }
            return
        }
        })
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference(fromURL: "https://collegefeed-de9f0.firebaseio.com/")
        let usersRef = ref.child("users").child(uid)
        
        usersRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil {
                print(err!)
                return
            }
        })
            
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        //let loginController = LoginViewController()
        present(viewController, animated: true, completion: nil)
    }
    
    
//    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
//        UserDefaults.standard.set(false, forKey: "isUserLoggedIn")
//        UserDefaults.standard.synchronize()
//        self.performSegue(withIdentifier: "loginView", sender: self)
//    }
    
    @IBAction func unwindToAccount(segue: UIStoryboardSegue) {}

}
