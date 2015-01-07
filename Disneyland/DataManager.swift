//
//  DataManager.swift
//  Disneyland
//
//  Created by Thomas Durand on 07/01/2015.
//  Copyright (c) 2015 Dean151. All rights reserved.
//

import Foundation

let availableCountryCodes = ["en", "fr"]
let countryCode = "en"

let attractionsURL = "http://api.disneyfan.fr/attractions/\(countryCode)"
let restaurantsURL = "http://api.disneyfan.fr/restaurants/\(countryCode)"
let waitTimesURL = "http://api.disneyfan.fr/waittimes"
let ouvertureURL = "http://api.disneyfan.fr/ouverture"

class DataManager {
    class func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
        var session = NSURLSession.sharedSession()
        
        var request:NSMutableURLRequest = NSMutableURLRequest(URL:url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            (response, data, error) in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    var statusError = NSError(domain:"fr.dean151", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        }
    }
    
    class func getAttractionsWithSuccess(success: ((attractions: NSData!) -> Void)) {
        loadDataFromURL(NSURL(string: attractionsURL)!, completion:{(data, error) -> Void in
            if let urlData = data {
                success(attractions: urlData)
            }
        })
    }
    
    class func getRestaurantsWithSuccess(success: ((restaurants: NSData!) -> Void)) {
        loadDataFromURL(NSURL(string: restaurantsURL)!, completion:{(data, error) -> Void in
            if let urlData = data {
                success(restaurants: urlData)
            }
        })
    }
    
    class func getWaitTimesWithSuccess(success: ((data: NSData!) -> Void)) {
        loadDataFromURL(NSURL(string: waitTimesURL)!, completion:{(data, error) -> Void in
            if let urlData = data {
                success(data: urlData)
            }
        })
    }
    
    class func getOuvertureWithSuccess(success: ((data: NSData!) -> Void)) {
        loadDataFromURL(NSURL(string: ouvertureURL)!, completion:{(data, error) -> Void in
            if let urlData = data {
                success(data: urlData)
            }
        })
    }
}

