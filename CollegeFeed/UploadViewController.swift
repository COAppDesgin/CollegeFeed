//
//  UploadViewController.swift
//  CollegeFeed
//
//  Created by Tyler Jordan Cagle on 7/20/17.
//  Copyright © 2017 COAppDesign. All rights reserved.
//

import UIKit
import Firebase


class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    
    var picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.previewImage.image = image
            selectButton.isHidden = true
            postButton.isHidden = false
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func selectPressed(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
        
    }

    @IBAction func postPressed(_ sender: Any) {
        
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        let storage = Storage.storage().reference(forURL: "gs://collegefeed-de9f0.appspot.com")
        
        let key = ref.child("posts").childByAutoId().key
        let imageRef = storage.child("posts").child(uid).child("\(key).jpg")
        let data = UIImageJPEGRepresentation(self.previewImage.image!, 0.6)
        
        let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if let url = url {
                    let feed = ["userID" : uid,
                                "pathToImage" : url.absoluteString,
                                "views" : 0,
                                "author" : Auth.auth().currentUser!.displayName!,
                    "postID" : key] as [String : Any]
                    
                    let postFeed = ["\(key)" : feed]
                    
                    ref.child("posts").updateChildValues(postFeed)
                    
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
        
        uploadTask.resume()
        
    }
    
    
}