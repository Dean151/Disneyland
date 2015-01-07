//
//  Poi.swift
//  Disneyland
//
//  Created by Thomas Durand on 07/01/2015.
//  Copyright (c) 2015 Dean151. All rights reserved.
//

import Foundation

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

class Attraction: Poi {
    var open: Int!
    var opening: NSDate!
    var closing: NSDate!
    var waittime: Int!
}

class Restaurant: Poi {
    var open: Int!
    var opening: NSDate!
    var closing: NSDate!
}

class Show: Poi {
    var time: NSDate!
    var language: String!
}