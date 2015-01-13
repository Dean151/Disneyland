//
//  Poi.swift
//  Disneyland
//
//  Created by Thomas Durand on 07/01/2015.
//  Copyright (c) 2015 Dean151. All rights reserved.
//

import Foundation
import CoreLocation

class Poi {
    var id:String
    var title: String
    var description: String
    
    init (id: String, title: String, description: String) {
        self.id = id
        self.title = title
        self.description = description
    }
    
    func searchInString(#string: String, search: String) -> Bool {
        if string.lowercaseString.rangeOfString(search.lowercaseString) != nil {
            return true
        } else {
            return false
        }
    }
    
    func searchInTitle(search: String) -> Bool {
        return searchInString(string: self.title, search: search)
    }
    
    func searchInDescription(search: String) -> Bool {
        return searchInString(string: self.description, search: search)
    }
}

class Restaurant: Poi {
    var location: CLLocationCoordinate2D
    var distance: Double = 0
    
    var open: Int!
    var opening: NSDate!
    var closing: NSDate!
    
    init(id: String, title: String, description: String, latitude: Double, longitude: Double) {
        self.location = CLLocationCoordinate2DMake(latitude, longitude)
        super.init(id: id, title: title, description: description)
    }
    
    func update(#open: Int, opening: String, closing: String) {
        self.open = open
        self.opening = NSDate(dateString: opening)
        self.closing = NSDate(dateString: closing)
    }
    
    var status: Int {
        return 0
    }
}

class Attraction: Restaurant {
    var waittime: Int!
}

class Show: Poi {
    var time: NSDate!
    var language: String!
}

extension NSDate {
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyyMMddHHmm"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "fr")
        let d:NSDate = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval: 0, sinceDate: d)
    }
}