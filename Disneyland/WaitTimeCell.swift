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
    @IBOutlet weak var parc: UIImageView!
    @IBOutlet weak var poiImage: UIImageView!
    
    let redColor = UIColor(hexadecimal: "#FF3B30")
    let orangeColor = UIColor(hexadecimal: "#FF9500")
    let greenColor = UIColor(hexadecimal: "#4CD964")
    
    let blueColor = UIColor(hexadecimal: "#329EF9")
    
    func load(#identifier: String, title: String, parc: String) {
        // Poi title
        self.title.text = title
        
        // Parc icon
        self.parc.tintColor = blueColor
        if let image = UIImage(named: parc) {
            self.parc.image = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        }
        
        // POI image
        if let image = UIImage(named: identifier) {
            self.poiImage.image = image
        }
    }
    
    // Method for loading an attraction
    func load(poi: Attraction) {
        load(identifier: poi.id, title: poi.title, parc: poi.parc)
        
        if poi.status >= 0 {
            hours.text = "\(poi.openingTimeString) → \(poi.closingTimeString)"
        } else {
            hours.text = ""
        }
        
        if poi.status == 3 {
            let waitTime = poi.waittime
            
            // Color code
            if waitTime >= 60 {
                self.waittime.textColor = redColor
            }
            else if waitTime >= 30 {
                self.waittime.textColor = orangeColor
            }
            else {
                self.waittime.textColor = greenColor
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
        load(identifier: poi.id, title: poi.title, parc: poi.parc)
        
        if poi.status >= 0 {
            hours.text = "\(poi.openingTimeString) → \(poi.closingTimeString)"
        } else {
            hours.text = ""
        }
        
        status.text = poi.statusString
        
        if poi.status <= 0 {
            status.textColor = redColor
        } else if poi.status == 3 {
            status.textColor = greenColor
        } else {
            status.textColor = orangeColor
        }
        
        waittime.text = ""
    }
}