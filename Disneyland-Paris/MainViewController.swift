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
    
    let navBarColor = UIColor(red: 66.0/255.0, green: 145.0/255.0, blue: 211.0/255.0, alpha: 1.0)
    let backgroundColor =  UIColor.groupTableViewBackgroundColor()
    var pageMenu : CAPSPageMenu?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var controllerArray : [UIViewController] = []
        
        // Instantiating views
        var controller = self.storyboard!.instantiateViewControllerWithIdentifier("attractionsView") as! UIViewController
        controller.title = "Attractions"
        controllerArray.append(controller)
        
        controller = self.storyboard!.instantiateViewControllerWithIdentifier("restaurantsView") as! UIViewController
        controller.title = "Restaurants"
        controllerArray.append(controller)
        
        controller = self.storyboard!.instantiateViewControllerWithIdentifier("spectaclesView") as! UIViewController
        controller.title = "Spectacles"
        controllerArray.append(controller)
        
        // Customization
        var parameters: [CAPSPageMenuOption] = [
            .ScrollMenuBackgroundColor(navBarColor),
            .ViewBackgroundColor(backgroundColor),
            .SelectionIndicatorColor(UIColor.whiteColor()),
            .UnselectedMenuItemLabelColor(UIColor(white: 1, alpha: 0.5)),
            .MenuItemSeparatorColor(UIColor(white: 1, alpha: 0)),
            .BottomMenuHairlineColor(navBarColor),
            .MenuHeight(40.0),
            .UseMenuLikeSegmentedControl(true)
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

