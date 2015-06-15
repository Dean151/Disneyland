//
//  AttractionCell.swift
//  Disneyland-Paris
//
//  Created by Thomas Durand on 15/06/2015.
//  Copyright (c) 2015 Dean. All rights reserved.
//

import UIKit

class AttractionCell: UITableViewCell {
    
    let redColor = UIColor(hexadecimal: "#FF3B30")
    let orangeColor = UIColor(hexadecimal: "#FF9500")
    let greenColor = UIColor(hexadecimal: "#4CD964")
    
    // Labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var waitLabel: UILabel!
    
    @IBOutlet weak var attractionImage: UIImageView!
    
    func load(#attraction: Attraction) {
        nameLabel.text = attraction.name
        
        if let image = UIImage(named: attraction.id) {
            self.attractionImage.image = image
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
            
            statusLabel.text = ""
            waitLabel.text = "\(waitTime)'"
        } else {
            statusLabel.text = attraction.statusString
            waitLabel.text = ""
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