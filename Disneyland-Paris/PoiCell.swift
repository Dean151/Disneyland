//
//  AttractionCell.swift
//  Disneyland-Paris
//
//  Created by Thomas Durand on 15/06/2015.
//  Copyright (c) 2015 Dean. All rights reserved.
//

import UIKit

class PoiCell: UITableViewCell {
    
    // Labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var waitLabel: UILabel!
    
    @IBOutlet weak var categorieColorBorder: UIView!
    @IBOutlet weak var attractionImage: UIImageView!
    
    func load(#poi: Poi) {
        // Default view
        categorieColorBorder.backgroundColor = UIColor.whiteColor()
        attractionImage.image = nil
        hoursLabel.text = ""
        statusLabel.text = ""
        waitLabel.text = ""
        
        // POI informations
        nameLabel.text = poi.name
        
        if let image = UIImage(named: poi.id) {
            self.attractionImage.image = image
        }
    }
    
    func load(#attraction: Attraction) {
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
    
    func load(#restaurant: Restaurant) {
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

extension UIColor {
    convenience init(hexadecimal: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if hexadecimal.hasPrefix("#") {
            let index   = advance(hexadecimal.startIndex, 1)
            let hex     = hexadecimal.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                switch (count(hex)) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                default:
                    print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8")
                }
            } else {
                println("Scan hex error")
            }
        } else {
            print("Invalid RGB string, missing '#' as prefix")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}