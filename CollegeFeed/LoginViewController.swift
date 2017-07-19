//
//  LoginViewController.swift
//  CollegeFeed
//
//  Created by Tyler Jordan Cagle on 7/15/17.
//  Copyright © 2017 COAppDesign. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        
        if((userPassword?.isEmpty)! || (userEmail?.isEmpty)!) {
                
            //Display alert message
            displayAlertMessage(userMessage: "Missing required field")
            return
        }
        
        //Send user data serverside
        let myUrl = NSURL(string:"http://tjauth.dev:8888/userLogin.php")
        let request = NSMutableURLRequest(url: myUrl! as URL)
        request.httpMethod = "POST"
        
        let postString = "email=\(userEmail!)&password=\(userPassword!)"
        
        request.httpBody = postString.data(using: String.Encoding.utf8)
        
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                
                if let parseJSON = json {
                    let resultValue:String = parseJSON["status"] as! String
                    print("result: \(resultValue)")
                    
                    if (resultValue == "Success") {
                        //Login is successful
                        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                        UserDefaults.standard.synchronize()
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                    
//                    let messageToDisplay: String = parseJSON["message"] as! String
////                    if (!isUserRegistered) { messageToDisplay = parseJSON["message"] as! String }
//                    
//                    if (resultValue != "Success") {
//                        DispatchQueue.main.async(execute: {
//                            
//                            //Display alert message with confirmation
//                                let myAlert = UIAlertController(title: resultValue, message: messageToDisplay, preferredStyle: .alert)
//                                let okAction = UIAlertAction(title: "Ok", style: .default) { action in
//                                
//                            }
//                            
//                            myAlert.addAction(okAction)
//                            self.present(myAlert, animated: true, completion: nil)
//
//                        })
//                    }
                }
                
                
            } catch let error as NSError {
                var err: NSError?
                err = error
                print(err as NSError!)
            }
            
        }
        task.resume()
    }
    
    func displayAlertMessage(userMessage: String) {
        let alert = UIAlertController(title: "Error", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    

}

