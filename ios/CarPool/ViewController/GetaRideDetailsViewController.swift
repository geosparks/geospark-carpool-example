//
//  GetaRideDetailsViewController.swift
//  CarPool
//
//  Created by GeoSpark Mac #1 on 30/09/19.
//  Copyright © 2019 GeoSpark, Inc. All rights reserved.
//

import UIKit
import GeoSpark
import CoreLocation
import Toast_Swift

class GetaRideDetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var providers : [GetUserRequestResponseRequest] = []
    var tripId:String?
    var arrayCoordinates : [CLLocationCoordinate2D] = []
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Offer Ride To"
        
        let testUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "restart"), style: .plain, target: self, action: #selector(restartAction))
        let testUIBarButtonItem1 = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backAction))
        
        self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
        self.navigationItem.leftBarButtonItem  = testUIBarButtonItem1
        
        let nib = UINib(nibName: "FindARideTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "FindARideTableViewCell")
        
        self.loadData()
        
        self.updateDefaultTrip()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.setHidesBackButton(false, animated: true)
    }
    
    static public func viewController() -> GetaRideDetailsViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logsDisplayVC = storyBoard.instantiateViewController(withIdentifier: "GetaRideDetailsViewController") as! GetaRideDetailsViewController
        return logsDisplayVC
    }
    
    func loadData(){
        DataManager.sharedInstance.getAllUserRequest({ (reponse) in
            DispatchQueue.main.async {
                self.providers = reponse.request
                self.tableView.reloadData()
            }
        }) { (error) in
        }
    }
    
    @IBAction func startTrip(_ sender: Any) {
        showHud()
        let dict:Dictionary<String,Any> = ["trip_id":tripId!]
        DataManager.sharedInstance.tripMetaData(dict, { (response) in
            if response.status == true {
                DispatchQueue.main.async {
                    GeoSpark.startTrip(self.tripId!, "", { (trip) in
                        SharedUtil.setDefaultBoolean(true, kTripStarted)
                        if trip.msg! == "Trip Started Successfully."{
                            self.dismissHud()
                            DispatchQueue.main.async {
                                let vc = MyTripViewController.viewController()
                                self.window?.rootViewController = vc
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }else{
                            self.dismissHud()
                            Alert.alertController(title: nil, message: trip.msg!, viewController: self)
                        }
                    }) { (error) in
                        self.dismissHud()
                        Alert.alertController(title: nil, message: error.errorMessage, viewController: self)
                    }
                }
            }else{
                Alert.alertController(title: nil, message: response.msg, viewController: self)
                self.dismissHud()
            }
        }) { (error) in
            self.dismissHud()
            Alert.alertController(title: nil, message: error.errorMessage, viewController: self)
            
        }
    }
    
    @objc func restartAction(){
        self.loadData()
    }
    
    @objc func backAction(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func updateDefaultTrip(){
        let dict:Dictionary<String,Any> = ["user_id":SharedUtil.getDefaultString(kUserId),"trip_id":tripId!,"src_lat":(self.arrayCoordinates.first?.latitude)!,"src_lng":(self.arrayCoordinates.first?.longitude)!,"dest_lat":(self.arrayCoordinates.last?.latitude)!,"dest_lng":(self.arrayCoordinates.last?.longitude)!]
        DataManager.sharedInstance.tripData(dict, { (response) in
        }) { (error) in
            Alert.alertController(title: nil, message: error.errorMessage, viewController: self)
        }
    }
    
}
extension GetaRideDetailsViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if providers.count == 0 {
            self.tableView.setEmptyMessage(noRideRequest + noRideRequest1)
            return 0
        }
        self.tableView.restore()
        return self.providers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FindARideTableViewCell") as? FindARideTableViewCell
        let user = self.providers[indexPath.row]
        cell?.nameLabel.text =   "Name    : " + user.name!
        cell?.phoneLabel.text =  "Phone   : "  + "\(String(describing: user.phone!))"
        cell?.userIdLabel.text = "User Id : " + user.userId
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showHud()
        let user = self.providers[indexPath.row]
        self.updateTrip(user)
    }
    
    func updateTrip(_ user:GetUserRequestResponseRequest){
        let dict:Dictionary<String,Any> = ["user_id":user.userId!,"trip_id":tripId!,"src_lat":user.srcLat!,"src_lng":user.srcLng!,"dest_lat":user.destLat!,"dest_lng":user.destLng!]
        DataManager.sharedInstance.tripData(dict, { (response) in
            DispatchQueue.main.async {
                self.view.makeToast("Request Accepted")
                self.dismissHud()
            }
        }) { (error) in
            self.dismissHud()
            Alert.alertController(title: nil, message: error.errorMessage, viewController: self)
        }
    }
}
