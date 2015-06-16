//
//  PoiCell.swift
//  Disneyland-Paris
//
//  Created by Thomas Durand on 16/06/2015.
//  Copyright (c) 2015 Dean. All rights reserved.
//

import UIKit

class PoiCell: UITableViewCell {
    
    // Labels
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var attractionImage: UIImageView!
    
    func load(#poi: Poi) {
        nameLabel.text = poi.name
        
        if let image = UIImage(named: poi.id) {
            self.attractionImage.image = image
        } else {
            self.attractionImage.image = nil
        }
    }
}