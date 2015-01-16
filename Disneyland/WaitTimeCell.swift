//
//  WaitTimeCell.swift
//  Disneyland
//
//  Created by Thomas Durand on 13/01/2015.
//  Copyright (c) 2015 Dean151. All rights reserved.
//

import UIKit

class WaitTimeCell : UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var hours: UILabel!
    @IBOutlet weak var waittime: UILabel!
    @IBOutlet weak var status: UILabel!
    
    // Method for loading an attraction
    func load(poi: Attraction) {
        title.text = poi.title
        
        if poi.status >= 0 {
            hours.text = "\(poi.openingTimeString) → \(poi.closingTimeString)"
        } else {
            hours.text = ""
        }
        
        if poi.status == 3 {
            let waitTime = poi.waittime
            
            // Color code
            if waitTime >= 60 {
                self.waittime.textColor = UIColor(red: 0.8, green: 0, blue: 0, alpha: 1) // Red color
            }
            else if waitTime >= 30 {
                self.waittime.textColor = UIColor(red: 1, green: 0.4, blue: 0, alpha: 1) // Orange color
            }
            else {
                self.waittime.textColor = UIColor(red: 0, green: 0.6, blue: 0.2, alpha: 1) // Green color
            }
            
            status.text = ""
            waittime.text = "\(waitTime)'"
        } else {
            status.text = poi.statusString
            waittime.text = ""
        }
    }
    
    // there is also a method for restaurants
    func load(poi: Restaurant) {
        title.text = poi.title
        
        if poi.status >= 0 {
            hours.text = "\(poi.openingTimeString) → \(poi.closingTimeString)"
        } else {
            hours.text = ""
        }
        
        status.text = poi.statusString
        waittime.text = ""
    }
}