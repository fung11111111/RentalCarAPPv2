//
//  CarListViewController.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 31/1/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit

protocol searchItemDelegate {
    func getItem(itemName: String)
    
}

class CarListViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate, searchItemDelegate {
    func getItem(itemName: String) {
        var predictItem = itemName.split(separator: " ")
      
        predictedCarBrand = String(predictItem.removeFirst())
        predictedCarYr = String(predictItem.popLast()!)
        predictedCarType = String(predictItem.popLast()!)
        
        
        var model = ""
        for txt in predictItem{
            model += txt
        }
        
     
        
        print(model)
        isSearching = true
        mySearchBar.text = itemName
        self.searchBar(mySearchBar, textDidChange: model)
        print(searchingArr.count)
       
        if searchingArr.count == 0{
        
            recommendBtn.alpha = 1.0
        }
    
    }
    
    
    
    @IBOutlet weak var mySearchBar: UISearchBar!
    
   
    @IBOutlet weak var recommendBtn: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var listCollectionView: UICollectionView!
    @IBOutlet weak var headerView: customUIView!
    @IBOutlet var carmenuBtn: [CustomBtn]!
    @IBOutlet weak var barItem: UINavigationItem!
    
   
    var originDataArray: [ItemInfo] = []
    var dataArray: [ItemInfo] = []
    var searchingArr: [ItemInfo] = []
    var isSearching = false
    var predictedCarBrand: String?
    var predictedCarModel: String?
    var predictedCarYr: String?
    var predictedCarType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleConfig()
        fetchDataFromFirebase()
        configTapGesture()
        
      
    }
    func performSearch(txt: String){
        isSearching = true
        mySearchBar.text = txt
        self.searchBar(mySearchBar, textDidChange: txt)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching{
            return searchingArr.count
        }else{
            return dataArray.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "carlistcell", for: indexPath) as! CarlistcellCollectionViewCell
        
        if isSearching{
         
            cell.carImage?.sd_setImage(with: URL(string: searchingArr[indexPath.row].car.image_url), placeholderImage: nil, options: .handleCookies, completed: nil)
            cell.carName.text = searchingArr[indexPath.row].car.brand
            cell.carModel.text = searchingArr[indexPath.row].car.model
            cell.size.text = searchingArr[indexPath.row].car.size
            cell.year.text = searchingArr[indexPath.row].car.year
            cell.price.text = String(searchingArr[indexPath.row].car.price) + "/Day"
            cell.transmission.text = searchingArr[indexPath.row].car.transmission
            cell.ratingLabel.text = "7.5"
        }else{
            
            cell.carImage?.sd_setImage(with: URL(string: dataArray[indexPath.row].car.image_url), placeholderImage: nil, options: .handleCookies, completed: nil)
            cell.carName.text = dataArray[indexPath.row].car.brand
            cell.carModel.text = dataArray[indexPath.row].car.model
            cell.size.text = dataArray[indexPath.row].car.size
            cell.year.text = dataArray[indexPath.row].car.year
            cell.price.text = String(dataArray[indexPath.row].car.price) + "/Day"
            cell.transmission.text = dataArray[indexPath.row].car.transmission
            cell.ratingLabel.text = "7.5"
            
        }
        cell.styleConfig()
        return cell
    }
    @IBAction func searchImgTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SearchByImageViewController") as! SearchByImageViewController
        
        vc.singleItemDelegate = self
        present(vc,animated: true,completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //   let mainStoryBoard: UIStoryboard = UIStoryboard(name: "main", bundle: nil)
        let singleItemVC = storyboard?.instantiateViewController(identifier: "SingleItemViewController") as? SingleItemViewController
        
        
        if isSearching{
            singleItemVC?.itemInfo = searchingArr[indexPath.row]
        }else{
            singleItemVC?.itemInfo = dataArray[indexPath.row]
        }
        
        self.navigationController?.pushViewController(singleItemVC!, animated: true)
        
    }
    @objc func handleTap(){
        view.endEditing(true)
        
    }
    func configTapGesture(){
        let tapGesture = UITapGestureRecognizer(target:  self, action: #selector(PersonalInfoTableViewController.handleTap))
        
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @IBAction func searchSimilar(_ sender: Any) {
        performSearch(txt: predictedCarBrand!)
        if searchingArr.count == 0 {
            mySearchBar.text = "Sorry! There is no similar cars."
        }
        recommendBtn.alpha = 0
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
        print("allow searching")
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      
        searchingArr = dataArray.filter({$0.car.model.lowercased().trimmingCharacters(in: .whitespaces).prefix(searchText.count) == searchText.lowercased().trimmingCharacters(in: .whitespaces) || $0.car.brand.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.car.year.prefix(searchText.count) == searchText || $0.car.transmission.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.car.paint_color.lowercased().prefix(searchText.count) == searchText.lowercased() || $0.car.type.lowercased().prefix(searchText.count) == searchText.lowercased() })
        
        listCollectionView.reloadData()
        
    }
    
    
    
    
    func styleConfig(){
        // header view
        headerView.setGradientBackground(colorOne: UIColor(red: 8.0/255.0, green: 74.0/255.0, blue: 196.0/255.0, alpha: 1.0),colorTwo: UIColor(red: 84.0/255.0, green: 144.0/255.0, blue: 248.0/255.0, alpha: 1.0))
        
        
        // show activity indicator
        activityIndicator.hidesWhenStopped = false
        
        // menu bar item
        menuBarConfig()
    }
    @IBAction func carmenuBtnTapped(_ sender: UIButton) {
        // tag0 = all 
        // tag1 = Sedan
        // tag2 = Coupe
        // tag3 = Truck
        // tag4 = SUV
        
        let tag = sender.tag
        isSearching = false
        for btn in carmenuBtn{
            if tag == btn.tag{
                btn.addBottomBorder()
                btn.titleLabel?.font = UIFont(name: "Noto Sans Myanmar", size: 17.0)
                btn.alpha = 1.0
                
            }else{
                btn.titleLabel?.font = UIFont(name: "Noto Sans Myanmar", size: 15.0)
                btn.alpha = 0.5
                if (btn.checkSize() >= 2) {
                    btn.removeBottomBorder()
                }
            }
            
        }
        if tag == 0{
            dataArray = originDataArray
            listCollectionView.reloadData()
        }else if tag == 1{
            dataArray = originDataArray.filter{
                $0.car.type == "sedan"
            }
            listCollectionView.reloadData()
        }else if tag == 2{
            dataArray = originDataArray.filter{
                $0.car.type == "coupe"
            }
            listCollectionView.reloadData()
        }else if tag == 3{
            dataArray = originDataArray.filter{
                $0.car.type == "truck"
            }
            listCollectionView.reloadData()
        }else if tag == 4 {
            dataArray = originDataArray.filter{
                $0.car.type == "SUV"
            }
            listCollectionView.reloadData()
        }
    }
    func menuBarConfig(){
        for btn in carmenuBtn{
            if btn.tag == 0{
                btn.alpha = 1.0
                btn.titleLabel?.font = UIFont(name: "Noto Sans Myanmar", size: 17.0)
                btn.addBottomBorder()
            }else{
                btn.alpha = 0.5
                btn.titleLabel?.font = UIFont(name: "Noto Sans Myanmar", size: 15.0)
            }
        }
    }
    
    func fetchDataFromFirebase(){
        displayActivityIndicator(turnOn: true)
        FireDataLoader().fectchData{
            (result) in
            // DispatchQueue.main.async {
            self.displayActivityIndicator(turnOn: false)
            self.originDataArray = result.filter{$0.car.condition == true}
            self.dataArray = self.originDataArray
            self.listCollectionView.reloadData()
            // }
        }
        
    }
    
    func displayActivityIndicator(turnOn: Bool){
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.init(displayP3Red: 0.0/255.0, green: 82.0/255.0, blue: 204.0/255.0, alpha: 1.0)
        
        if turnOn{
            activityIndicator.startAnimating()
            view.isUserInteractionEnabled = false
        }else{
            
            activityIndicator.stopAnimating()
            view.isUserInteractionEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
  
}
