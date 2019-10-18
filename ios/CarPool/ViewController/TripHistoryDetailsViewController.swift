//
//  TripHistoryDetailsViewController.swift
//  CarPool
//
//  Created by GeoSpark Mac #1 on 02/10/19.
//  Copyright © 2019 GeoSpark, Inc. All rights reserved.
//

import UIKit
import GoogleMaps
import GeoSpark

class TripHistoryDetailsViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    var tripDetails:TripHistoryTrip?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Completed trip"
        
        GeoSpark.getCurrentLocation(100) { (location) in
            let camera = GMSCameraPosition.camera(withLatitude: location.latitude ,longitude: location.longitude, zoom: 18)
            self.mapView.camera = camera
        }
        
        if tripDetails?.origins.count != 0 && tripDetails?.destinations.count != 0{
            for origin in (tripDetails?.origins.enumerated())! {
                self.drawLine(origin.element.coordinates, (tripDetails?.destinations[origin.offset].coordinates)!, origin.offset)
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.setHidesBackButton(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    static public func viewController() -> TripHistoryDetailsViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logsDisplayVC = storyBoard.instantiateViewController(withIdentifier: "TripHistoryDetailsViewController") as! TripHistoryDetailsViewController
        return logsDisplayVC
    }
    
    
    func drawLine(_ origin:[Double], _ destination:[Double], _ index:Int){
        DispatchQueue.main.async {
            let originCoor = CLLocationCoordinate2D(latitude: origin.last!, longitude: origin.first!)
            let destCoor = CLLocationCoordinate2D(latitude: destination.last!, longitude: destination.first!)
            self.draw(originCoor, destCoor)
            let originMarker = GMSMarker(position: originCoor)
            let destinationMarker = GMSMarker(position: destCoor)
            originMarker.icon = UIImage(named: "origin_marker")
            originMarker.title = "\("user origion \(index)")"
            destinationMarker.icon = UIImage(named: "destination_marker")
            destinationMarker.title = "\("user destination \(index)")"
            originMarker.map = self.mapView
            destinationMarker.map = self.mapView
        }
    }
    
    func draw(_ origin:CLLocationCoordinate2D,_ destination:CLLocationCoordinate2D){
        let originStr = Utils.coordinateString(origin)
        let destStr = Utils.coordinateString(destination)
          DataManager.sharedInstance.drawGoogleLine(originStr, destStr, { (dict) in
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
              print("error:\(error)")
          }
    }
    
}
