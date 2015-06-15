//
//  RestaurantCell.swift
//  Disneyland-Paris
//
//  Created by Thomas Durand on 15/06/2015.
//  Copyright (c) 2015 Dean. All rights reserved.
//

import UIKit

class RestaurantCell: UITableViewCell {
    
    // Labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var attractionImage: UIImageView!
    
    func load(#restaurant: Restaurant) {
        nameLabel.text = restaurant.name
        
        if let image = UIImage(named: restaurant.id) {
            self.attractionImage.image = image
        }
        
        if restaurant.status >= 0 {
            hoursLabel.text = "\(restaurant.openingTimeString) → \(restaurant.closingTimeString)"
        } else {
            hoursLabel.text = ""
        }
        
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