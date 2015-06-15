//
//  PoiViewController.swift
//  Disneyland-Paris
//
//  Created by Thomas Durand on 15/06/2015.
//  Copyright (c) 2015 Dean. All rights reserved.
//

import UIKit

enum typeOfSort: Int {
    case byName=0, byWaitTimes, byDistance
}

class PoiViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    var sortType: typeOfSort = .byWaitTimes
    
    var poiDict = [String: Poi]()
    var poiIndexes = [String]()
    
    var search = [String]()
    var searchText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableView Parameters
        tableView.dataSource = self
        tableView.delegate = self
        
        // Nib for CustomCells
        var nib = UINib(nibName: "AttractionCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "AttractionCell")
        nib =  UINib(nibName: "RestaurantCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "RestaurantCell")
        
        // Refresh Control
        //self.refreshControl.bounds = CGRectMake((self.view.bounds.width - refreshControl.bounds.size.width)/2, 0, refreshControl.bounds.size.width,  refreshControl.bounds.size.height);
        self.refreshControl.addTarget(self, action: "manualRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        self.autoRefresh()
    }
    
    func manualRefresh(sender: AnyObject?) {
        // Should be instantiated by children
        self.refreshControl.endRefreshing()
    }
    
    func autoRefresh() {
        // AutoRefresh just call manual refresh function, after activating refreshControl
        println("autorefreshing");
        self.refreshControl.beginRefreshing()
        self.manualRefresh(self)
    }
    
    func loadingError() {
        self.refreshControl.endRefreshing()
        let alertController = UIAlertController(title: "Unable to refresh", message:
            "Please check your connectivity and try again", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
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
        if let s1 = self.poiDict[i1] {
            if let s2 = self.poiDict[i2] {
                return s1.name < s2.name
            }
        }
        return false
    }
    
    func sortByTimeAndStatus(i1: String, i2: String) -> Bool {
        if let s1 = self.poiDict[i1] as? Attraction {
            if let s2 = self.poiDict[i2] as? Attraction {
                if s1.status == 3 && s2.status == 3 {
                    if s1.waittime == s2.waittime {
                        return sortByName(i1, i2: i2)
                    } else {
                        return s1.waittime < s2.waittime
                    }
                } else {
                    if s1.status == s2.status {
                        return sortByName(i1, i2: i2)
                    } else {
                        return s1.status > s2.status
                    }
                }
            }
        }
        return false
    }
    
    func sortByDistance(i1: String, i2: String) -> Bool {
        if let s1 = self.poiDict[i1] as? Restaurant {
            if let s2 = self.poiDict[i2] as? Restaurant {
                if s1.distance < 0 && s2.distance < 0 {
                    return sortByName(i1, i2: i2)
                } else {
                    return s1.distance < s2.distance
                }
            }
        }
        return false
    }
    
    func sortBySearchText(i1: String, i2: String) -> Bool {
        if let s1 = self.poiDict[i1] {
            if let s2 = self.poiDict[i2] {
                if s1.searchInName(searchText) && !s2.searchInName(searchText) {
                    return true
                } else if s2.searchInName(searchText) && !s1.searchInName(searchText) {
                    return false
                } else {
                    return sortByName(i1, i2: i2)
                }
            }
        }
        return false
    }
    
    final func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poiIndexes.count
    }
    
    final func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let attraction = poiDict[ poiIndexes[indexPath.row] ] as? Attraction {
            let cell = tableView.dequeueReusableCellWithIdentifier("AttractionCell", forIndexPath: indexPath) as! AttractionCell
            
            cell.load(attraction: attraction)
            
            return cell
        }
        else if let restaurant = poiDict[ poiIndexes[indexPath.row] ] as? Restaurant {
            let cell = tableView.dequeueReusableCellWithIdentifier("RestaurantCell", forIndexPath: indexPath) as! RestaurantCell
            
            cell.load(restaurant: restaurant)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    final func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 76
    }
}
