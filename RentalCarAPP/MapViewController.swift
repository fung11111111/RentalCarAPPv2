//
//  MapViewController.swift
//  RentalCarAPP
//
//  Created by Fung Lam on 16/1/2020.
//  Copyright © 2020 Fung Lam. All rights reserved.
//

import UIKit
import MapKit
import Contacts
import CoreLocation
import FirebaseDatabase


class MapViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private let locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    
    //  @IBOutlet weak var navItem: UINavigationItem!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var directionBtn: CustomBtn!
    
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBOutlet weak var navBar: customNavBar!
    var dataArray = [ItemInfo]()
    var currentPlactmark: CLPlacemark?
    var previousAnnotation: MKPointAnnotation?
    var addressDelegate: addressDelegate?
    var streetName: String?
    var lat: Double?
    var lng: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        fetchDataFromFirebaseandConfig()
        styleConfig()
        
        if navigationController != nil{
            print("i have nav")
            navBar.isHidden = false
            let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
            mapView.addGestureRecognizer(longTapGesture)
            
        }
        
    }
    private func configLocationService(){
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined{
            locationManager.requestAlwaysAuthorization()
        }else if status == .authorizedAlways || status == .authorizedWhenInUse{
            beginLocationUpdates(locationManager: locationManager)
        }
        
    }
    private func zoomToLatestLocation(with coordinate:CLLocationCoordinate2D){
        
        let reionRadius: CLLocationDistance = 1000
        
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: reionRadius, longitudinalMeters: reionRadius)
        mapView.setRegion(region, animated: true)
    }
    private func beginLocationUpdates(locationManager: CLLocationManager){
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    private func addAnnotation(){
        
        print(self.dataArray.count)
        for data in self.dataArray{
            let carAnnotation = customAnnotation(data: data)
            self.mapView.addAnnotation(carAnnotation)
        }
        
        
    }
    private func fetchDataFromFirebaseandConfig(){
        FireDataLoader().fectchData{
            (result) in
            DispatchQueue.main.async {
                self.dataArray = result
                self.configLocationService()
            }
        }
        
    }
    private func waitForData(after microseconds: Int, completion: @escaping() -> Void){
        let deadline = DispatchTime.now() + .microseconds(microseconds)
        DispatchQueue.main.asyncAfter(deadline: deadline){
            completion()
        }
    }
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if let streetName = streetName{
            addressDelegate?.getAddress(streetName: streetName, lat: lat!, lng: lng!)
        }else{
            addressDelegate?.getAddress(streetName: "Add your location", lat: 0.0, lng: 0.0)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showDirection(sender: Any){
        print("tapped")
        guard  let currentPlacemark = currentPlactmark else {
            return
        }
        let directionRequest = MKDirections.Request()
        let destinationPlacemark = MKPlacemark(placemark: currentPlacemark)
        
        directionRequest.source = MKMapItem.forCurrentLocation()
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate{ (directionRsp, error) in
            guard let directionRsp = directionRsp else{
                if let error = error {
                    print(error)
                }
                print("no rsp")
                return
            }
            let route = directionRsp.routes[0]
            print(route)
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.addOverlay(route.polyline,level: .aboveRoads)
            
            let routeRect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(routeRect), animated: true)
        }
    }
    func styleConfig(){
        // draw direction btn
        directionBtn.setCircle()
        
        
        self.navBar.isHidden = true
        
    }
    
    @objc func longTap(sender: UIGestureRecognizer){
        print("long tap")
        if sender.state == .began {
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            
            let annotation = MKPointAnnotation()
            annotation.title = "Your Car"
            annotation.coordinate = locationOnMap
            lat = locationOnMap.latitude
            lng = locationOnMap.longitude
            let location = CLLocation(latitude: lat!, longitude: lng!)
            
            getPlacemark(forLocation: location) {
                (originPlacemark, error) in
                if let err = error {
                    print(err)
                } else if let placemark = originPlacemark {
                    var addressString = ""
                    
                    if let thoroughfare = placemark.thoroughfare{
                        addressString = addressString + thoroughfare + ", "
                    }
                    if let subLocality = placemark.subLocality{
                        addressString = addressString + subLocality + ", "
                    }
                    if let locality = placemark.locality{
                        addressString = addressString + locality + ", "
                    }
                    if let country = placemark.country{
                        addressString = addressString + country
                    }
                    print(addressString)
                    annotation.subtitle = addressString
                    self.navBarTitle.title = addressString
                    self.streetName = addressString
                    
                }
            }
            if let previousAnnotation = previousAnnotation{
                self.mapView.removeAnnotation(previousAnnotation)
            }
            
            self.mapView.addAnnotation(annotation)
            self.previousAnnotation = annotation
        }
    }
}
func getPlacemark(forLocation location: CLLocation, completionHandler: @escaping (CLPlacemark?, String?) -> ()) {
    let geocoder = CLGeocoder()
    
    geocoder.reverseGeocodeLocation(location, completionHandler: {
        placemarks, error in
        
        if let err = error {
            completionHandler(nil, err.localizedDescription)
        } else if let placemarkArray = placemarks {
            if let placemark = placemarkArray.first {
                completionHandler(placemark, nil)
            } else {
                completionHandler(nil, "Placemark was nil")
            }
        } else {
            completionHandler(nil, "Unknown error")
        }
    })
    
}





extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("get latest location")
        guard let latestLocation = locations.first else {return}
        
        if currentCoordinate == nil {
            zoomToLatestLocation(with: latestLocation.coordinate)
            addAnnotation()
            if self.navigationController != nil{
                getPlacemark(forLocation: latestLocation) {
                    (originPlacemark, error) in
                    if let err = error {
                        print(err)
                    } else if let placemark = originPlacemark {
                        var addressString = ""
                        if let thoroughfare = placemark.thoroughfare{
                            addressString = addressString + thoroughfare + ", "
                        }
                        if let subLocality = placemark.subLocality{
                            addressString = addressString + subLocality + ", "
                        }
                        if let locality = placemark.locality{
                            addressString = addressString + locality + ", "
                        }
                        if let country = placemark.country{
                            addressString = addressString + country
                        }
                        print(addressString)
                        
                        self.navBarTitle.title = addressString
                        self.streetName = addressString
                        self.lat = latestLocation.coordinate.latitude
                        self.lng = latestLocation.coordinate.longitude
                    }
                }
            }
        }
        
        
        
        currentCoordinate = latestLocation.coordinate
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("the status changed")
        beginLocationUpdates(locationManager: manager)
        
    }
    
    
}

extension MapViewController: MKMapViewDelegate{
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Annotation")
        if annotationView == nil{
            
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
        }
        if annotation === mapView.userLocation{
            return nil
        }else if annotation.title == "Your Car"{
            annotationView?.image = UIImage(named: "icons8-marker-30")
        }else{
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView?.image = UIImage(named: "cartoonCar_annotation")
            annotationView?.calloutOffset = CGPoint(x: -5, y: 5)
        }
        
        
        annotationView?.canShowCallout = true
        return annotationView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("selected annotation")
        directionBtn.alpha = 1.0
        if let location = view.annotation as? customAnnotation{
            self.currentPlactmark = MKPlacemark(coordinate: location.coordinate)
            
        }
        
    }
    func mapView (_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.mapView.removeOverlays(self.mapView.overlays)
        directionBtn.alpha = 0.0
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("tapped pin button")
        
        let location = view.annotation as? customAnnotation
        let singleItemVC = self.storyboard?.instantiateViewController(withIdentifier: "SingleItemViewController") as! SingleItemViewController
        singleItemVC.itemInfo = location?.userData
        
        self.present(singleItemVC, animated: true, completion: nil)
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print("generate route")
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(displayP3Red: 254.0/255.0, green: 149.0/255.0, blue: 17.0/255.0, alpha: 1.0)
        renderer.lineWidth = 8.0
        return renderer
    }
    
}
