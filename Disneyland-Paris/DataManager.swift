//
//  DataManager.swift
//  Disneyland-Paris
//
//  Created by Thomas Durand on 15/06/2015.
//  Copyright (c) 2015 Dean. All rights reserved.
//

import Foundation

let availableCountryCodes = ["en", "fr"]
let countryCode = NSLocalizedString("en", comment: "")

let attractionsURL = "http://api.disneyfan.fr/attractions/extended/\(countryCode)"
let restaurantsURL = "http://api.disneyfan.fr/restaurants/extended/\(countryCode)"
let showsURL = "http://api.disneyfan.fr/shows/\(countryCode)"
let paradesURL = "http://api.disneyfan.fr/parades/\(countryCode)"
let shopsURL = "http://api.disneyfan.fr/shops/\(countryCode)"

let waitTimesURL = "http://api.disneyfan.fr/waittimes"
let ouvertureURL = "http://api.disneyfan.fr/ouverture"

class DataManager {
    
    static func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
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
    
    static func getUrlWithSuccess(#url: String, success: (data: NSData?, error: NSError?) -> Void) {
        loadDataFromURL(NSURL(string: url)!, completion:{(data, error) -> Void in
            if let responseError = error {
                success(data: nil, error: responseError)
            } else if let urlData = data {
                success(data: urlData, error: nil)
            }
        })
    }
}