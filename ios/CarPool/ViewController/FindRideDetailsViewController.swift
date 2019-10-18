//
//  FindRideDetailsViewController.swift
//  CarPool
//
//  Created by GeoSpark Mac #1 on 26/09/19.
//  Copyright © 2019 GeoSpark, Inc. All rights reserved.
//

import UIKit

class FindRideDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var providers : [GetUserProvider] = []
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Rides For you"
        
        let testUIBarButtonItem = UIBarButtonItem(image: UIImage(named: "restart"), style: .plain, target: self, action: #selector(restartAction))
        let testUIBarButtonItem1 = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(backAction))

        self.navigationItem.rightBarButtonItem  = testUIBarButtonItem
        self.navigationItem.leftBarButtonItem  = testUIBarButtonItem1

        let nib = UINib(nibName: "FindARideTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "FindARideTableViewCell")
        self.loadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.setHidesBackButton(false, animated: true)
    }

    static public func viewController() -> FindRideDetailsViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logsDisplayVC = storyBoard.instantiateViewController(withIdentifier: "FindRideDetailsViewController") as! FindRideDetailsViewController
        return logsDisplayVC
    }
    
    @objc func restartAction(){
        self.loadData()
//        self.navigationController?.popToRootViewController(animated: true)
    }

    func loadData(){
        DataManager.sharedInstance.getAllUserProvider({ (provider) in
            DispatchQueue.main.async {
                self.providers = provider.providers
                self.tableView.reloadData()
            }
        }) { (error) in
        }
    }
    @objc func backAction(){
        DispatchQueue.main.async {
            let vc = MyTripFindRideViewController.viewController()
            self.window?.rootViewController = vc
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }


}

extension FindRideDetailsViewController:UITableViewDelegate,UITableViewDataSource{
    
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
    
}
