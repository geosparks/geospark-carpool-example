//
//  TripHistoryViewController.swift
//  CarPool
//
//  Created by GeoSpark Mac #1 on 26/09/19.
//  Copyright © 2019 GeoSpark, Inc. All rights reserved.
//

import UIKit
import GeoSpark

class TripHistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var trips : [TripHistoryTrip] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Trip History"
        let nib = UINib(nibName: "TripHistoryTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TripHistoryTableViewCell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension


        loadData()
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
    
    
    static public func viewController() -> TripHistoryViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logsDisplayVC = storyBoard.instantiateViewController(withIdentifier: "TripHistoryViewController") as! TripHistoryViewController
        return logsDisplayVC
    }
    
    func loadData(){
        showHud()
        DataManager.sharedInstance.tripHistory({ (tripResponse) in
            DispatchQueue.main.async {
                self.dismissHud()
                self.trips  = tripResponse.data.trips
                self.tableView.reloadData()
            }
        }) { (error) in
            self.dismissHud()
            Alert.alertController(title: error.errorCode, message: error.errorMessage, viewController: self)
        }
    }
}

extension TripHistoryViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if trips.count == 0{
            self.tableView.setEmptyMessage("No trip created yet.")
            return 0
        }
        self.tableView.restore()
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TripHistoryTableViewCell") as? TripHistoryTableViewCell
        let trip = trips[indexPath.row]
        cell?.tripId.text = "Trip Id :" + trip.tripId
        cell?.tripStatus.text = "Trip Started :" + trip.tripStartedAt.fromUTCToLocalDate()
        cell?.tripStatus1.text = "Trip End :" + trip.tripEndedAt.fromUTCToLocalDate()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trip = trips[indexPath.row]
        let vc = TripHistoryDetailsViewController.viewController()
        vc.tripDetails = trip
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
