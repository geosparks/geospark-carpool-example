//
//  TripResponseUpdateCoordinate.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on October 1, 2019

import Foundation


class TripResponseUpdateCoordinate : NSObject, NSCoding{

    var coordinates : [Double]!
    var type : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        type = dictionary["type"] as? String
        coordinates = dictionary["coordinates"] as? [Double]
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if type != nil{
            dictionary["type"] = type
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        coordinates = aDecoder.decodeObject(forKey: "coordinates") as? [Double]
        type = aDecoder.decodeObject(forKey: "type") as? String
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
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
    }
}
