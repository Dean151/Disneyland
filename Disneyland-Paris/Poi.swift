//
//  Poi.swift
//  Disneyland-Paris
//
//  Created by Thomas Durand on 15/06/2015.
//  Copyright (c) 2015 Dean. All rights reserved.
//

import Foundation
import CoreLocation

class Poi {
    var id:String
    var name: String
    var description: String
    
    init (id: String, name: String, description: String) {
        self.id = id
        self.name = name
        self.description = description
    }
    
    var parc: String {
        switch (id[1]) {
        case "1":
            return "dlp"
        case "2":
            return "wds"
        default:
            return ""
        }
    }
    
    func searchInString(#string: String, search: String) -> Bool {
        if string.lowercaseString.rangeOfString(search.lowercaseString) != nil {
            return true
        } else {
            return false
        }
    }
    
    func searchInName(search: String) -> Bool {
        return searchInString(string: self.name, search: search)
    }
    
    func searchInDescription(search: String) -> Bool {
        return searchInString(string: self.description, search: search)
    }
}

class Restaurant: Poi {
    var location: CLLocationCoordinate2D
    var distance: Double = 0
    
    var open: Int = 0
    var opening = NSDate()
    var closing = NSDate()
    
    init(id: String, name: String, description: String, latitude: Double, longitude: Double) {
        self.location = CLLocationCoordinate2DMake(latitude, longitude)
        super.init(id: id, name: name, description: description)
    }
    
    func update(#open: Int, opening: String, closing: String) {
        self.open = open
        self.opening = NSDate(dateString: opening)
        self.closing = NSDate(dateString: closing)
    }
    
    func formatDate(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle
        return formatter.stringFromDate(date)
    }
    
    var openingTimeString: String {
        return self.formatDate(opening)
    }
    
    var closingTimeString: String {
        return self.formatDate(closing)
    }
    
    var status: Int {
        // -1 : closed today
        // 0 : closed
        // 1 : opening at
        // 2 : interrupted
        // 3 : open
        
        switch open {
        case 0:
            if opening.compare(closing) == NSComparisonResult.OrderedSame {
                return -1 // closed today
            } else {
                return 0 // closed
            }
        case 1:
            return 3 // open
        case 2:
            return 2 // interrupted
        default:
            return 0 // closed
        }
    }
    
    var statusString: String {
        switch status {
        case -1:
            return "Closed today"
        case 0:
            return "Closed"
        case 1:
            return "Opening at \(openingTimeString)"
        case 2:
            return "Interrupted"
        case 3:
            return "Open"
        default:
            return ""
        }
    }
}

class Attraction: Restaurant {
    var waittime: Int = 0
    
    override var status: Int {
        if waittime == 0 && open == 1 {
            return 2 // interrupted
        } else {
            return super.status
        }
    }
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

extension String {
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
}