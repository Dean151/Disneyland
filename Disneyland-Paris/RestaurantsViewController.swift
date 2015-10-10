//
//  RestaurantsViewController.swift
//  Disneyland-Paris
//
//  Created by Thomas Durand on 15/06/2015.
//  Copyright (c) 2015 Dean. All rights reserved.
//

import UIKit
import SwiftyJSON

final class RestaurantsViewController: PoiViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.title = NSLocalizedString("Restaurants", comment: "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func manualRefresh(sender: AnyObject?) {
        if poiDict.isEmpty {
            // In this case, we need to get poi first
            self.getRestaurants() {
                self.refreshControl.endRefreshing()
            }
        } else {
            // We just need to get variable data
            self.getOpeningTimes() {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func getRestaurants(completion: () -> Void) {
        DataManager.getUrlWithSuccess(url: restaurantsURL, success: { (attractions, error) -> Void in
            if let _ = error {
                self.loadingError()
            } else if let restaurantsList = attractions {
                let json = JSON(data: restaurantsList)
                
                for (_, subJson): (String, JSON) in json {
                    if let identifier = subJson["idbio"].string,
                        name = subJson["title"].string,
                        cat = subJson["categorie"].int,
                        desc = subJson["description"].string,
                        long = subJson["coord_x"].double,
                        lat = subJson["coord_y"].double {
                            let att = Restaurant(id: identifier, name: name, categorie: cat, description: desc, latitude: lat, longitude: long)
                            self.poiDict.updateValue(att, forKey: identifier)
                            self.poiIndexes.append(identifier)
                    }
                }
                self.sort(beginEndUpdate: false)
                print("Success to get restaurants")
                self.getOpeningTimes() {
                    completion()
                }
            } else {
                self.loadingError()
            }
        })
    }
    
    func getOpeningTimes(completion: () -> Void) {
        DataManager.getUrlWithSuccess(url: ouvertureURL, success: { (waitTimes, error) -> Void in
            if let _ = error {
                self.loadingError()
            } else if let waitTimesList = waitTimes {
                let json = JSON(data: waitTimesList)
                
                for (_, subJson): (String, JSON) in json {
                    if let identifier = subJson["idbio"].string,
                        poi = self.poiDict[identifier] as? Restaurant,
                        opening = subJson["opening"].string,
                        closing = subJson["closing"].string,
                        open = subJson["open"].int {
                            poi.update(open: open, opening: opening, closing: closing)
                    }
                }
                self.sort(beginEndUpdate: true)
                print("Success to get opening times")
                completion()
            } else {
                self.loadingError()
            }
        })
    }
}
