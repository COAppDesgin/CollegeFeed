//
//  RegisterPageViewController.swift
//  CollegeFeed
//
//  Created by Tyler Jordan Cagle on 7/15/17.
//  Copyright © 2017 COAppDesign. All rights reserved.
//

import UIKit

class RegisterPageViewController: UIViewController {


    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userRepeatPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        let userRepeatPassword = userRepeatPasswordTextField.text
        
        //Check for empty fields
        
        if userEmail!.isEmpty || userPassword!.isEmpty || userRepeatPassword!.isEmpty {
            
            //Display alert message
            
//            displayAlertMessage(userMessage: "All fields are required.")
            return;
        
        }
        
        //Check if passwords match
        if userPassword != userRepeatPassword {
            
            //Display alert message
            
//            displayAlertMessage(userMessage: "Passwords do not match")
            return;
            
        }
        
        //Store data server side
        let urlRegister = NSURL(string: "http://tjauth.dev:8888/userRegister.php")
        let request = NSMutableURLRequest(url: urlRegister! as URL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let postString = "email=\(String(describing: userEmail))&password=\(String(describing: userPassword))"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil {
                print("error=\(describing: error)")
                return
            }
        
            do {
            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary

        
            if let parseJSON = json {
                let resultValue = parseJSON["status"] as! String
                print("result: \(resultValue)")
                
                var isUserRegistered: Bool = false
                if resultValue == "Success" { isUserRegistered = true }
                
                var messageToDisplay: String = parseJSON["message"] as! String
                if !isUserRegistered { messageToDisplay = parseJSON["message"] as! String }
                
                DispatchQueue.main.async(execute: {
                
                    //Display alert message with configuration
                    let alert = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { action in
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                })
            }
            } catch {
                print(error)
            }
        }
        task.resume()
        
        
//        //Display alert message with confirmation
//        
//        let alert = UIAlertController(title: "Success", message: "Registration was successful!", preferredStyle: UIAlertControllerStyle.alert)
//        
//        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { action in
//            self.dismiss(animated: true)
//        }
//        
//        alert.addAction(okAction)
//        self.present(alert, animated: true, completion: nil)
//    
    }
//    
//    
//    func displayAlertMessage(userMessage: String) {
//        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
//        
//        let action = UIAlertAction(title: "Go", style: UIAlertActionStyle.default, handler: nil)
//        
//        alert.addAction(action)
//        
//        self.present(alert, animated: true, completion: nil)
//    }
}




















