//
//  DataManager.swift
//  CarPool
//
//  Created by GeoSpark Mac #1 on 26/09/19.
//  Copyright © 2019 GeoSpark, Inc. All rights reserved.
//

import Foundation

class DataManager: NSObject {
    
    static let sharedInstance = DataManager()
    
    func createUser(_ body:Dictionary<String,Any>,_ onSuccess: @escaping ((UserResponse) -> Void),onFailure: @escaping ((ErrorResponse) -> Void)){
        APIManager.sharedInstance.postMethodSession(kCREATE_USER, body, false, onSuccess: { (dict) in
            let response = UserResponse(fromDictionary: dict)
            onSuccess(response)
        }) { (errorMessage, errorCode) in
            onFailure(ErrorResponse("\(String(describing: errorCode))", errorMessage!.localizedDescription))
        }
    }
    func getUser(_ phoneString:String,_ onSuccess: @escaping ((UserResponse) -> Void),onFailure: @escaping ((ErrorResponse) -> Void)){
        APIManager.sharedInstance.getMethodSession(kGET_USER+phoneString, false, onSuccess: { (dict) in
            let response = UserResponse(fromDictionary: dict)
            onSuccess(response)
        }) { (errorMessage, errorCode) in
            onFailure(ErrorResponse("\(String(describing: errorCode))", errorMessage!.localizedDescription))
        }
    }
    
    func drawGoogleLine(_ origin:String,_ destination:String,_ onSuccess: @escaping ((Dictionary<String,Any>) -> Void), onFailure: @escaping ((ErrorResponse) -> Void)){
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\(GOOGLE_PATH_KEY)"
        APIManager.sharedInstance.getMethodSessionRoute(urlString, onSuccess: { (dict) in
            onSuccess(dict)
        }) { (error, errorCode) in
            onFailure(ErrorResponse("\(String(describing: errorCode))", (error?.localizedDescription)!))
        }
    }
    
    func createTrip(_ dict:Dictionary<String,Any>,_ onSuccess: @escaping (TripResponse) -> Void, onFailure: @escaping ((ErrorResponse) -> Void)){
        APIManager.sharedInstance.postMethodSession(kCREATE_TRIP_URL, dict, true, onSuccess: { (dict) in
            let response = TripResponse(fromDictionary: dict)
            if response.code == 200 || response.code == 201{
                onSuccess(TripResponse(fromDictionary: dict))
            }else{
                onFailure(ErrorResponse("\(String(describing: response.code))", response.msg))
            }
        }) { (error, errorCode) in
            onFailure(ErrorResponse("\(String(describing: errorCode))", (error?.localizedDescription)!))
        }
    }
    
    func tripHistory(_ onSuccess: @escaping ((TripHistory) -> Void), onFailure: @escaping ((ErrorResponse) -> Void)){
        let url = TRIP_HISTORY_URL + SharedUtil.getDefaultString(kUserId)
        APIManager.sharedInstance.getMethodSession(url, true, onSuccess: { (dict) in
            let response = TripHistory(fromDictionary: dict)
            if response.status == true{
                onSuccess(response)
            }else{
                onFailure(ErrorResponse("\(String(describing: response.code))", response.msg))
            }
        }) { (errorMessage, errorCode) in
            onFailure(ErrorResponse("\(String(describing: errorCode))", (errorMessage?.localizedDescription)!))
        }
    }
    
    func findARide(_ dict:Dictionary<String,Any>,_ onSuccess: @escaping ((RideResponse) -> Void), onFailure: @escaping ((ErrorResponse) -> Void)){
        APIManager.sharedInstance.postMethodSession(kFIND_RIDE, dict, false, onSuccess: { (dict) in
            let response = RideResponse(fromDictionary: dict)
            if response.status == true{
                onSuccess(response)
            }else{
                onFailure(ErrorResponse(response.message, response.message))
            }
        }) { (errorMessage, errorCode) in
            onFailure(ErrorResponse("\(String(describing: errorCode))", (errorMessage?.localizedDescription)!))
        }
    }
    
    func getAllUserProvider(_ onSuccess: @escaping ((GetUserProviderResponse) -> Void), onFailure: @escaping ((ErrorResponse) -> Void)){
        APIManager.sharedInstance.getMethodSession(kGET_ALL_USER_PROVIDERS, false, onSuccess: { (dict) in
            let response = GetUserProviderResponse(fromDictionary: dict)
            if response.status == true {
                onSuccess(response)
            }else{
                onFailure(ErrorResponse(response.message, response.message))
            }
            
        }) { (errorMessage, errorCode) in
            onFailure(ErrorResponse("\(String(describing: errorCode))", (errorMessage?.localizedDescription)!))
        }
    }
    
