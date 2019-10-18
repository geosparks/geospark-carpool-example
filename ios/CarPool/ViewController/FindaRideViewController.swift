//
//  FindaRideViewController.swift
//  CarPool
//
//  Created by GeoSpark Mac #1 on 26/09/19.
//  Copyright © 2019 GeoSpark, Inc. All rights reserved.
//

import UIKit
import GoogleMaps
import GeoSpark

class FindaRideViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var fromLocationTextField: UITextField!
    @IBOutlet weak var toLocationTextField: UITextField!
    
    var longPressRecognizer = UILongPressGestureRecognizer()
    var arrayCoordinates : [CLLocationCoordinate2D] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Find A Ride"
        
        longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                           action: #selector(self.longPress))
        longPressRecognizer.minimumPressDuration = 0.5
        longPressRecognizer.delegate = self
        
        mapView.addGestureRecognizer(longPressRecognizer)
        
        GeoSpark.getCurrentLocation(100) { (location) in
            let camera = GMSCameraPosition.camera(withLatitude: location.latitude ,longitude: location.longitude, zoom: 16)
            self.mapView.camera = camera
            let state_marker = GMSMarker()
            state_marker.position = camera.target
            state_marker.appearAnimation = .pop
            state_marker.icon = UIImage(named: "current-location-marker")
            state_marker.map = self.mapView
        }
    }
    
    static public func viewController() -> FindaRideViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logsDisplayVC = storyBoard.instantiateViewController(withIdentifier: "FindaRideViewController") as! FindaRideViewController
        return logsDisplayVC
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.setHidesBackButton(false, animated: true)
    }
    
    func getAddress(_ coord:CLLocationCoordinate2D){
        Utils.getAddressFromLatLon(coord) { (addressString) in
            DispatchQueue.main.async{
                if self.arrayCoordinates.count == 1 {
                    self.fromLocationTextField.text = addressString
                }else if self.arrayCoordinates.count == 2 {
                    self.toLocationTextField.text = addressString
                }else {
                    self.fromLocationTextField.text = addressString
                    self.toLocationTextField.text = ""
                }
            }
        }
    }
    
    func drawLine(){
        let origin = Utils.coordinateString(self.arrayCoordinates.first!)
        let destination = Utils.coordinateString(self.arrayCoordinates.last!)
        DataManager.sharedInstance.drawGoogleLine(origin, destination, { (dict) in
            DispatchQueue.main.async{
                let routes = dict["routes"] as! NSArray
                for route in routes
                {
                    let routeOverviewPolyline:NSDictionary = (route as! NSDictionary).value(forKey: "overview_polyline") as! NSDictionary
                    let points = routeOverviewPolyline.object(forKey: "points")
                    let path = GMSPath.init(fromEncodedPath: points! as! String)
                    let polyline = GMSPolyline.init(path: path)
                    polyline.strokeWidth = 2
                    let bounds = GMSCoordinateBounds(path: path!)
                    self.mapView!.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 30.0))
                    polyline.map = self.mapView
                }
            }
            
        }) { (error) in
        }
    }
    
    @IBAction func findRideAction(_ sender: Any) {
        
        if fromLocationTextField.text!.isEmpty || toLocationTextField.text!.isEmpty {
            Alert.alertController(title: "Please select ", message: "Source and desctination", viewController: self)
        }else{
            if Reachability.isConnectedToNetwork(){
                showHud()
                let dict:Dictionary<String,Any> = Utils.findARideDictionary(self.arrayCoordinates.first!, self.arrayCoordinates.last!)                
                DataManager.sharedInstance.findARide(dict, { (response) in
                    if response.status == true{
                        DispatchQueue.main.async {
                            SharedUtil.setDefaultString(self.fromLocationTextField.text!, kFromAddress)
                            SharedUtil.setDefaultString(self.toLocationTextField.text!, kToAddress)
                            SharedUtil.setDefaultBoolean(true, kTripRequest)
                            self.dismissHud()
                            let vc = FindRideDetailsViewController.viewController()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }else{
                        DispatchQueue.main.async {
                            self.dismissHud()
                            Alert.alertController(title: "Error", message: response.message, viewController: self)
                        }
                    }
                }) { (error) in
                    DispatchQueue.main.async {
                        self.dismissHud()
                        Alert.alertController(title: error.errorCode, message: error.errorMessage, viewController: self)
                    }
                }
            }else{
                DispatchQueue.main.async {
                    self.dismissHud()
                    Alert.alertController(title: netWorkCheckTitle, message: netWorkCheckMessage, viewController: self)
                }
                Alert.alertController(title: netWorkCheckTitle, message: netWorkCheckMessage, viewController: self)
            }
        }
    }
    
}
extension FindaRideViewController:UIGestureRecognizerDelegate{
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        if Reachability.isConnectedToNetwork(){
            if sender.state == .began {
                let newMarker = GMSMarker(position: mapView.projection.coordinate(for: sender.location(in: mapView)))
                if arrayCoordinates.count == 0 {
                    self.arrayCoordinates.append(newMarker.position)
                    newMarker.icon = UIImage(named: "origin_marker")
                }else if arrayCoordinates.count == 1 {
                    self.arrayCoordinates.append(newMarker.position)
                    newMarker.icon = UIImage(named: "destination_marker")
                    self.drawLine()
                }else {
                    self.arrayCoordinates.removeAll()
                    self.mapView.clear()
                    self.arrayCoordinates.append(newMarker.position)
                    newMarker.icon = UIImage(named: "origin_marker")
                }
                self.getAddress(newMarker.position)
                newMarker.map = mapView
            }
        }else{
            Alert.alertController(title: netWorkCheckTitle, message: netWorkCheckMessage, viewController: self)
        }
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool
    {
        return true
    }
    
}
