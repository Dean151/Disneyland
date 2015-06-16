//
//  Poi.swift
//  Disneyland-Paris
//
//  Created by Thomas Durand on 15/06/2015.
//  Copyright (c) 2015 Dean. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

enum PoiCategorie: Int {
    case Other = 1, Children, Family, BigThrills
    
    var color: UIColor {
        switch self {
            case .Other:
                return UIColor()
            case .Children:
                return greenColor
            case .Family:
                return navBarColor
            case .BigThrills:
                return orangeColor
        }
    }
    
    static func fromRaw(rawValue: Int) -> PoiCategorie {
        if rawValue >= 1 && rawValue <= 4 {
            return PoiCategorie(rawValue: rawValue)!
        } else {
            return .Other
        }
    }
}

class Poi {
    var id:String
    var name: String
    var categorie: PoiCategorie
    var description: String
    
    var location: CLLocationCoordinate2D
    var distance: Double = 0
    
    init (id: String, name: String, categorie: Int, description: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.categorie = PoiCategorie.fromRaw(categorie)
        self.description = description
        
        self.location = CLLocationCoordinate2DMake(latitude, longitude)
    }
    
    var parc: String {
        switch (id[1]) {
        case "1":
            return "dlp"
        case "2":
            return "wds"
        case "3":
            return "dv"
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
    var open: Int = 0
    var opening = NSDate()
    var closing = NSDate()
    
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
        case 0 where opening.compare(closing) == NSComparisonResult.OrderedSame:
            return -1 // closed today
        case 0:
            return 0 // closed
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
            return NSLocalizedString("Closed today", comment: "")
        case 0:
            return NSLocalizedString("Closed", comment: "")
        case 1:
            return NSLocalizedString("Opening at", comment: "") + " \(openingTimeString)"
        case 2:
            return NSLocalizedString("Interrupted", comment: "")
        case 3:
            return NSLocalizedString("Open", comment: "")
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