    func getARide(_ dict:Dictionary<String,Any>,_ onSuccess: @escaping ((RideResponse) -> Void), onFailure: @escaping ((ErrorResponse) -> Void)){
        APIManager.sharedInstance.postMethodSession(kFIND_RIDE, dict, false, onSuccess: { (dict) in
            let response = RideResponse(fromDictionary: dict)
            if response.status == true{
                onSuccess(response)
            }else{
                onFailure(ErrorResponse(response.message, response.message))
            }
        }) { (errorMessage, errorCode) in
            onFailure(ErrorResponse("\(String(describing: errorCode))", (errorMessage?.localizedDescription)!))
        }
    }
    
    func getAllUserRequest(_ onSuccess: @escaping ((GetUserRequestResponse) -> Void), onFailure: @escaping ((ErrorResponse) -> Void)){
        APIManager.sharedInstance.getMethodSession(kGET_ALL_USER_REQUEST, false, onSuccess: { (dict) in
            let response = GetUserRequestResponse(fromDictionary: dict)
            if response.status == true {
                onSuccess(response)
            }else{
                onFailure(ErrorResponse(response.message, response.message))
            }
        }) { (errorMessage, errorCode) in
            onFailure(ErrorResponse("\(String(describing: errorCode))", (errorMessage?.localizedDescription)!))
        }
    }
    
    func getTripDetailUsingTripId(_ onSuccess: @escaping (TripResponse) -> Void, _  onFailure: @escaping ((ErrorResponse) -> Void)){
        let url = TRIP_API + SharedUtil.getDefaultString(kTripId)
        APIManager.sharedInstance.getMethodSession(url, true, onSuccess: { (dict) in
            let response = TripResponse(fromDictionary: dict)
            if response.status == true{
                onSuccess(response)
            }else{
                onFailure(ErrorResponse("\(String(describing: response.code))", response.msg))
            }
        }) { (errorMessage, errorCode) in
            onFailure(ErrorResponse("\(String(describing: errorCode))", (errorMessage?.localizedDescription)!))
        }
    }
    
    func updateTripDetails(_ dict:Dictionary<String,Any>,_ onSuccess: @escaping (TripResponseUpdate) -> Void, _  onFailure: @escaping ((ErrorResponse) -> Void)){
        APIManager.sharedInstance.putMethodSession(UPDATE_TRIP_API, dict, true, onSuccess: { (dict) in
            let response = TripResponseUpdate(fromDictionary: dict)
            if response.status == true{
                onSuccess(response)
            }else{
                onFailure(ErrorResponse("\(String(describing: response.code))", response.msg))
            }
        }) { (errorMessage, errorCode) in
            onFailure(ErrorResponse("\(String(describing: errorCode))", (errorMessage?.localizedDescription)!))
        }
    }
    
    func updateMetaData(_ dict:Dictionary<String,Any>,_ onSuccess: @escaping (TripResponseUpdate) -> Void, _  onFailure: @escaping ((ErrorResponse) -> Void)){
        APIManager.sharedInstance.putMethodSession(UPDATE_TRIP_API, dict, true, onSuccess: { (dict) in
            let response = TripResponseUpdate(fromDictionary: dict)
            if response.status == true{
                onSuccess(response)
            }else{
                onFailure(ErrorResponse("\(String(describing: response.code))", response.msg))
            }
        }) { (errorMessage, errorCode) in
            onFailure(ErrorResponse("\(String(describing: errorCode))", (errorMessage?.localizedDescription)!))
        }
    }
    func tripData(_ dict:Dictionary<String,Any>,_ onSuccess: @escaping (TripResponse) -> Void, _  onFailure: @escaping ((ErrorResponse) -> Void)){
        APIManager.sharedInstance.postMethodSession(TRIP_DATA, dict, true, onSuccess: { (dict) in
            let response = TripResponse(fromDictionary: dict)
            if response.status == true{
                onSuccess(response)
            }else{
                onFailure(ErrorResponse("\(String(describing: response.code))", response.msg))
            }
        }) { (errorMessage, errorCode) in
            onFailure(ErrorResponse("\(String(describing: errorCode))", (errorMessage?.localizedDescription)!))
        }
    }
    
    
    func tripMetaData(_ dict:Dictionary<String,Any>,_ onSuccess: @escaping (TripResponse) -> Void, _  onFailure: @escaping ((ErrorResponse) -> Void))
    {
        APIManager.sharedInstance.postMethodSession(TRIP_METADATA, dict, true, onSuccess: { (dict) in
            let response = TripResponse(fromDictionary: dict)
            if response.status == true{
                onSuccess(response)
            }else{
                onFailure(ErrorResponse("\(String(describing: response.code))", response.msg))
            }
        }) { (errorMessage, errorCode) in
            onFailure(ErrorResponse("\(String(describing: errorCode))", (errorMessage?.localizedDescription)!))
        }
    }
    
}
