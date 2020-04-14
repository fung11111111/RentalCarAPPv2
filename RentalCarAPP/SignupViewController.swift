//
//  SignupViewController.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 15/1/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
class SignupViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var signUpBtn: CustomBtn!
    @IBOutlet weak var SignUpScrollView: UIScrollView!
    @IBOutlet weak var errorLbl: UILabel!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var password2: UITextField!
    @IBOutlet weak var password1: UITextField!
    @IBOutlet weak var lNameField: UITextField!
    @IBOutlet weak var fNameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        configTapGesture()
        
        signUpBtn.setBtnStyle()
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        SignUpScrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        SignUpScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }
    func configTapGesture(){
        let tapGesture = UITapGestureRecognizer(target:  self, action: #selector(UploadTableViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    func checkValidation()->String?{
        if emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please enter your email address!"
        }else if fNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please enter your first name!"
        }else if lNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please enter your last name!"
        }else if password1.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || password2.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please enter the password!"
        }else{
            if password1.text?.trimmingCharacters(in: .whitespacesAndNewlines) != password2.text?.trimmingCharacters(in: .whitespacesAndNewlines){
                return "Please ensure both passwords are the same!"
            }else{
                return nil
            }
        }
        
        
    }
    @IBAction func singUpTapped(_ sender: Any) {
        let errormsg = checkValidation()
        if errormsg != nil {
            errorLbl.alpha = 1
            errorLbl.text = errormsg
        }else{
            errorLbl.alpha = 0
            let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = password1.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let fname = fNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lname = lNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().createUser(withEmail: email, password: password){ (result,err) in
                
                if err != nil{
                    print("Error in creating user account!")
                    self.errorLbl.alpha = 1
                    self.errorLbl.text = "Error in creating user account!"
                }else{
                    
                    let uid = Auth.auth().currentUser?.uid
                    let dbReference = Database.database().reference()
                    
                    let userInfodic:[String: Any] = ["firstName": fname,
                                                     "lastName": lname,
                                                     "email": email,
                                                     "gender": "",
                                                     "phoneNumber": "",
                                                     "dateOfBirth": "",
                                                     "countryCode": "country code",
                                                     "uid": uid!,
                                                     "listing": 0,
                                                     "rentin": 0
                    ]
                    dbReference.child("userinfo").child(uid!).setValue(userInfodic)
                    self.errorLbl.alpha = 0
                    let TabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
                    self.view.window?.rootViewController = TabBarController
                    self.view.window?.makeKeyAndVisible()
                    
                }
                
                
            }
            
        }
        
    }
}
