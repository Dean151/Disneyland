//
//  ShopsViewController.swift
//  Disneyland-Paris
//
//  Created by Thomas Durand on 16/06/2015.
//  Copyright (c) 2015 Dean. All rights reserved.
//

import UIKit

final class ShopsViewController: PoiViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.title = NSLocalizedString("Shops", comment: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func manualRefresh(sender: AnyObject?) {
        self.poiIndexes.removeAll()
        self.getPoiWithUrl(shopsURL) {
            self.refreshControl.endRefreshing()
        }
    }
}
