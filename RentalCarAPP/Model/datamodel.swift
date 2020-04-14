//
//  datamodel.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 5/2/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import Foundation
import MapKit

class customAnnotation: NSObject, MKAnnotation{
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var userData: ItemInfo
    init(data: ItemInfo) {
        self.userData = data
        self.title = data.car.brand + " " + data.car.model
        self.subtitle = data.address.streetname
        self.coordinate = CLLocationCoordinate2D(latitude: data.address.lat, longitude: data.address.lng)
    }
    
    
    
}
class MyrentingCar{
    var itemInfo: ItemInfo?
    var order: Order?
    var ownerInfo: PersonalInfo?
    
    init(itemInfo: ItemInfo, order: Order, ownerInfo: PersonalInfo) {
        self.itemInfo = itemInfo
        self.order = order
        self.ownerInfo = ownerInfo
    }
}

class Order{
    var orderId: String
    var carId: String
    var renterId: String
    var duration: String
    var totalPrice: Int
    init(orderId: String, carId: String, renterId: String, duration: String, totalPrice: Int) {
        self.carId = carId
        self.orderId = orderId
        self.renterId = renterId
        self.duration = duration
        self.totalPrice = totalPrice
    }
    
}

class PersonalInfo{
    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: String
    var gender: String
    var dateOfBirth: String
    var countryCode: String
    var renting: Int
    var listing: Int
    init(firstName: String, lastName: String, email: String, phoneNumber: String, gender: String, dateOfBirth: String, countryCode: String, renting: Int, listing: Int){
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.gender = gender
        self.dateOfBirth = dateOfBirth
        self.countryCode = countryCode
        self.renting = renting
        self.listing = listing
    }
}
class ItemInfo{
    var id: String
    var car: Cars
    var address: Address
    var ownerId: String
    var orderId: String
    init(id: String, ownerId: String, orderId: String, car: Cars, address: Address){
        self.id = id
        self.car = car
        self.address = address
        self.ownerId = ownerId
        self.orderId = orderId
    }
}

class Address{
    var streetname: String
    var lat: Double
    var lng: Double
    
    init(streetname: String, lat: Double, lng: Double) {
        self.streetname = streetname
        self.lat = lat
        self.lng = lng
    }
  
}

class Cars{
    var year: String
    var brand: String
    var model: String
    var size: String
    var paint_color: String
    var image_url: String
    var transmission: String
    var type: String
    var condition: Bool
    var price: Int
    
    init(year: String, brand: String, model: String, size: String, paint_color: String, image_url: String,
         transmission: String, type: String, condition: Bool, price: Int) {
        self.year = year
        self.brand = brand
        self.model = model
        self.size = size
        self.paint_color = paint_color
        self.image_url = image_url
        self.transmission = transmission
        self.type = type
        self.condition = condition
        self.price = price
    }
}

class Predictions{
    var carName: String
    var accuracy: Double
    init(carName: String, accuracy: Double) {
        self.carName = carName
        self.accuracy = accuracy
    }
}
