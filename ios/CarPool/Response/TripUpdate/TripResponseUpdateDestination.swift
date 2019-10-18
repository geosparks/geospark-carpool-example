//
//  TripResponseUpdateDestination.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on October 1, 2019

import Foundation


class TripResponseUpdateDestination : NSObject, NSCoding{

    var coordinates : TripResponseUpdateCoordinate!
    var createdAt : String!
    var id : String!
    var locType : String!
    var reached : Bool!
    var tripId : String!
    var updatedAt : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        createdAt = dictionary["created_at"] as? String
        id = dictionary["id"] as? String
        locType = dictionary["loc_type"] as? String
        reached = dictionary["reached"] as? Bool
        tripId = dictionary["trip_id"] as? String
        updatedAt = dictionary["updated_at"] as? String
        if let coordinatesData = dictionary["coordinates"] as? [String:Any]{
            coordinates = TripResponseUpdateCoordinate(fromDictionary: coordinatesData)
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if id != nil{
            dictionary["id"] = id
        }
        if locType != nil{
            dictionary["loc_type"] = locType
        }
        if reached != nil{
            dictionary["reached"] = reached
        }
        if tripId != nil{
            dictionary["trip_id"] = tripId
        }
        if updatedAt != nil{
            dictionary["updated_at"] = updatedAt
        }
        if coordinates != nil{
            dictionary["coordinates"] = coordinates.toDictionary()
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        coordinates = aDecoder.decodeObject(forKey: "coordinates") as? TripResponseUpdateCoordinate
        createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        locType = aDecoder.decodeObject(forKey: "loc_type") as? String
        reached = aDecoder.decodeObject(forKey: "reached") as? Bool
        tripId = aDecoder.decodeObject(forKey: "trip_id") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if coordinates != nil{
            aCoder.encode(coordinates, forKey: "coordinates")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if locType != nil{
            aCoder.encode(locType, forKey: "loc_type")
        }
        if reached != nil{
            aCoder.encode(reached, forKey: "reached")
        }
        if tripId != nil{
            aCoder.encode(tripId, forKey: "trip_id")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }
    }
}