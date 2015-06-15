//
//  PoiViewController.swift
//  Disneyland-Paris
//
//  Created by Thomas Durand on 15/06/2015.
//  Copyright (c) 2015 Dean. All rights reserved.
//

import UIKit

class PoiViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    var poiArray = [Poi]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Nib for CustomCells
        var nib = UINib(nibName: "AttractionCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "AttractionCell")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poiArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let attraction = poiArray[indexPath.row] as? Attraction {
            let cell = tableView.dequeueReusableCellWithIdentifier("AttractionCell", forIndexPath: indexPath) as! AttractionCell
            
            cell.load(attraction: attraction)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 76
    }
}
