//
//  TripHistoryTrip.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 27, 2019

import Foundation


class TripHistoryTrip : NSObject, NSCoding{

    var distanceCovered : Float!
    var duration : Int!
    var tripEndedAt : String!
    var tripStartedAt : String!
    var userId : String!
    var tripId : String!
    var isStarted:Bool!
    var isEnded:Bool!
    var isDelete:Bool!
    var isPause:Bool!
    var origins : [TripHistoryOrigin]!
    var destinations:[TripHistoryOrigin]!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        distanceCovered = dictionary["distance_covered"] as? Float
        duration = dictionary["duration"] as? Int
        tripEndedAt = dictionary["trip_ended_at"] as? String
        tripStartedAt = dictionary["trip_started_at"] as? String
        userId = dictionary["user_id"] as? String
        tripId = dictionary["id"] as? String
        isStarted = dictionary["is_started"] as? Bool
        isEnded = dictionary["is_ended"] as? Bool
        isDelete = dictionary["is_deleted"] as? Bool
        isPause = dictionary["is_paused"] as? Bool

        origins = [TripHistoryOrigin]()
        if let originsArray = dictionary["origins"] as? [[String:Any]]{
            for dic in originsArray{
                let value = TripHistoryOrigin(fromDictionary: dic)
                origins.append(value)
            }
        }
        destinations = [TripHistoryOrigin]()
        if let originsArray = dictionary["destinations"] as? [[String:Any]]{
            for dic in originsArray{
                let value = TripHistoryOrigin(fromDictionary: dic)
                destinations.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if distanceCovered != nil{
            dictionary["distance_covered"] = distanceCovered
        }
        if duration != nil{
            dictionary["duration"] = duration
        }
        if tripEndedAt != nil{
            dictionary["trip_ended_at"] = tripEndedAt
        }
        if tripStartedAt != nil{
            dictionary["trip_started_at"] = tripStartedAt
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        distanceCovered = aDecoder.decodeObject(forKey: "distance_covered") as? Float
        duration = aDecoder.decodeObject(forKey: "duration") as? Int
        tripEndedAt = aDecoder.decodeObject(forKey: "trip_ended_at") as? String
        tripStartedAt = aDecoder.decodeObject(forKey: "trip_started_at") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if distanceCovered != nil{
            aCoder.encode(distanceCovered, forKey: "distance_covered")
        }
        if duration != nil{
            aCoder.encode(duration, forKey: "duration")
        }
        if tripEndedAt != nil{
            aCoder.encode(tripEndedAt, forKey: "trip_ended_at")
        }
        if tripStartedAt != nil{
            aCoder.encode(tripStartedAt, forKey: "trip_started_at")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
    }
}
