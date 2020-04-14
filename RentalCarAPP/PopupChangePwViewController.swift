//
//  PopupChangePwViewController.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 13/4/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit
import FirebaseAuth
class PopupChangePwViewController: UIViewController {
    
    
    @IBOutlet weak var errLbl: UILabel!
    
    
    @IBOutlet weak var inputScrollView: UIScrollView!
    
    
    @IBOutlet weak var cancelBk: customUIView!
    @IBOutlet weak var saveBK: customUIView!
    @IBOutlet weak var cancelBtn: CustomBtn!
    @IBOutlet weak var saveBtn: CustomBtn!
    @IBOutlet var textFieldCollection: [UITextField]!
    // [opw, npw, conpw]
    @IBOutlet weak var inputUIView: customUIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configTapGesture()
        styleConfig()
    }
    
    func styleConfig(){
        errLbl.alpha = 0.0
        
        inputUIView.setRounded()
       
        textFieldStyleConfig()
        
        // btn style
        saveBtn.setBtnStyle()
        cancelBtn.setBtnStyle()
      
        cancelBk.popupbtnShadow(bounds: cancelBtn.bounds, cornerRadius: cancelBtn.layer.cornerRadius)
        saveBK.popupbtnShadow(bounds: saveBtn.bounds, cornerRadius: saveBtn.layer.cornerRadius)
        
    }
    
    func textFieldStyleConfig(){
        for field in textFieldCollection{
            field.borderStyle = .none
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0.0, y: field.frame.height - 1, width: field.frame.width, height: 1.0)
            bottomLine.backgroundColor = UIColor(displayP3Red: 196.0/255.0, green: 196.0/255.0, blue: 198.0/255.0, alpha: 1.0).cgColor
            field.layer.addSublayer(bottomLine)
            
        }
        
        
    }
    @objc func handleTap(){
        view.endEditing(true)
    }
    func configTapGesture(){
        let tapGesture = UITapGestureRecognizer(target:  self, action: #selector(PopupChangePwViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    @IBAction func cancelTap(_ sender: Any) {
       backPrevious()
    }
    func backPrevious(){
        dismiss(animated: true, completion: nil)
    }
    func displayDefaultAlert(title: String?, message: String?) {
          let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
          let okAction = UIAlertAction(title: "OK", style: .default, handler: {action in self.backPrevious()})
          alert.addAction(okAction)
          self.present(alert, animated: true, completion: nil)
      }
    func checkValidation()->String?{
        if textFieldCollection[0].text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please enter your original password!"
        }else if textFieldCollection[1].text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please enter your new password!"
        }else if textFieldCollection[2].text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please confirm your new password!"
        }else{
            if textFieldCollection[1].text?.trimmingCharacters(in: .whitespacesAndNewlines) != textFieldCollection[2].text?.trimmingCharacters(in: .whitespacesAndNewlines){
                return "Your new passwords are not the same!"
            }else{
                return nil
            }
        }
        
    }
    @IBAction func saveTap(_ sender: Any) {
        let errMsg = checkValidation()
        
        if errMsg != nil{
            errLbl.text = errMsg
            errLbl.alpha = 1.0
        }else{
            updatePassword()
        }
       
    }
    func updatePassword(){
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: user?.email ?? "abc@email", password: textFieldCollection[0].text!)
       
        user?.reauthenticate(with: credential, completion: { (res, err) in
            if let err = err{
                print(err)
                self.errLbl.text = "Your original password is incorrect!"
                self.errLbl.alpha = 1.0
            }else{
                
                Auth.auth().currentUser?.updatePassword(to: self.textFieldCollection[2].text!) { (error) in
                    if let error = error{
                        print(error)
                       print("update password unsuccessfully")
                    }else{
                        print("update password successfully")
                        
                        self.displayDefaultAlert(title: "Password Changed!", message: "update password successfully")
                        
                    }
                }
            }
        })
        
    }
}
