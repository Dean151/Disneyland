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
}

class Restaurant: Poi {
    var location: CLLocationCoordinate2D
    
    var open: Int!
    var opening: NSDate!
    var closing: NSDate!
    
    init(id: String, title: String, description: String, latitude: Double, longitude: Double) {
        self.location = CLLocationCoordinate2DMake(latitude, longitude)
        super.init(id: id, title: title, description: description)
    }
}

class Attraction: Restaurant {
    var waittime: Int!
}

class Show: Poi {
    var time: NSDate!
    var language: String!
}