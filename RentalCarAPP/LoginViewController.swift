//
//  ViewController.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 13/1/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet weak var loginBtn: CustomBtn!
    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBOutlet weak var mailTextField: UITextField!
    
    @IBOutlet weak var pwTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        configTapGesture()
        loginBtn.setBtnStyle()
        
    }
    @objc func handleTap(){
           view.endEditing(true)
       }
    func configTapGesture(){
           let tapGesture = UITapGestureRecognizer(target:  self, action: #selector(UploadTableViewController.handleTap))
           view.addGestureRecognizer(tapGesture)
       }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        ScrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        ScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    
    @IBAction func loginTapped(_ sender: Any) {
        
        let errormsg = checkValidation()
        
        if errormsg != nil{
            self.errorLabel.alpha = 1
            self.errorLabel.text = errormsg
        }else{
            let email = mailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = pwTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            Auth.auth().signIn(withEmail: email, password: password){ (result,error) in
                
                if error != nil{
                    self.errorLabel.alpha = 1
                    self.errorLabel.text = "Incorrect email or password!"
                }else{
                    self.errorLabel.alpha = 0
                    let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") 
                    
                    self.view.window?.rootViewController = homeViewController
                    self.view.window?.makeKeyAndVisible()
                    
                    
                }
                
            }
        }
        
    }
    func checkValidation()->String?{
        if mailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || pwTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Please enter your email and password!"
        }
        
        return nil
    }
}

