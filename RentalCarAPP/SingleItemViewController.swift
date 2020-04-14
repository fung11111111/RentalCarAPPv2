//
//  SingleItemViewController.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 10/2/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//
import SKCountryPicker
import UIKit
import PassKit
import FirebaseDatabase
import FirebaseAuth
protocol signleItemDateDelegate {
    func getDayValue(startDay: String, endDay:String,dateRange: [Date])
    
}


class SingleItemViewController: UITableViewController,signleItemDateDelegate{
    
    
    @IBOutlet weak var fNameField: UITextField!
    @IBOutlet weak var lNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    
    @IBOutlet var inputFieldCollection: [UITextField]!
    // ["fname", "lname", "email", "phone"]
    @IBOutlet weak var payBtn: CustomBtn!
    @IBOutlet weak var countryCodePicker: UIButton!
    @IBOutlet var itemTabelView: UITableView!
    @IBOutlet weak var dateRangeLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var carBrand: UILabel!
    @IBOutlet weak var carModel: UILabel!
    @IBOutlet weak var carSize: UILabel!
    @IBOutlet weak var carType: UILabel!
    @IBOutlet weak var carYear: UILabel!
    @IBOutlet weak var carTransmission: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var carLocation: UILabel!
    @IBOutlet weak var carImg: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var hkd: UILabel!
    @IBOutlet weak var gradientView0: customUIView!
    @IBOutlet weak var gradientView1: customUIView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var totalDates: UILabel!
    
    @IBOutlet weak var navTitle: customNavItem!
    
    var startDay = ""
    var endDay = ""
    var price = 0
    var dates = 1
    var dateRange = [Date]()
    var datetxt = ""
    var itemInfo: ItemInfo?
    var personalInfo: PersonalInfo? // user's name / email / phone no
    // protocol
    func getDayValue(startDay: String, endDay:String, dateRange: [Date]){
        self.startDay = startDay
        self.endDay = endDay
        self.dateRange = dateRange
        if startDay == "" {
            dateRangeLabel.text = "Please select dates"
        }else{
            datetxt = "\(startDay) to \(endDay)"
            dateRangeLabel.text = datetxt
            print("size of range: \(self.dateRange.count)")
            dates = dateRange.count
            totalDates.text = "Total: \(dates) days"
            totalPrice.text = String(itemInfo!.car.price*dates)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configTapGesture()
        showItemData()
        styleConfig()
        fetchPersonalInfo()
        
        
        
        
    }
    @objc func handleTap(){
        view.endEditing(true)
    }
    func configTapGesture(){
        let tapGesture = UITapGestureRecognizer(target:  self, action: #selector(UploadTableViewController.handleTap))
        view.addGestureRecognizer(tapGesture)
    }
    @IBAction func calendarTapped(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(identifier: "PopupDateViewController") as! PopupDateViewController
        vc.signleItemDateDelegate = self
        present(vc, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func countryCodeTapped(_ sender: Any) {
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
            
            guard let self = self else { return }
            
            //   self.countryImageView.image = country.flag
            self.countryCodePicker.setTitle(country.dialingCode, for: .normal)
            self.countryCodePicker.titleLabel?.font = UIFont(name: "Noto Sans Myanmar", size: 14)
            self.countryCodePicker.setTitleColor(UIColor.black, for: .normal)
            
        }
        
        // can customize the countryPicker here e.g font and color
        countryController.detailColor = UIColor.lightGray
        countryController.flagStyle = .circular
        
    }
    func showItemData() {
        
        if itemInfo != nil{
            carBrand.text = itemInfo!.car.brand
            carModel.text = itemInfo!.car.model
            carSize.text = "\(itemInfo!.car.size) seater"
            carType.text = itemInfo!.car.type
            carYear.text = itemInfo!.car.year
            carTransmission.text = itemInfo!.car.transmission
            carLocation.text = itemInfo!.address.streetname
            price = itemInfo!.car.price
            totalPrice.text = String(price*dates)
            carImg?.sd_setImage(with: URL(string: itemInfo!.car.image_url), placeholderImage: UIImage(named: "icons8-car-100"), options: .handleCookies, completed: nil)
        }
        
        
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
    func styleConfig(){
        // show nav bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        
        // imageview
        carImg.layer.cornerRadius = 10
        carImg.layer.masksToBounds = true
        
        // rating label
        ratingLabel.layer.cornerRadius = 5
        ratingLabel.layer.masksToBounds = true
        
        buttonSyleConfig()
        inputFieldStyleConfig()
        
        // gradient label
        let color1 = UIColor(red: 255.0/255.0, green: 171.0/255.0, blue: 87.0/255.0, alpha: 1.0)
        let color2 = UIColor(red: 255.0/255.0, green: 95.0/255.0, blue: 121.0/255.0, alpha: 1.0)
        gradientView0.setGradientBackground(colorOne: color1, colorTwo: color2)
        gradientView1.setGradientBackground(colorOne: color1, colorTwo: color2)
        gradientView0.mask = hkd
        gradientView1.mask = totalPrice
        
        
    }
    func textFieldConfig(){
        if self.fNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            self.fNameField.text = personalInfo?.firstName
        }
        if self.lNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            self.lNameField.text = personalInfo?.lastName
        }
        if self.emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            self.emailField.text = personalInfo?.email
        }
        if self.phoneField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            self.phoneField.text = personalInfo?.phoneNumber
        }
        if self.countryCodePicker.title(for: .normal) == "country code"{
            self.countryCodePicker.setTitle(personalInfo?.countryCode, for: .normal)
        }
    }
    func buttonSyleConfig(){
        
        countryCodePicker.setImage(UIImage(named: "icons8-sort-down-20"), for: .normal)
        countryCodePicker.imageEdgeInsets = UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 1)
        
