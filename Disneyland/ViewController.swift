//
//  ViewController.swift
//  Disneyland
//
//  Created by Thomas Durand on 07/01/2015.
//  Copyright (c) 2015 Dean151. All rights reserved.
//

import UIKit

enum typeOfSort: Int {
    case byName=0, byWaitTimes, byDistance
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    var refreshControl:UIRefreshControl!
    
    var sortType: typeOfSort = .byWaitTimes
    var searchText: String = ""
    
    var attractions = [String]()
    var restaurants = [String]()
    
    // FIXME favorite and search only in attraction/restaurant
    var favorites = [String]()
    var search = [String]()
    
    var pois = Dictionary<String, Poi>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // Nib for CustomCell
        var nib = UINib(nibName: "WaitTimeCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "waitTimeCell")
        
        // Refresh handler on top
        self.refreshControl = UIRefreshControl()
        self.refreshControl.bounds = CGRectMake((self.view.bounds.width - refreshControl.bounds.size.width)/2, 0, refreshControl.bounds.size.width,  refreshControl.bounds.size.height);
        self.refreshControl.addTarget(self, action: "manualRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        // Manualy load poi
        self.autoRefresh()
        
        // Load favorites
        let defaults = NSUserDefaults.standardUserDefaults()
        if let favs = defaults.arrayForKey("favorites")
        {
            for fav in favs {
                if let f = fav as? String {
                    favorites.append(f)
                }
            }
        }
    }
    
    func manualRefresh(sender: AnyObject?) {
        if pois.isEmpty {
            // In this case, we need to get poi first
            self.getPois() {
                self.refreshControl.endRefreshing()
            }
        } else {
            // We just need to get variable data
            self.getWaitTimesAndOpeningTimes() {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func autoRefresh() {
        // AutoRefresh just call manual refresh function, after activating refreshControl
        println("autorefreshing");
        self.refreshControl.beginRefreshing()
        self.manualRefresh(self)
    }
    
    // To see attractions OR restaurants
    var indexes: [String] {
        get {
            return attractions;
        }
        set(value) {
            attractions = value
        }
    }
    
    func getPois(completion: () -> Void) {
        self.getAttractions() {
            completion()
        }
        self.getRestaurants() {
            completion()
        }
    }
    
    func getWaitTimesAndOpeningTimes(completion: () -> Void) {
        self.getWaitTimes() {
            completion()
        }
        self.getOpeningTimes() {
            completion()
        }
    }
    
    func getAttractions(completion: () -> Void) {
        DataManager.getUrlWithSuccess(url: attractionsURL, success: { (attractions, error) -> Void in
            if let e = error {
                self.loadingError()
            } else if let attractionsList = attractions {
                let json = JSON(data: attractionsList)
                
                for (index: String, subJson: JSON) in json {
                    if let identifier = subJson["idbio"].string {
                        if let title = subJson["title"].string {
                            if let desc = subJson["description"].string {
                                if let long = subJson["coord_x"].double {
                                    if let lat = subJson["coord_y"].double {
                                        let att = Attraction(id: identifier, title: title, description: desc, latitude: lat, longitude: long)
                                        self.pois.updateValue(att, forKey: identifier)
                                        self.attractions.append(identifier)
                                    }
                                }
                            }
                        }
                    }
                }
                self.sort(beginEndUpdate: false)
                println("Success to get attractions")
                self.getWaitTimes() {
                    completion()
                }
            } else {
                self.loadingError()
            }
        })
    }
    
    func getRestaurants(completion: () -> Void) {
        DataManager.getUrlWithSuccess(url: restaurantsURL, success: { (attractions, error) -> Void in
            if let e = error {
                self.loadingError()
            } else if let attractionsList = attractions {
                let json = JSON(data: attractionsList)
                
                for (index: String, subJson: JSON) in json {
                    if let identifier = subJson["idbio"].string {
                        if let title = subJson["title"].string {
                            if let desc = subJson["description"].string {
                                if let long = subJson["coord_x"].double {
                                    if let lat = subJson["coord_y"].double {
                                        let att = Restaurant(id: identifier, title: title, description: desc, latitude: lat, longitude: long)
                                        self.pois.updateValue(att, forKey: identifier)
                                        self.restaurants.append(identifier)
                                    }
                                }
                            }
                        }
                    }
                }
                self.sort(beginEndUpdate: false)
                println("Success to get restaurants")
                self.getOpeningTimes() {
                    completion()
                }
            } else {
                self.loadingError()
            }
        })
    }
    
    func getWaitTimes(completion: () -> Void) {
        DataManager.getUrlWithSuccess(url: waitTimesURL, success: { (waitTimes, error) -> Void in
            if let e = error {
                self.loadingError()
            } else if let waitTimesList = waitTimes {
                let json = JSON(data: waitTimesList)
                
                for (index: String, subJson: JSON) in json {
                    if let identifier = subJson["idbio"].string {
                        if let poi = self.pois[identifier] as? Attraction {
                            if let opening = subJson["opening"].string {
                                if let closing = subJson["closing"].string {
                                    if let open = subJson["open"].int {
                                        if let waitTime = subJson["waittime"].int {
                                            poi.update(open: open, opening: opening, closing: closing)
                                            poi.waittime = waitTime
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                self.sort(beginEndUpdate: true)
                println("Success to get waittimes")
                completion()
            } else {
                self.loadingError()
            }
        })
    }
    
    func getOpeningTimes(completion: () -> Void) {
        DataManager.getUrlWithSuccess(url: ouvertureURL, success: { (waitTimes, error) -> Void in
            if let e = error {
                self.loadingError()
            } else if let waitTimesList = waitTimes {
                let json = JSON(data: waitTimesList)
                
                for (index: String, subJson: JSON) in json {
                    if let identifier = subJson["idbio"].string {
                        if let poi = self.pois[identifier] as? Restaurant {
                            if let opening = subJson["opening"].string {
                                if let closing = subJson["closing"].string {
                                    if let open = subJson["open"].int {
                                        poi.update(open: open, opening: opening, closing: closing)
                                    }
                                }
                            }
                        }
                    }
                }
                self.sort(beginEndUpdate: true)
                println("Success to get opening times")
                completion()
            } else {
                self.loadingError()
            }
        })
    }
    
    func loadingError() {
        self.refreshControl.endRefreshing()
        let alertController = UIAlertController(title: "Unable to refresh", message:
            "Please check your connectivity and try again", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    // FAVORITES
    
    func saveFavorites() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(favorites, forKey: "favorites")
    }
    
    func addFavorite(indexPath: NSIndexPath) {
        let identifier = self.indexes[indexPath.row]
        
        if find(self.favorites, identifier) == nil {
            self.tableView.beginUpdates()
            
            self.favorites.append(identifier)
            self.saveFavorites()
            
            if self.favorites.count == 1 {
                self.tableView.insertSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
            }
            
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: self.favorites.count-1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Right)
            
            // TODO replace sort by finding in which row we should insert the cell
            self.sort(beginEndUpdate: false)
            self.tableView.endUpdates()
        }
    }
    
    func removeFavorite(indexPath: NSIndexPath) {
        // Removing a favorite
        self.tableView.beginUpdates()
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        
        self.favorites.removeAtIndex(indexPath.row)
        self.saveFavorites()
        
        if self.favorites.isEmpty {
            self.tableView.deleteSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Fade)
        }
        self.tableView.endUpdates()
    }
    
    // SORT FUNCTIONS
    func sort(#beginEndUpdate: Bool) {
        switch sortType {
        case .byDistance:
            self.indexes.sort(self.sortByDistance)
            self.favorites.sort(self.sortByDistance)
        case .byWaitTimes:
            self.indexes.sort(self.sortByTimeAndStatus)
            self.favorites.sort(self.sortByTimeAndStatus)
        default:
            self.indexes.sort(self.sortByName)
            self.favorites.sort(self.sortByName)
        }
        
        if beginEndUpdate { self.tableView.beginUpdates() }
        self.tableView.reloadData()
        if beginEndUpdate { self.tableView.endUpdates() }
    }
    
    // COMPARISON FUNCTIONS FOR SORT FUNCTIONS
    func sortByName(i1: String, i2: String) -> Bool {
        if let s1 = self.pois[i1] {
            if let s2 = self.pois[i2] {
                return s1.title < s2.title
            }
        }
        return false
    }
    
    func sortByTimeAndStatus(i1: String, i2: String) -> Bool {
        if let s1 = self.pois[i1] as? Attraction {
            if let s2 = self.pois[i2] as? Attraction {
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
        if let s1 = self.pois[i1] as? Restaurant {
            if let s2 = self.pois[i2] as? Restaurant {
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
        if let s1 = self.pois[i1] {
            if let s2 = self.pois[i2] {
                if s1.searchInTitle(searchText) && !s2.searchInTitle(searchText) {
                    return true
                } else if s2.searchInTitle(searchText) && !s1.searchInTitle(searchText) {
                    return false
                } else {
                    return sortByName(i1, i2: i2)
                }
            }
        }
        return false
    }
    
    // SEARCH FUNCTIONS
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        search.removeAll(keepCapacity: false)
        self.searchText = searchText
        if !searchText.isEmpty {
            for (identifier, poi) in pois {
                // We look for matches in name AND descriptions (allow keywords like 'mine' for Big Thunder Mountain)
                if poi.searchInTitle(searchText) || poi.searchInDescription(searchText) {
                    search.append(identifier)
                }
            }
            search.sort(sortBySearchText)
        }
    }
    
    // TABLE VIEW FUNCTIONS
    
    // Get 2 sections if there is favorite, 1 otherwise
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == searchDisplayController!.searchResultsTableView {
            return 1
        } else {
            return favorites.count != 0 ? 2: 1
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == searchDisplayController!.searchResultsTableView {
            return nil
        } else {
            return favorites.count != 0 && section == 0 ? "Favorites": nil
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == searchDisplayController!.searchResultsTableView {
            return search.count
        } else {
            return favorites.count != 0 && section == 0 ? favorites.count: indexes.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 74
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Getting the corresponding identifier
        var identifier: String
        if tableView == searchDisplayController!.searchResultsTableView {
            identifier = search[indexPath.row]
        } else {
            if favorites.count != 0 && indexPath.section == 0 {
                identifier = favorites[indexPath.row]
            } else {
                identifier = indexes[indexPath.row]
            }
        }
        
        if let poi = pois[identifier] as? Restaurant {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("waitTimeCell") as WaitTimeCell
            
            // if it is an attraction
            if let attraction = poi as? Attraction {
                cell.load(attraction)
            } else {
                cell.load(poi)
            }
            
            return cell
        }
        
        // Unknown cell, like unloaded favorites
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        return cell
    }
    
    func tableView(tableView: UITableView!, editActionsForRowAtIndexPath indexPath: NSIndexPath!) -> [AnyObject]! {
        if favorites.count != 0 && indexPath.section == 0 && tableView != searchDisplayController!.searchResultsTableView  {
            var deleteAction = UITableViewRowAction(style: .Default, title: "Delete") { (action, indexPath) -> Void in
                tableView.editing = false
                
                // Removing a favorite
                self.removeFavorite(indexPath)
            }
            return [deleteAction]
        } else {
            var addFavAction = UITableViewRowAction(style: .Default, title: "Favorite") { (action, indexPath) -> Void in
                tableView.editing = false
                
                // Adding a favorite
                self.addFavorite(indexPath)
            }
            addFavAction.backgroundColor = UIColor(hexadecimal: "#FFCC00") // Favorite orange/yellow
            return [addFavAction]
        }
        
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
    }
}

