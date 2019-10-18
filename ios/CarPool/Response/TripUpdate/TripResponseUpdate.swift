//
//  TripResponseUpdateRootClass.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on October 1, 2019

import Foundation


class TripResponseUpdate: NSObject{

    var code : Int!
    var msg : String!
    var status : Bool!


    var createdAt : String!
    var destinations : [TripResponseUpdateDestination]!
    var id : String!
    var isDeleted : Bool!
    var isEnded : Bool!
    var isPaused : Bool!
    var isStarted : Bool!
    var origins : [TripResponseUpdateOrigin]!
    var updatedAt : String!
    var userId : String!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        code = dictionary["code"] as? Int
        msg = dictionary["msg"] as? String
        status = dictionary["status"] as? Bool
        if let dataArray = dictionary["data"] as? [[String:Any]]{
            let dataArryDict = dataArray[0]
            createdAt = dataArryDict["created_at"] as? String
            id = dataArryDict["id"] as? String
            isDeleted = dataArryDict["is_deleted"] as? Bool
            isEnded = dataArryDict["is_ended"] as? Bool
            isPaused = dataArryDict["is_paused"] as? Bool
            isStarted = dataArryDict["is_started"] as? Bool
            updatedAt = dataArryDict["updated_at"] as? String
            userId = dataArryDict["user_id"] as? String
            destinations = [TripResponseUpdateDestination]()
            if let destinationsArray = dataArryDict["destinations"] as? [[String:Any]]{
                for dic in destinationsArray{
                    let value = TripResponseUpdateDestination(fromDictionary: dic)
                    destinations.append(value)
                }
            }
            origins = [TripResponseUpdateOrigin]()
            if let originsArray = dataArryDict["origins"] as? [[String:Any]]{
                for dic in originsArray{
                    let value = TripResponseUpdateOrigin(fromDictionary: dic)
                    origins.append(value)
                }
            }
        }
    }

}
