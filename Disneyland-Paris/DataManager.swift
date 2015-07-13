//
//  DataManager.swift
//  Disneyland-Paris
//
//  Created by Thomas Durand on 15/06/2015.
//  Copyright (c) 2015 Dean. All rights reserved.
//

import Foundation
import Alamofire

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
    static func getUrlWithSuccess(#url: String, success: (data: NSData?, error: NSError?) -> Void) {
        
        Alamofire.request(.GET, url)
            .response { (request, response, data, error) in
                if let error = error {
                    success(data: nil, error: error)
                } else if let data = data as? NSData {
                    success(data: data, error: nil)
                }
            }
    }
}