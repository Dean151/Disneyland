//
//  RestaurantCell.swift
//  Disneyland-Paris
//
//  Created by Thomas Durand on 15/06/2015.
//  Copyright (c) 2015 Dean. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {
    
    let redColor = UIColor(hexadecimal: "#FF3B30")
    let orangeColor = UIColor(hexadecimal: "#FF9500")
    let greenColor = UIColor(hexadecimal: "#4CD964")
    
    // Labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var attractionImage: UIImageView!
    
    func load(#restaurant: Restaurant) {
        nameLabel.text = restaurant.name
        
        if let image = UIImage(named: restaurant.id) {
            self.attractionImage.image = image
        }
        
        /*
        if restaurant.status >= 0 {
            hours.text = "\(poi.openingTimeString) → \(poi.closingTimeString)"
        } else {
            hours.text = ""
        }
        */
        
        statusLabel.text = restaurant.statusString
        
        if restaurant.status <= 0 {
            statusLabel.textColor = redColor
        } else if restaurant.status == 3 {
            statusLabel.textColor = greenColor
        } else {
            statusLabel.textColor = orangeColor
        }
    }
}