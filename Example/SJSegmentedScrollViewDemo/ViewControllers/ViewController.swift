//
//  ViewController.swift
//  SJSegmentedScrollView
//
//  Created by Subins Jose on 06/10/2016.
//  Copyright © 2016 Subins Jose. All rights reserved.
//

import UIKit
import SJSegmentedScrollView

class ViewController: UIViewController {
    
    let segmentedViewController = SJSegmentedViewController()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "Segment"
    }
    
    var navigationBar: UINavigationBar {
        get {
            return (navigationController?.navigationBar)!
        }
    }
    //MARK:- Private Function
    //MARK:-
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.translucent = true
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationBar.shadowImage = UIImage()
    }
    
    func getSJSegmentedViewController() -> SJSegmentedViewController? {
        
        if let storyboard = self.storyboard {
            
            let headerViewController = storyboard
                .instantiateViewControllerWithIdentifier("HeaderViewController1")

            let firstViewController = storyboard
                .instantiateViewControllerWithIdentifier("FirstTableViewController")
            firstViewController.title = "Table View"
            
            let secondViewController = storyboard
                .instantiateViewControllerWithIdentifier("SecondViewController")
            secondViewController.title = "Custom View"
            
            let thirdViewController = storyboard
                .instantiateViewControllerWithIdentifier("ThirdViewController")
            thirdViewController.title = "View"
            
            segmentedViewController.headerViewController = headerViewController
            segmentedViewController.segmentControllers = [firstViewController,
                                                          secondViewController,
                                                          thirdViewController]
            segmentedViewController.headerViewHeight = 200
            segmentedViewController.delegate = self
        
            return segmentedViewController
        }
        
        return nil
    }
    
    //MARK:- Actions
    //MARK:-
    @IBAction func presentViewController() {
        
        let viewController = getSJSegmentedViewController()
        //        viewController
        if viewController != nil {
            self.presentViewController(viewController!,
                                       animated: true,
                                       completion: nil)
        }
    }
    
    @IBAction func pushViewController() {
        
        let viewController = getSJSegmentedViewController()
        
        if viewController != nil {
            self.navigationController?.pushViewController(viewController!,
                                                          animated: true)
        }
    }
    
    @IBAction func adddChildViewController() {
        
        let viewController = getSJSegmentedViewController()
        
        if viewController != nil {
            addChildViewController(viewController!)
            self.view.addSubview(viewController!.view)
            viewController!.view.frame = self.view.bounds
            viewController!.didMoveToParentViewController(self)
        }
    }
}

extension ViewController: SJSegmentedViewControllerDelegate {
    
    func didMoveToPage(controller: UIViewController, segment: UIButton?, index: Int) {
        
        if segmentedViewController.segments.count > 0 {
            
            let button = segmentedViewController.segments[index]
//            button.setTitleColor(UIColor(red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0), forState: .Selected)
        }
    }
}
