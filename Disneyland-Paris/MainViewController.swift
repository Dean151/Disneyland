//
//  ViewController.swift
//  Disneyland-Paris
//
//  Created by Thomas Durand on 15/06/2015.
//  Copyright (c) 2015 Dean. All rights reserved.
//

import UIKit
import PageMenu

class MainViewController: UIViewController {
    
    var pageMenu : CAPSPageMenu?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Getting rid of hidious bottom border of navigationbar
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
        var controllerArray : [UIViewController] = []
        
        let controllersAvailable : [String] = ["attractionsView", "restaurantsView", "spectaclesView"]//, "shopsView"]
        
        // Instantiating views
        var controller: UIViewController!
        
        for identifier in controllersAvailable {
            controller = self.storyboard!.instantiateViewControllerWithIdentifier(identifier) as! UIViewController
            controllerArray.append(controller)
        }
        
        // Customization
        var parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(navBarColor),
            .ViewBackgroundColor(backgroundColor),
            .SelectionIndicatorColor(UIColor.whiteColor()),
            .UnselectedMenuItemLabelColor(UIColor(white: 1, alpha: 0.5)),
            .MenuItemSeparatorColor(UIColor(white: 1, alpha: 0)),
            .BottomMenuHairlineColor(navBarColor),
            .MenuItemFont(UIFont.systemFontOfSize(15.0)),
            .UseMenuLikeSegmentedControl(true),
            .MenuItemWidthBasedOnTitleTextWidth(true),
            .CenterMenuItems(false)
        ]
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
        
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu!.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

