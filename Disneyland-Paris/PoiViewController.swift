//
//  PoiViewController.swift
//  Disneyland-Paris
//
//  Created by Thomas Durand on 15/06/2015.
//  Copyright (c) 2015 Dean. All rights reserved.
//

import UIKit
import SwiftyJSON

enum typeOfSort: Int {
    case byName=0, byWaitTimes, byDistance
}

class PoiViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    var sortType: typeOfSort = .byWaitTimes
    
    var poiDict = [String: Poi]()
    var poiIndexes = [String]()
    
    var searchIndexes = [String]()
    var searchText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableView Parameters
        tableView.dataSource = self
        tableView.delegate = self
        
        // Nib for CustomCells
        var nib =  UINib(nibName: "PoiCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "PoiCell")
        
        self.tableView.contentOffset = CGPointZero;
        
        // Refresh Control
        self.refreshControl.addTarget(self, action: "manualRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        self.autoRefresh()
    }
    
    func manualRefresh(sender: AnyObject?) {
        // Should be instantiated by children
        self.refreshControl.endRefreshing()
    }
    
    final func autoRefresh() {
        // AutoRefresh just call manual refresh function, after activating refreshControl
        println("autorefreshing");
        self.refreshControl.beginRefreshing()
        self.manualRefresh(self)
    }
    
    final func getPoiWithUrl(url: String, completion: () -> Void) {
        DataManager.getUrlWithSuccess(url: url, success: { (attractions, error) -> Void in
            if let e = error {
                self.loadingError()
            } else if let poiList = attractions {
                let json = JSON(data: poiList)
                
                for (index: String, subJson: JSON) in json {
                    if let identifier = subJson["idbio"].string,
                        name = subJson["title"].string,
                        cat = subJson["categorie"].int,
                        desc = subJson["description"].string,
                        long = subJson["coord_x"].double,
                        lat = subJson["coord_y"].double {
                            let att = Poi(id: identifier, name: name, categorie: cat, description: desc, latitude: lat, longitude: long)
                            self.poiDict.updateValue(att, forKey: identifier)
                            self.poiIndexes.append(identifier)
                    }
                }
                self.sort(beginEndUpdate: false)
                println("Success to get pois")
                completion()
            } else {
                self.loadingError()
            }
        })
    }
    
    func loadingError() {
        self.refreshControl.endRefreshing()
        let alertController = UIAlertController(title: NSLocalizedString("Unable to refresh", comment: ""), message:
            NSLocalizedString("Please check your connectivity and try again", comment: ""), preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // SORT FUNCTIONS
    func sort(#beginEndUpdate: Bool) {
        switch sortType {
        case .byDistance:
            self.poiIndexes.sort(self.sortByDistance)
        case .byWaitTimes:
            self.poiIndexes.sort(self.sortByTimeAndStatus)
        default:
            self.poiIndexes.sort(self.sortByName)
        }
        
        if beginEndUpdate { self.tableView.beginUpdates() }
        self.tableView.reloadData()
        if beginEndUpdate { self.tableView.endUpdates() }
    }
    
    // COMPARISON FUNCTIONS FOR SORT FUNCTIONS
    func sortByName(i1: String, i2: String) -> Bool {
        if let s1 = self.poiDict[i1], s2 = self.poiDict[i2] {
            return s1.name < s2.name
        }
        return false
    }
    
    func sortByTimeAndStatus(i1: String, i2: String) -> Bool {
        if let s1 = self.poiDict[i1] as? Restaurant, s2 = self.poiDict[i2] as? Restaurant {
            if s1.status == 3 && s2.status == 3 {
                if let a1 = s1 as? Attraction, a2 = s2 as? Attraction {
                    if a1.waittime != a2.waittime {
                        return a1.waittime < a2.waittime
                    }
                }
                else {
                    return sortByName(i1, i2: i2)
                }
                
            } else {
                if s1.status == s2.status {
                    return sortByName(i1, i2: i2)
                } else {
                    return s1.status > s2.status
                }
            }
        }
        return sortByName(i1, i2: i2)
    }
    
    func sortByDistance(i1: String, i2: String) -> Bool {
        if let s1 = self.poiDict[i1], s2 = self.poiDict[i2] {
            if s1.distance < 0 && s2.distance < 0 {
                return sortByName(i1, i2: i2)
            } else {
                return s1.distance < s2.distance
            }
        }
        return sortByName(i1, i2: i2)
    }
    
    func sortBySearchText(i1: String, i2: String) -> Bool {
        if let s1 = self.poiDict[i1], s2 = self.poiDict[i2] {
            if s1.searchInName(searchText) && !s2.searchInName(searchText) {
                return true
            } else if s2.searchInName(searchText) && !s1.searchInName(searchText) {
                return false
            } else {
                return sortByName(i1, i2: i2)
            }
        }
        return sortByName(i1, i2: i2)
    }
    
    // MARK : TableViewDataSource
    
    final func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return poiIndexes.count
        } else {
            return searchIndexes.count
        }
    }
    
    final func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PoiCell", forIndexPath: indexPath) as! PoiCell
        
        var index = ""
        
        if tableView == self.tableView {
            index = poiIndexes[indexPath.row]
        } else {
            index = searchIndexes[indexPath.row]
        }
        
        
        if let attraction = poiDict[ index ] as? Attraction {
            cell.load(attraction: attraction)
        }
        else if let restaurant = poiDict[ index ] as? Restaurant {
            cell.load(restaurant: restaurant)
        }
        else if let poi = poiDict[ index ] {
            cell.load(poi: poi)
        }
        
        return cell
    }
    
    final func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 76
    }
}
