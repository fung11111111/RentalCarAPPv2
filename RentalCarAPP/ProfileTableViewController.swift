//
//  ProfileTableViewController.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 28/2/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit
import FirebaseAuth
import MessageUI

class ProfileTableViewController: UITableViewController{
    var personalInfo: PersonalInfo?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInsetAdjustmentBehavior = .never
        
        
        
        
    }
    
    
    func logout(){
        do {
            try Auth.auth().signOut()
            print ("signout")
            let customViewController = self.storyboard?.instantiateViewController(withIdentifier: "customViewController") as? customViewController
            
            self.view.window?.rootViewController = customViewController
            self.view.window?.makeKeyAndVisible()
        } catch let err {
            print(err)
        }
    }
    @IBAction func logoutTapped(_ sender: Any) {
        logoutAlert()
        
    }
    func sendEmail(){
        guard MFMailComposeViewController.canSendMail() else{
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["rentalCarSupport@rent.com"])
        composer.setSubject("Feedback about rental car")
        present(composer,animated: true)
        
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let headerView = Bundle.main.loadNibNamed("profileHeaderTableViewCell", owner: self, options: nil)?.first as! profileHeaderTableViewCell
            
            let uid = Auth.auth().currentUser?.uid
            FireDataLoader().fetchUserInfo(userId: uid!){
                (user) in
                self.personalInfo = user
                if let info = self.personalInfo{
                    headerView.nameLabel.text = "Hi \(info.firstName),"
                    headerView.emailLabel.text = info.email
                }else{
                    headerView.nameLabel.text = ""
                    headerView.emailLabel.text = ""
                }
                
            }
            
            headerView.addShadow()
            
            
            return headerView
        }
        else{
            
        }
        return nil
        
        
        
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.section)
        if indexPath.section == 1{
            if indexPath.row == 0{
                let vc = storyboard?.instantiateViewController(identifier: "PersonalInfoTableViewController") as? PersonalInfoTableViewController
                print("personal tapped")
                //  present(vc!, animated: true, completion: nil)
                self.navigationController?.pushViewController(vc!, animated: true)
            }else if indexPath.row == 2{
                let popup : PopupChangePwViewController = self.storyboard?.instantiateViewController(withIdentifier: "PopupChangePwViewController") as! PopupChangePwViewController
                
                self.navigationController!.modalPresentationStyle = UIModalPresentationStyle.formSheet
                self.navigationController!.setNavigationBarHidden(true, animated: true)
                
                self.present(popup, animated: true, completion: nil)
                
            }
        }else if indexPath.section == 2{
            if indexPath.row == 0{
                print(personalInfo?.renting)
                if personalInfo?.renting == 0{
                    print("You have not rented any item yet")
                    displayDefaultAlert(title: "No Renting Records", message: "You didn't rent any car!")
                }else{
                    print("can nav to next vc")
                    let vc = storyboard?.instantiateViewController(identifier: "MyRentingCarViewController") as! MyRentingCarViewController
                    
                    present(vc, animated: true, completion: nil)
                }
            }else if indexPath.row == 1{
                if personalInfo?.listing == 0{
                    print("You have not upload any item")
                    displayDefaultAlert(title: "No Uploading Records", message: "You didn't upload any car!")
                }else{
                    print("can nav to next vc")
                    let vc = storyboard?.instantiateViewController(identifier: "MyListingCarViewController") as! MyListingCarViewController
                    
                    present(vc, animated: true, completion: nil)
                }
            }
        }else if indexPath.section == 3{
            if indexPath.row == 1{
                sendEmail()
            }
        }
        
    }
    
    
    func displayDefaultAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    func logoutAlert() {
        let alert = UIAlertController(title: "Log out of \(personalInfo?.firstName ?? "this account")?", message: "", preferredStyle: .alert)
        let logoutAction = UIAlertAction(title: "Log Out", style: .default, handler: {action in self.logout()})
        alert.addAction(logoutAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}

extension ProfileTableViewController: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let err = error{
            print(err)
            dismiss(animated: true, completion: nil)
            return
        }
        switch result{
        case .cancelled:
            print("cancel")
        case .failed:
            print("failed")
        case .saved:
            print("saved")
        case .sent:
            print("sent")
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
