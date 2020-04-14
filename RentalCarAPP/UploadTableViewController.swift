//
//  UploadTableViewController.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 18/2/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import Photos

protocol uploadModalDelegate {
    func getDayValue(startDay: String, endDay:String,dateRange: [Date])
    
}
protocol addressDelegate{
    func getAddress(streetName: String,lat: Double, lng: Double)
}
class UploadTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, uploadModalDelegate, addressDelegate{
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var listBtn: CustomBtn!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceSlider: UISlider!
    var currentTextField = UITextField()
    var pickerView = UIPickerView()
    
    @IBOutlet weak var typeTextfield: UITextField!
    @IBOutlet weak var transTextfield: UITextField!
    @IBOutlet weak var seaterTexField: UITextField!
    @IBOutlet weak var colorField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    @IBOutlet weak var brandTextField: UITextField!
    @IBOutlet weak var modelTextField: UITextField!
    
    
    var imgFileName: String?
    var startDay = ""
    var endDay = ""
    var dateRange = [Date]()
    var itemIdArr = [String]()
    @IBOutlet weak var availableDate: UILabel!
    @IBOutlet var textFieldCollection:   [UITextField]!
    // collection element ["brand","model","type","transmission","seats","color","year"]
    
    
    @IBOutlet var labelCollection: [UILabel]!
    // ["brand", "model", "img", "location", "type", "transmission", "seat", "color", "year", "price", "dates"]
    var carImage: UIImage?
    var streetName: String?
    var lat: Double?
    var lng: Double?
    var headerTitle = ["What does your car look like?", "Which of these souds most like your car?", "Complete the final step to list your car!"]
    var typeSelection = ["sedan","coupe","truck","SUV"]
    var transmissionSelection = ["automatic", "manual"]
    var seaterSelection = ["1", "2", "3", "4", "5", "6", "7", "8", "9" ]
    var colorSelection = ["white", "black", "yellow", "blue", "red", "green", "grey", "gold", "silver", "orange", "pink", "brown"]
    var yearSelection = ["2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012", "2013", "2014", "2015", "2016", "2017", "2018", "2019", "2020"]
    var imageRef: StorageReference {
        return Storage.storage().reference().child("carimages")
    }
    var personInfo: PersonalInfo?
    
    func getDayValue(startDay: String, endDay:String, dateRange: [Date]){
        self.startDay = startDay
        self.endDay = endDay
        self.dateRange = dateRange
        if startDay == "" && endDay == ""{
            availableDate.text = "Choose the available dates"
        }else{
            availableDate.text = startDay + " to " + endDay
        }
        
        
    }
    func getAddress(streetName: String, lat: Double, lng: Double){
        self.locationBtn.setTitle(streetName, for: .normal)
        self.locationBtn.setTitleColor(UIColor(displayP3Red: 60.0/255.0, green: 128.0/255.0, blue: 247.0/255.0, alpha: 1.0), for: .normal)
        self.streetName = streetName
        self.lat = lat
        self.lng = lng
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleConfig()
        uploadImage()
        configTapGesture()
        fetchPersonalInfo()
    }
    
    
    func styleConfig(){
        // to place the status bar on the top of the table view
        self.tableView.contentInsetAdjustmentBehavior = .never
        
        // style for image view
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.cornerRadius = 10.0
        imageView.layer.masksToBounds = true
        
        // location button
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: locationBtn.frame.height - 1, width: locationBtn.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor(displayP3Red: 196.0/255.0, green: 196.0/255.0, blue: 198.0/255.0, alpha: 1.0).cgColor
        locationBtn.layer.addSublayer(bottomLine)
        
        
        // set bottom line for text input field
        for field in textFieldCollection{
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0.0, y: field.frame.height - 1, width: field.frame.width, height: 1.0)
            bottomLine.backgroundColor = UIColor(displayP3Red: 196.0/255.0, green: 196.0/255.0, blue: 198.0/255.0, alpha: 1.0).cgColor
            field.borderStyle = UITextField.BorderStyle.none
            field.layer.addSublayer(bottomLine)
            
        }
        
        // pick view
        pickerView.backgroundColor = UIColor(displayP3Red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 0.3)
        pickerView.setValue(UIColor(displayP3Red: 60.0/255.0, green: 128.0/255.0, blue: 247.0/255.0, alpha: 1.0), forKeyPath: "textColor")
        
