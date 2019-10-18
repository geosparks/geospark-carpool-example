//
//  APIManager.swift
//  GeoSpark Ignite
//
//  Created by GeoSpark Mac #1 on 23/04/19.
//  Copyright © 2019 GeoSpark, Inc. All rights reserved.
//

import Foundation

class APIManager: NSObject {
    
    static let sharedInstance = APIManager()
    
    func postMethodSession(_ urlString:String,_ bodyParams:Dictionary<String,Any>,_ header:Bool,onSuccess: @escaping (_ dictionary: Dictionary<String,Any>) -> Void, onFailure: @escaping (_ error: Error?,_ status:Int?) -> Void){
        
        guard let serviceUrl = URL(string: urlString) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        if header{
            request.allHTTPHeaderFields = ["Api-Key":GEOSPARK_API_KEY]
        }
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: bodyParams, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    onSuccess(json as! Dictionary<String,Any>)
                }catch {
                    onFailure(error, httpResponse?.statusCode)
                }
            }else{
                onFailure(error, httpResponse?.statusCode)
            }
            }.resume()
    }
    
    func getMethodSession(_ urlString:String,_ header:Bool,onSuccess: @escaping (_ dictionary: Dictionary<String,Any>) -> Void, onFailure: @escaping (_ error: Error?,_ status:Int?) -> Void){
        
        guard let serviceUrl = URL(string: urlString) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        if header{
            request.allHTTPHeaderFields = ["Application/json":"Content-Type","Api-Key":GEOSPARK_API_KEY]
        }
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    onSuccess(json as! Dictionary<String,Any>)
                }catch {
                    
                    onFailure(error,httpResponse?.statusCode)
                }
            }else {
                onFailure(error,httpResponse?.statusCode)
            }
            }.resume()
    }
    
    func getMethodSessionRoute(_ urlString:String,onSuccess: @escaping (_ dictionary: Dictionary<String,Any>) -> Void, onFailure: @escaping (_ error: Error?,_ status:Int?) -> Void){
        
        guard let serviceUrl = URL(string: urlString) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "GET"
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    onSuccess(json as! Dictionary<String,Any>)
                }catch {
                    
                    onFailure(error,httpResponse?.statusCode)
                }
            }else {
                onFailure(error,httpResponse?.statusCode)
            }
            }.resume()
    }
    
    
    func putMethodSession(_ urlString:String,_ bodyParams:Dictionary<String,Any>,_ header:Bool,onSuccess: @escaping (_ dictionary: Dictionary<String,Any>) -> Void, onFailure: @escaping (_ error: Error?,_ status:Int?) -> Void){
        
        guard let serviceUrl = URL(string: urlString) else { return }
        var request = URLRequest(url: serviceUrl)
        request.httpMethod = "POST"
        if header{
            request.allHTTPHeaderFields = ["Api-Key":GEOSPARK_API_KEY]
        }
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: bodyParams, options: []) else {
            return
        }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    onSuccess(json as! Dictionary<String,Any>)
                }catch {
                    onFailure(error, httpResponse?.statusCode)
                }
            }else{
                onFailure(error, httpResponse?.statusCode)
            }
            }.resume()
    }


}
