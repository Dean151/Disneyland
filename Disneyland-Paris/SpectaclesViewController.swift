//
//  SpectaclesViewController.swift
//  Disneyland-Paris
//
//  Created by Thomas Durand on 15/06/2015.
//  Copyright (c) 2015 Dean. All rights reserved.
//

import UIKit

final class SpectaclesViewController: PoiViewController {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.title = "Shows"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func manualRefresh(sender: AnyObject?) {
        self.getShowsAndParades() {
            self.refreshControl.endRefreshing()
        }
    }
    
    func getShowsAndParades(completion: () -> Void) {
        self.getPoiWithUrl(showsURL) {
            self.getParade() {
                completion()
            }
        }
    }
    
    func getParade(completion: () -> Void) {
        self.getPoiWithUrl(paradesURL) {
            completion()
        }
    }
}