        // list btn
        listBtn.setBtnStyle()
        
    }
    func resetLabelColor(){
        for label in labelCollection{
            if label.tag == 9 || label.tag == 10{
                label.textColor = UIColor(displayP3Red: 60.0/255.0, green: 128.0/255.0, blue: 247.0/255.0, alpha: 1.0)
            }else{
                label.textColor = UIColor.black
            }
        }
    }
    func uploadImage(){
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageTap)))
        
        imageView.isUserInteractionEnabled = true
        
    }
    @objc func handleImageTap(){
        print("image Tapped")
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .photoLibrary
        image.allowsEditing = false
        
        self.present(image,animated: true){
            
        }
    }
    @objc func handleTap(){
        view.endEditing(true)
    }
    func configTapGesture(){
        let tapGesture = UITapGestureRecognizer(target:  self, action: #selector(UploadTableViewController.handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    func backToHome(){
        
        let TabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
        
        self.view.window?.rootViewController = TabBarController
        self.view.window?.makeKeyAndVisible()
    }
    func displayDefaultAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {action in self.backToHome()})
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    func saveImgTofirebase(completion:  @escaping (URL?) -> ()){
        guard let img = imageView.image else {return}
        guard  let imgData = img.jpegData(compressionQuality: 1) else {return}
        
        let uploadImgRef = imageRef.child(imgFileName!)
        let uploadTask = uploadImgRef.putData(imgData, metadata: nil){
            (metaData, error) in
            print(metaData ?? "No metaData")
            print(error ?? "No error")
            uploadImgRef.downloadURL{
                (url, error) in
                if let error = error {
                    print(error)
                }else{
                    completion(url)
                }
                
            }
            
        }
        
        uploadTask.observe(.progress){
            (snapshot) in
            print(snapshot.progress ?? "No more progress ")
            
        }
        
        
        uploadTask.resume()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            imageView.image = image
            carImage = image
        }else{
            print("cannot upload image")
        }
        
        if let imageURL = info[UIImagePickerController.InfoKey.phAsset] as? URL{
            let result = PHAsset.fetchAssets(withALAssetURLs: [imageURL], options: nil)
            let asset = result.firstObject
            
            self.imgFileName = asset?.value(forKey: "filename") as? String
            print(self.imgFileName!)
            
        }else{
            imgFileName = "random_name"
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as! HeaderView
        
        headerView.headerTitle.text = headerTitle[section]
        headerView.addShadow()
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    
    @IBAction func priceSlided(_ sender: UISlider) {
        priceLabel.text = String(Int(sender.value))
    }
    
    @IBAction func listBtnTapped(_ sender: Any) {
        print("list btn tapped")
        resetLabelColor()
        self.view.isUserInteractionEnabled = false
        let err = errorChecking()
        if err{
            let controller = UIAlertController(title: "Error in listing car!", message: "Please fill the missing fields", preferredStyle: .alert)
            let refillAction = UIAlertAction(title: "Try again", style: .default, handler: nil)
            controller.addAction(refillAction)
            present(controller, animated: true, completion: nil)
            self.tableView.setContentOffset(CGPoint.zero, animated:true)
            self.view.isUserInteractionEnabled = true
        }else{
            let uid = Auth.auth().currentUser?.uid
            let dbReference = Database.database().reference()
            let itemId = dbReference.child("carjson").childByAutoId().key
            saveImgTofirebase{(url) in
                if let url = url{
                    //print(url)
                    let imageURL = url.absoluteString
                    print(imageURL)
                    
                    
                    let dic:[String: Any] = ["id": itemId ?? "Cannot get auto id",
                                             "ownerId": uid!,
                                             "orderId": "",
                                             "address": [
                                                "streetname": self.streetName!,
                                                "lat": self.lat!,
                                                "lng": self.lng!
                        ],
                                             "cars":[
                                                "year": self.yearField.text!,
                                                "brand": self.brandTextField.text!,
                                                "model": self.modelTextField.text!,
                                                "size": self.seaterTexField.text!,
                                                "paint_color": self.colorField.text!,
                                                "image_url": imageURL,
                                                "transmission": self.transTextfield.text!,
                                                "type": self.typeTextfield.text!,
                                                "condition": true,
                                                "price": Int(self.priceLabel.text!) ?? 0
                        ]
                    ]
                    
                    dbReference.child("carjson").child(itemId!).setValue(dic)
                    self.updatePersonalListing()
                    print("upload success")
                    self.displayDefaultAlert(title: "Success!", message: "Your car has been listed on the app!")
                    self.view.isUserInteractionEnabled = true
                }else{
                    print("error no url")
                }
            }
            
        }
        
    }
    func fetchPersonalInfo(){
        let uid = Auth.auth().currentUser?.uid
        FireDataLoader().fetchUserInfo(userId: uid!) { (personInfo) in
            self.personInfo = personInfo
            print("get user info: \(self.personInfo!.firstName)")
        }
    }
   
    func updatePersonalListing(){
        let uid = Auth.auth().currentUser?.uid
        let dbRef = Database.database().reference()
        
       
        if let personInfo = personInfo{
            let dic: [String:Any] = ["email": personInfo.email,"firstName": personInfo.firstName, "lastName": personInfo.lastName, "phoneNumber": personInfo.phoneNumber, "gender": personInfo.gender, "dateOfBirth": personInfo.dateOfBirth, "countryCode": personInfo.countryCode, "renting": personInfo.renting, "listing": personInfo.listing + 1]
                
            dbRef.child("userinfo").child(uid!).updateChildValues(dic)
            print("update personal info successfully")
        }else{
            print("cannot fetch user info")
        }
        
            
        
        
    }
    
    func errorChecking() -> Bool{
        var err = false
        if brandTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            labelCollection[0].textColor = UIColor(displayP3Red: 255.0/255.0, green: 93.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            err = true
        }
        if modelTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            labelCollection[1].textColor = UIColor(displayP3Red: 255.0/255.0, green: 93.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            err = true
            
        }
        if carImage == nil{
            labelCollection[2].textColor = UIColor(displayP3Red: 255.0/255.0, green: 93.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            err = true
        }
        if streetName == nil || lat == nil || lng == nil{
            labelCollection[3].textColor = UIColor(displayP3Red: 255.0/255.0, green: 93.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            err = true
        }
        if typeTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            labelCollection[4].textColor = UIColor(displayP3Red: 255.0/255.0, green: 93.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            err = true
        }
        if transTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            labelCollection[5].textColor = UIColor(displayP3Red: 255.0/255.0, green: 93.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            err = true
        }
        if seaterTexField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            labelCollection[6].textColor = UIColor(displayP3Red: 255.0/255.0, green: 93.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            err = true
        }
        if colorField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            labelCollection[7].textColor = UIColor(displayP3Red: 255.0/255.0, green: 93.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            err = true
        }
        if yearField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            labelCollection[8].textColor = UIColor(displayP3Red: 255.0/255.0, green: 93.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            err = true
        }
        if priceLabel.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            labelCollection[9].textColor = UIColor(displayP3Red: 255.0/255.0, green: 93.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            err = true
        }
        if startDay == ""{
            labelCollection[10].textColor = UIColor(displayP3Red: 255.0/255.0, green: 93.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            err = true
        }
        
        return err
    }
    
    
    @IBAction func calendarTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "PopupDateViewController") as! PopupDateViewController
        vc.uploadDelegate = self
        
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func loactionBtnTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "MapViewController") as! MapViewController
        vc.addressDelegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension UploadTableViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        currentTextField = textField
        
        
        if currentTextField == typeTextfield{
            currentTextField.inputView = pickerView
        }else if currentTextField == transTextfield{
            currentTextField.inputView = pickerView
        }else if currentTextField == seaterTexField{
            currentTextField.inputView = pickerView
        }else if currentTextField == colorField{
            currentTextField.inputView = pickerView
        }else if currentTextField == yearField{
            currentTextField.inputView = pickerView
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension UploadTableViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == typeTextfield{
            return typeSelection.count
        }else if currentTextField == transTextfield{
            return transmissionSelection.count
        }else if currentTextField == seaterTexField{
            return seaterSelection.count
        }else if currentTextField == colorField{
            return colorSelection.count
        }else if currentTextField == yearField{
            return yearSelection.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == typeTextfield{
            return typeSelection[row]
        }else if currentTextField == transTextfield{
            return transmissionSelection[row]
        }else if currentTextField == seaterTexField{
            return seaterSelection[row]
        }else if currentTextField == colorField{
            return colorSelection[row]
        }else if currentTextField == yearField{
            return yearSelection[row]
        }else{
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentTextField == typeTextfield{
            typeTextfield.text = typeSelection[row]
            self.view.endEditing(true)
        }else if currentTextField == transTextfield{
            transTextfield.text = transmissionSelection[row]
            self.view.endEditing(true)
        }else if currentTextField == seaterTexField{
            seaterTexField.text = seaterSelection[row]
            self.view.endEditing(true)
        }else if currentTextField == colorField{
            colorField.text = colorSelection[row]
            self.view.endEditing(true)
        }else if currentTextField == yearField{
            yearField.text = yearSelection[row]
            self.view.endEditing(true)
        }
    }
}
