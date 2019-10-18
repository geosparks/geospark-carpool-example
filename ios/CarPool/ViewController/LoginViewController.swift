//
//  ViewController.swift
//  CarPool
//
//  Created by GeoSpark Mac #1 on 25/09/19.
//  Copyright © 2019 GeoSpark, Inc. All rights reserved.
//

import UIKit
import GeoSpark

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userNameTextfield: UITextField!
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKey()
    }
    
    static public func viewController() -> LoginViewController {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let logsDisplayVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        return logsDisplayVC
    }

    @IBAction func getStarted(_ sender: Any) {
        
        let userName = userNameTextfield.text
        let phoneNumber = phoneNumberTextfield.text
        
        if userName!.isEmpty {
            Alert.alertController(title: "Enter UserName", message: nil, viewController: self)
        }else if phoneNumber!.isEmpty{
            Alert.alertController(title: "Enter PhoneNumber", message: nil, viewController: self)
        }else{
            showHud()
            DataManager.sharedInstance.getUser(phoneNumber!, { (getResponse) in
                if getResponse.status == false && getResponse.userId == nil{
                    GeoSpark.createUser(userName!, { (user) in
                        let dict = Utils.stringToDict(phoneNumber!, userName!, user.userId)
                        DataManager.sharedInstance.createUser(dict, { (response) in
                            if response.status == true{
                                self.enableEvent()
                                SharedUtil.setDefaultString(phoneNumber!, kUserPhone)
                                SharedUtil.setDefaultString(response.name, kUserName)
                                SharedUtil.setDefaultString(response.userId, kUserId)
                                SharedUtil.setDefaultBoolean(true, kIsfirstTime)
                                self.setNavigationCOntroller()
                            }
                            else{
                                self.showAlert(response.message, response.message)
                            }
                        }) { (error) in
                            self.showAlert(error.errorCode, error.errorMessage)
                        }
                    }) { (error) in
                        self.showAlert(error.errorCode, error.errorMessage)
                    }
                }else{
                    GeoSpark.getUser(getResponse.userId, { (user) in
                        DataManager.sharedInstance.getUser(phoneNumber!, { (getUser) in
                            if getUser.status == true{
                                self.enableEvent()
                                SharedUtil.setDefaultString(phoneNumber!, kUserPhone)
                                SharedUtil.setDefaultString(getUser.name, kUserName)
                                SharedUtil.setDefaultString(getUser.userId, kUserId)
                                SharedUtil.setDefaultBoolean(true, kIsfirstTime)
                                self.setNavigationCOntroller()
                            }else{
                                self.dismissHud()
                                self.showAlert(getUser.message, getUser.message)
                            }
                        }) { (error) in
                            self.dismissHud()
                            self.showAlert(error.errorCode, error.errorMessage)
                        }
                    }) { (error) in
                        self.dismissHud()
                        self.showAlert(error.errorCode, error.errorMessage)
                    }
                }
            }) { (getError) in
                self.showAlert(getError.errorCode, getError.errorMessage)
            }
        }
    }
    
    func setNavigationCOntroller(){
        DispatchQueue.main.async {
            self.dismissHud()
            let vc = MainViewController.viewController()
            self.window?.rootViewController = vc
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showAlert(_ title:String, _ message:String){
        DispatchQueue.main.async {
            self.dismissHud()
            Alert.alertController(title: title, message: message, viewController: self)
        }
    }
    
    func enableEvent(){
        GeoSpark.toggleEvents(Geofence: true, Trip: true, Activity: true, { (events) in
        }) { (error) in
        }
    }
}

extension LoginViewController:UITextFieldDelegate{
    
    func dismissKey()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 101 {
            return range.location < 10
        }
        return true
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
}

