//
//  Utils.swift
//  CarPool
//
//  Created by GeoSpark Mac #1 on 25/09/19.
//  Copyright © 2019 GeoSpark, Inc. All rights reserved.
//

import Foundation
import CoreLocation
import GeoSpark

internal class Utils: NSObject {
       
    static func getAddressFromLatLon(_ locationCoord:CLLocationCoordinate2D, completionHandler: @escaping (String) -> ()){
        
        let ceo: CLGeocoder = CLGeocoder()
        var addressString : String = ""
        
        ceo.reverseGeocodeLocation(CLLocation(latitude: locationCoord.latitude, longitude: locationCoord.longitude), completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    if pm.subThoroughfare != nil {
                        addressString = addressString + pm.subThoroughfare! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.administrativeArea != nil {
                        addressString = addressString + pm.administrativeArea! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode!
                    }
                }
                completionHandler(addressString)
        })
    }

    static func coordinateString(_ coord:CLLocationCoordinate2D) -> String{
        return "\(coord.latitude)\(",")\(coord.longitude)"
    }
    
    static func API_KEY() -> String{
        return ""
    }
    static func stringToDict(_ number:String,_ name:String,_ userId:String) -> Dictionary<String,Any>{
        var dic:Dictionary<String,Any> = ["phone":number,"name":name]
        if userId.isEmpty == false{
            dic.updateValue(userId, forKey: "user_id")
        }
        return dic
    }

    static func findARideDictionary(_ sourceCoord:CLLocationCoordinate2D,_ destCoord:CLLocationCoordinate2D) -> Dictionary<String,Any>{
        return ["pool_usr":SharedUtil.getDefaultString(kUserId),"service_type":"requester","src_lat":sourceCoord.latitude,"src_lng":sourceCoord.longitude,"dest_lat":destCoord.latitude,"dest_lng":destCoord.longitude]
    }

    static func getARideDictionary(_ sourceCoord:CLLocationCoordinate2D,_ destCoord:CLLocationCoordinate2D) -> Dictionary<String,Any>{
        return ["pool_usr":SharedUtil.getDefaultString(kUserId),"service_type":"provider","src_lat":sourceCoord.latitude,"src_lng":sourceCoord.longitude,"dest_lat":destCoord.latitude,"dest_lng":destCoord.longitude]
    }
    
    static func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
            defaults.synchronize()
        }
        GeoSpark.trackLocationInAppState([GSAppState.AlwaysOn])
        GeoSpark.trackLocationInMotion([GSMotion.All])
        
    }

    static func tripURL(_ tripId:String) -> String{
       return "https://trips.gs/" + tripId.toBase64()!
    }

    static func storeNotiofication(_ dataDictionary:Dictionary<String,Any>)
    {
        var dataArray = UserDefaults.standard.array(forKey: "GeoSparkKeyForLatLongInfo")
        if let _ = dataArray {
            dataArray?.append(dataDictionary)
        }else{
            dataArray = [dataDictionary]
        }
        UserDefaults.standard.set(dataArray, forKey: "GeoSparkKeyForLatLongInfo")
        UserDefaults.standard.synchronize()
    }

}
