//
//  PersonalInfoTableViewController.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 1/3/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SKCountryPicker
class PersonalInfoTableViewController: UITableViewController, UINavigationControllerDelegate{
    
    var personalInfo: PersonalInfo?
    
    
    @IBOutlet weak var fNameField: UITextField!
    @IBOutlet weak var lNameField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var dateOfBirthField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    
    @IBOutlet weak var countryCodePicker: UIButton!
    @IBOutlet var textFieldCollection: [UITextField]!
    //["fname", "lnam","gender", "email", "phone"]
    
    var currentTextField = UITextField()
    var pickerView = UIPickerView()
    var gender = ["male", "female", "other"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.contentInsetAdjustmentBehavior = .never
        configTapGesture()
        fetchPersonalData()
        sytlyConfig()
        
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }
    func configTapGesture(){
        let tapGesture = UITapGestureRecognizer(target:  self, action: #selector(PersonalInfoTableViewController.handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    func textFieldConfig(){
        if fNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
           fNameField.text = personalInfo?.firstName
        }
        if lNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
           lNameField.text = personalInfo?.lastName
        }
        if emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            emailField.text = personalInfo?.email
        }
        if genderField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            genderField.text = personalInfo?.gender
        }
        if phoneField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            phoneField.text = personalInfo?.phoneNumber
        }
        if dateOfBirthField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            dateOfBirthField.text = personalInfo?.dateOfBirth
        }
        if countryCodePicker.title(for: .normal)! == "country code"{
            countryCodePicker.setTitle(personalInfo?.countryCode, for: .normal)
        }
    }
    func fetchPersonalData(){
        let uid = Auth.auth().currentUser?.uid
        FireDataLoader().fetchUserInfo(userId: uid!){
            (user) in
            self.personalInfo = user
            self.textFieldConfig()
        }
    }
    
    func updatepersonalData(){
        let uid = Auth.auth().currentUser?.uid
        let dbRef = Database.database().reference()
        
        let dic: [String:Any] = ["email": emailField.text!,"firstName": fNameField.text!, "lastName": lNameField.text!, "phoneNumber": phoneField.text!, "gender": genderField.text!, "dateOfBirth": dateOfBirthField.text!, "countryCode": countryCodePicker.title(for: .normal)!, "renting": personalInfo!.renting, "listing": personalInfo!.listing]
        dbRef.child("userinfo").child(uid!).updateChildValues(dic)
        print("update personal info successfully")
        
    }
    func sytlyConfig(){
        for field in textFieldCollection{
            field.borderStyle = .none
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0.0, y: field.frame.height - 1, width: field.frame.width, height: 1.0)
            bottomLine.backgroundColor = UIColor(displayP3Red: 196.0/255.0, green: 196.0/255.0, blue: 198.0/255.0, alpha: 1.0).cgColor
            field.layer.addSublayer(bottomLine)
            
        }
        
        
        
        // pick view
        pickerView.backgroundColor = UIColor(displayP3Red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.3)
        pickerView.setValue(UIColor(displayP3Red: 60.0/255.0, green: 128.0/255.0, blue: 247.0/255.0, alpha: 1.0), forKeyPath: "textColor")
        
        
        countryCodePicker.setImage(UIImage(named: "icons8-sort-down-20"), for: .normal)
        countryCodePicker.imageEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 1)
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: countryCodePicker.frame.height - 1, width: countryCodePicker.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor(displayP3Red: 196.0/255.0, green: 196.0/255.0, blue: 198.0/255.0, alpha: 1.0).cgColor
        countryCodePicker.layer.addSublayer(bottomLine)
        
    }
    
    @IBAction func countryCodeTapped(_ sender: Any) {
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
            
            guard let self = self else { return }
            
            //   self.countryImageView.image = country.flag
            self.countryCodePicker.setTitle(country.dialingCode, for: .normal)
            self.countryCodePicker.titleLabel?.font = UIFont(name: "Noto Sans Myanmar", size: 17)
            self.countryCodePicker.setTitleColor(UIColor.black, for: .normal)
            
        }
        
        // can customize the countryPicker here e.g font and color
        countryController.detailColor = UIColor.lightGray
        countryController.flagStyle = .circular
    }
    @IBAction func backTapped(_ sender: Any) { self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        updatepersonalData()
        self.navigationController?.popViewController(animated: true)
    }
}

extension PersonalInfoTableViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        currentTextField = textField
        
        if currentTextField == genderField{
            currentTextField.inputView = pickerView
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension PersonalInfoTableViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if currentTextField == genderField{
            return gender.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == genderField{
            return gender[row]
        }else{
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentTextField == genderField{
            genderField.text = gender[row]
            self.view.endEditing(true)
        }
    }
}

