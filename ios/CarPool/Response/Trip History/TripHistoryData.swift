//
//  TripHistoryData.swift
//  Model Generated using http://www.jsoncafe.com/ 
//  Created on September 27, 2019

import Foundation


class TripHistoryData : NSObject, NSCoding{

    var nextPage : Int!
    var pages : Int!
    var prevPage : Int!
    var trips : [TripHistoryTrip]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        pages = dictionary["pages"] as? Int
        if pages == 1 {
            nextPage = 0
            prevPage = 0
        }else{
            nextPage = dictionary["next_page"] as? Int
            prevPage = dictionary["prev_page"] as? Int
        }
        trips = [TripHistoryTrip]()
        if let tripsArray = dictionary["trips"] as? [[String:Any]]{
            for dic in tripsArray{
                let value = TripHistoryTrip(fromDictionary: dic)
                trips.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if nextPage != nil{
            dictionary["next_page"] = nextPage
        }
        if pages != nil{
            dictionary["pages"] = pages
        }
        if prevPage != nil{
            dictionary["prev_page"] = prevPage
        }
        if trips != nil{
            var dictionaryElements = [[String:Any]]()
            for tripsElement in trips {
                dictionaryElements.append(tripsElement.toDictionary())
            }
            dictionary["trips"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        nextPage = aDecoder.decodeObject(forKey: "next_page") as? Int
        pages = aDecoder.decodeObject(forKey: "pages") as? Int
        prevPage = aDecoder.decodeObject(forKey: "prev_page") as? Int
        trips = aDecoder.decodeObject(forKey: "trips") as? [TripHistoryTrip]
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if nextPage != nil{
            aCoder.encode(nextPage, forKey: "next_page")
        }
        if pages != nil{
            aCoder.encode(pages, forKey: "pages")
        }
        if prevPage != nil{
            aCoder.encode(prevPage, forKey: "prev_page")
        }
        if trips != nil{
            aCoder.encode(trips, forKey: "trips")
        }
    }
}
