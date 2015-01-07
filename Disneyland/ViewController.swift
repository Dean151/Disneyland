//
//  ViewController.swift
//  Disneyland
//
//  Created by Thomas Durand on 07/01/2015.
//  Copyright (c) 2015 Dean151. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    
    var indexes = [String]()
    var favorites = [String]()
    
    var pois = Dictionary<String, Poi>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Get 2 sections if there is favorite, 1 otherwise
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return favorites.count != 0 ? 2: 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return favorites.count != 0 && section == 0 ? "Favoris": nil
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count != 0 && section == 0 ? favorites.count: indexes.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Getting the corresponding identifier
        var identifier: String
        if favorites.count != 0 && indexPath.section == 0 {
            identifier = favorites[indexPath.row]
        } else {
            identifier = indexes[indexPath.row]
        }
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.textLabel?.text = identifier
        return cell
    }
}

