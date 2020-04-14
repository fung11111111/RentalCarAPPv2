//
//  MyListingCarViewController.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 10/3/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit
import FirebaseAuth

class MyListingCarViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    var listingCar: [ItemInfo] = []
    
   
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        styleConfig()
        fetchListingCar()
    }
  
    func styleConfig(){
      
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listingCar.count
        
    }
  

  

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mylistingcar", for: indexPath) as! MyListingCarCollectionViewCell
        
        var listingStatus = ""
        if listingCar[indexPath.row].car.condition{
            listingStatus = "Available"
            cell.status.textColor = UIColor(red: 44.0/255.0, green: 230.0/255.0, blue: 96.0/255.0, alpha: 1.0)
        }else{
            listingStatus = "Rented Out"
             cell.status.textColor = UIColor(red: 230.0/255.0, green: 44.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        }
                cell.imageView.sd_setImage(with: URL(string: listingCar[indexPath.row].car.image_url), placeholderImage: nil, options: .handleCookies, completed: nil)
                cell.brand.text = listingCar[indexPath.row].car.brand
                cell.model.text = listingCar[indexPath.row].car.model
                cell.size.text = listingCar[indexPath.row].car.size
                cell.year.text = listingCar[indexPath.row].car.year
                cell.transmission.text = listingCar[indexPath.row].car.transmission
                cell.price.text = "\(String(listingCar[indexPath.row].car.price)) /per day"
                cell.status.text = "Status: \(listingStatus)"
                cell.id.text = "Listing ID: \(listingCar[indexPath.row].id)"
        
        cell.styleConfig()
        return cell
    }
    
    
    
    func fetchListingCar(){
        let uid = Auth.auth().currentUser?.uid
        
        FireDataLoader().fetchListingCar(userId: uid!){(listingCars) in
            self.listingCar = listingCars
            print(self.listingCar.count)
            self.collectionView.reloadData()
        }
    }
    
}
