//
//  TripResponse .swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 30, 2019

import Foundation


class TripResponse  : NSObject{

    var code : Int!
    var msg : String!
    var status : Bool!

     var createdAt : String!
     var tripId : String!
     var isDeleted : Bool!
     var isEnded : Bool!
     var isPaused : Bool!
     var isStarted : Bool!
     var projectId : String!
     var updatedAt : String!
     var userId : String!
     
     var originLat:Double!
     var originLng:Double!
     var destinationLat:Double!
     var destinationLng:Double!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        code = dictionary["code"] as? Int
        if let message = dictionary["msg"] as? String{
            msg = message
        }else{
            msg = dictionary["message"] as? String
        }
        status = dictionary["status"] as? Bool
        if let dataArray = dictionary["data"] as? [[String:Any]]{
            let dataDict = dataArray[0]
            createdAt = dataDict["created_at"] as? String
            tripId = dataDict["id"] as? String
            isDeleted = dataDict["is_deleted"] as? Bool
            isEnded = dataDict["is_ended"] as? Bool
            isPaused = dataDict["is_paused"] as? Bool
            isStarted = dataDict["is_started"] as? Bool
            projectId = dataDict["project_id"] as? String
            updatedAt = dataDict["updated_at"] as? String
            userId = dataDict["user_id"] as? String
            
            if let destinationsArray = dataDict["destinations"] as? [[String:Any]]{
                if let coordinatesData = destinationsArray[0]["coordinates"] as? [String:Any]{
                    let coord = coordinatesData["coordinates"] as? [Double]
                    destinationLat = coord?.first
                    destinationLng = coord?.last
                }
            }
            if let originsArray = dataDict["origins"] as? [[String:Any]]{
                if let coordinatesData = originsArray[0]["coordinates"] as? [String:Any]{
                    let coord = coordinatesData["coordinates"] as? [Double]
                    originLat = coord?.first
                    originLng = coord?.last
                }
            }

        }
    }


}
