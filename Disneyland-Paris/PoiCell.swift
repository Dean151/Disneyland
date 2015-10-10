//
//  AttractionCell.swift
//  Disneyland-Paris
//
//  Created by Thomas Durand on 15/06/2015.
//  Copyright (c) 2015 Dean. All rights reserved.
//

import UIKit
import QuartzCore

class PoiCell: UITableViewCell {
    
    // Labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var waitLabel: UILabel!
    
    @IBOutlet weak var categorieColorBorder: UIView!
    @IBOutlet weak var attractionImage: UIImageView!
    
    func load(poi poi: Poi) {
        // Default view
        categorieColorBorder.backgroundColor = UIColor.whiteColor()
        categorieColorBorder.layer.cornerRadius = 5
        categorieColorBorder.layer.masksToBounds = true
        attractionImage.image = nil
        hoursLabel.text = ""
        statusLabel.text = ""
        waitLabel.text = ""
        
        // POI informations
        nameLabel.text = poi.name
        
        if let image = UIImage(named: poi.id) {
            self.attractionImage.image = image
        } else {
            print("Image \(poi.id) not found for \(poi.name)")
        }
    }
    
    func load(attraction attraction: Attraction) {
        load(poi: attraction)
        
        categorieColorBorder.backgroundColor = attraction.categorie.color
        
        if attraction.status >= 0 {
            hoursLabel.text = "\(attraction.openingTimeString) → \(attraction.closingTimeString)"
        }
        
        if attraction.status == 3 {
            let waitTime = attraction.waittime
            
            // Color code
            if waitTime >= 60 {
                waitLabel.textColor = redColor
            }
            else if waitTime >= 30 {
                waitLabel.textColor = orangeColor
            }
            else {
                waitLabel.textColor = greenColor
            }
            
            waitLabel.text = "\(waitTime)'"
        } else {
            statusLabel.text = attraction.statusString
        }
    }
    
    func load(restaurant restaurant: Restaurant) {
        load(poi: restaurant)
        
        if let image = UIImage(named: restaurant.id) {
            self.attractionImage.image = image
        }
        
        if restaurant.status >= 0 {
            hoursLabel.text = "\(restaurant.openingTimeString) → \(restaurant.closingTimeString)"
        }
        
        if restaurant.status > -2 {
            waitLabel.text = restaurant.statusString
        }
        
        if restaurant.status <= 0 {
            waitLabel.textColor = redColor
        } else if restaurant.status == 3 {
            waitLabel.textColor = greenColor
        } else {
            waitLabel.textColor = orangeColor
        }
    }
}