        // country code button
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: countryCodePicker.frame.height - 1, width: countryCodePicker.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor(displayP3Red: 196.0/255.0, green: 196.0/255.0, blue: 198.0/255.0, alpha: 1.0).cgColor
        countryCodePicker.layer.addSublayer(bottomLine)
        
        
        // payment button
        payBtn.setBtnStyle()
        
        
        
    }
    func errorChecking() -> Bool{
        var err = false
        if startDay.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            dateRangeLabel.textColor = UIColor(displayP3Red: 255.0/255.0, green: 93.0/255.0, blue: 0.0/255.0, alpha: 1.0)
            err = true
        }
        if countryCodePicker.titleLabel?.text! == "country code"{
            errorLabel.text = "Please add the country code!"
            errorLabel.alpha = 1.0
            err = true
        }
        if fNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            errorLabel.text = "Please fill the your first name!"
            errorLabel.alpha = 1.0
            err = true
        }
        if lNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            errorLabel.text = "Please fill the your last name!"
            errorLabel.alpha = 1.0
            err = true
        }
        if emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            errorLabel.text = "Please fill the your email!"
            errorLabel.alpha = 1.0
            err = true
        }
        if phoneField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            errorLabel.text = "Please fill the phone number!"
            errorLabel.alpha = 1.0
            err = true
        }
        return err
    }
    func inputFieldStyleConfig(){
        for field in inputFieldCollection{
            let bottomLine = CALayer()
            bottomLine.frame = CGRect(x: 0.0, y: field.frame.height - 1, width: field.frame.width, height: 1.0)
            bottomLine.backgroundColor = UIColor(displayP3Red: 196.0/255.0, green: 196.0/255.0, blue: 198.0/255.0, alpha: 1.0).cgColor
            field.borderStyle = UITextField.BorderStyle.none
            field.layer.addSublayer(bottomLine)
        }
        
    }
    func resetStyle(){
        errorLabel.alpha = 0
        dateRangeLabel.textColor = UIColor(displayP3Red: 60.0/255.0, green: 128.0/255.0, blue: 247.0/255.0, alpha: 1.0)
    }
    func createOrder(){
        let uid = Auth.auth().currentUser?.uid
        let dbRef = Database.database().reference()
        let orderId = dbRef.child("order").childByAutoId().key
        if let itemInfo = itemInfo{
            let dic: [String: Any] = ["orderId": orderId!,
                                      "renterId": uid!,
                                      "carId": itemInfo.id,
                                      "duration": datetxt,
                                      "totalPrice": itemInfo.car.price*dates
            ]
            dbRef.child("order").child(orderId!).setValue(dic)
        }else{
            print("no itemInfo")
        }
        
    }
    func fetchPersonalInfo(){
        let uid = Auth.auth().currentUser?.uid
        
        FireDataLoader().fetchUserInfo(userId: uid!) { (personalInfo) in
            self.personalInfo = personalInfo
            self.textFieldConfig()
            
        }
    }
    func updateItemStatus(){
        
        let dbRef = Database.database().reference()
        
        if let itemInfo = itemInfo{
            let dic: [String: Any] = ["id" : itemInfo.id,
                                      "ownerId" : itemInfo.ownerId,
                                      "orderId": "",
                                      "address": ["lat" : itemInfo.address.lat,
                                                  "lng" : itemInfo.address.lng,
                                                  "streetname" : itemInfo.address.streetname
                ],
                                      "cars": ["brand" : itemInfo.car.brand,
                                               "condition" : false,
                                               "image_url" : itemInfo.car.image_url,
                                               "model" : itemInfo.car.model,
                                               "paint_color" : itemInfo.car.paint_color,
                                               "price" : itemInfo.car.price,
                                               "size" : itemInfo.car.size,
                                               "transmission" : itemInfo.car.transmission,
                                               "type" : itemInfo.car.type,
                                               "year" : itemInfo.car.year]
                
            ]
            
            dbRef.child("carjson").child(itemInfo.id).updateChildValues(dic)
            print("upload successfully")
        }else{
            print("cannot fetch iteminto data")
        }
        
        
    }
    func updatePersonalRenting(){
        let uid = Auth.auth().currentUser?.uid
        let dbRef = Database.database().reference()
        
        
        let dic: [String:Any] = ["email": emailField.text!,"firstName": fNameField.text!, "lastName": lNameField.text!, "phoneNumber": phoneField.text!, "gender": personalInfo!.gender, "dateOfBirth": personalInfo!.dateOfBirth, "countryCode": countryCodePicker.titleLabel!.text ?? "852", "renting": personalInfo!.renting + 1, "listing": personalInfo!.listing]
        
        dbRef.child("userinfo").child(uid!).updateChildValues(dic)
        print("update personal info successfully")
        
        
        
    }
    @IBAction func payBtnTapped(_ sender: Any) {
        
        let err = errorChecking()
        if err{
            // displayDefaultAlert(title: "Cannot make payment", message: "Please fill the missing fields")
            self.tableView.setContentOffset(CGPoint.zero, animated:true)
            
        }else{
            resetStyle()
            
            if let item = itemInfo{
                let itemName = item.car.brand + " " + item.car.model
                let itemPrice = Double(totalPrice.text!)
                let paymentItem = PKPaymentSummaryItem.init(label: itemName, amount: NSDecimalNumber(value: itemPrice!))
                let paymentNetworks = [PKPaymentNetwork.amex, .discover, .masterCard, .visa]
                
                if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
                    let request = PKPaymentRequest()
                    request.currencyCode = "HKD"
                    request.countryCode = "HK"
                    request.merchantIdentifier = "merchant.com.flam.RentalCarAPP"
                    request.merchantCapabilities = PKMerchantCapability.capability3DS
                    request.supportedNetworks = paymentNetworks
                    request.paymentSummaryItems = [paymentItem]
                    guard let paymentVC = PKPaymentAuthorizationViewController(paymentRequest: request) else {
                        displayDefaultAlert(title: "Error", message: "Unable to present Apple Pay authorization.")
                        return
                    }
                    
                    paymentVC.delegate = self
                    self.present(paymentVC, animated: true, completion: nil)
                }else{
                    print("cannot make payment")
                    // the apple pay cannot be used in real device due to certificate problem
                    // here is to pretend the payment was made successfully
                    
                    updateItemStatus()
                    updatePersonalRenting()
                    createOrder()
                    displayDefaultAlert(title: "Success!", message: "The Apple Pay transaction was complete.")
                    
                }
            }else{
                print("Error: No Iteminfo")
                
                
            }
        }
    }
    
    
}

extension SingleItemViewController: PKPaymentAuthorizationViewControllerDelegate {
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        dismiss(animated: true, completion: nil)
    }
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        updateItemStatus()
        updatePersonalRenting()
        createOrder()
        dismiss(animated: true, completion: nil)
        displayDefaultAlert(title: "Success!", message: "The Apple Pay transaction was complete.")
    }
}
extension SingleItemViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
