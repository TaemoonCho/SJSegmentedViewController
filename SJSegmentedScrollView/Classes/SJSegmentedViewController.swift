//
//  SJSegmentedViewController.swift
//  Pods
//
//  Created by Subins Jose on 20/06/16.
//  Copyright © 2016 Subins Jose. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//    associated documentation files (the "Software"), to deal in the Software without restriction,
//    including without limitation the rights to use, copy, modify, merge, publish, distribute,
//    sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//    substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

@objc public protocol SJSegmentedViewControllerDelegate {
    
    optional func didSelectSegmentAtIndex(index:Int)
    
    /**
     Method to identify the current controller and segment of contentview
     
     - parameter controller: Current controller
     - parameter segment: selected segment
     - parameter index: index of selected segment.
     */
    optional func didMoveToPage(controller: UIViewController, segment: UIButton?, index: Int)
    
    optional func didChangedContentOffset(scrollView: UIScrollView, offset: CGPoint)
}

/**
 *  Public protocol of  SJSegmentedViewController for content changes and makes the scroll effect.
 */
@objc public protocol SJSegmentedViewControllerViewSource {
    
    /**
     By default, SJSegmentedScrollView will observe the default view of viewcontroller for content
     changes and makes the scroll effect. If you want to change the default view, implement
     SJSegmentedViewControllerViewSource and pass your custom view.
     
     - parameter controller: UIViewController for segment
     - parameter index:      index of segment controller
     
     - returns: observe view
     */
    optional func viewForSegmentControllerToObserveContentOffsetChange(controller: UIViewController,
                                                                       index: Int) -> UIView
}

/**
 *  Public class for customizing and setting our segmented scroll view
 */
@objc public class SJSegmentedViewController: UIViewController, SJSegmentedScrollViewDelegate {
    
    /**
     *  The headerview height for 'Header'.
     *
     *  By default the height will be 0.0
     *
     *  segmentedViewController.headerViewHeight = 200.0
     */
    public var headerViewHeight: CGFloat = 0.0 {
        didSet {
            segmentedScrollView.headerViewHeight = headerViewHeight
        }
    }
    
    /**
     *  Set height for segment view.
     *
     *  By default the height is 40.0
     *
     *  segmentedViewController.segmentViewHeight = 60.0
     */
    public var segmentViewHeight: CGFloat = 40.0 {
        didSet {
            segmentedScrollView.segmentViewHeight = segmentViewHeight
        }
    }
    
    /**
     *  Set headerview offset height.
     *
     *  By default the height is 0.0
     *
     *  segmentedViewController. headerViewOffsetHeight = 10.0
     */
    public var headerViewOffsetHeight: CGFloat = 0.0 {
        didSet {
            self.segmentedScrollView.headerViewOffsetHeight = headerViewOffsetHeight
        }
    }
    
    /**
     *  Set color for selected segment.
     *
     *  By default the color is light gray.
     *
     *  segmentedViewController.selectedSegmentViewColor = UIColor.redColor()
     */
    public var selectedSegmentViewColor = UIColor.lightGrayColor() {
        didSet {
            segmentedScrollView.selectedSegmentViewColor = selectedSegmentViewColor
        }
    }
    
    /**
     *  Set height for selected segment view.
     *
     *  By default the height is 5.0
     *
     *  segmentedViewController.selectedSegmentViewHeight = 5.0
     */
    public var selectedSegmentViewHeight: CGFloat = 5.0 {
        didSet {
            segmentedScrollView.selectedSegmentViewHeight = selectedSegmentViewHeight
        }
    }
    
    /**
     *  Set color for segment title.
     *
     *  By default the color is black.
     *
     *  segmentedViewController.segmentTitleColor = UIColor.redColor()
     */
    public var segmentTitleColor = UIColor.blackColor() {
        didSet {
            segmentedScrollView.segmentTitleColor = segmentTitleColor
        }
    }
    
    /**
     *  Set color for segment background.
     *
     *  By default the color is white.
     *
     *  segmentedViewController.segmentBackgroundColor = UIColor.whiteColor()
     */
    public var segmentBackgroundColor = UIColor.whiteColor() {
        didSet {
            segmentedScrollView.segmentBackgroundColor = segmentBackgroundColor
        }
    }
    
    /**
     *  Set shadow for segment.
     *
     *  By default the color is light gray.
     *
     *  segmentedViewController.segmentShadow = SJShadow.light()
     */
    public var segmentShadow = SJShadow() {
        didSet {
            segmentedScrollView.segmentShadow = segmentShadow
        }
    }
    
    /**
     *  Set font for segment title.
     *
     *  segmentedViewController.segmentTitleFont = UIFont.systemFontOfSize(14.0)
     */
    public var segmentTitleFont = UIFont.systemFontOfSize(14.0) {
        didSet {
            segmentedScrollView.segmentTitleFont = segmentTitleFont
        }
    }
    
    /**
     *  Set bounce for segment.
     *
     *  By default it is set to false.
     *
     *  segmentedViewController.segmentBounces = true
     */
    public var segmentBounces = false {
        didSet {
            segmentedScrollView.segmentBounces = segmentBounces
        }
    }
    
    /**
     *  Set ViewController for header view.
     */
    public var headerViewController: UIViewController? {
        didSet {
            setDefaultValuesToSegmentedScrollView()
        }
    }
    
    /**
     *  Array of ViewControllers for segments.
     */
    public var segmentControllers = [UIViewController]() {
        didSet {
            setDefaultValuesToSegmentedScrollView()
        }
    }
    
    /**
     *  Array of segments. For single view controller segments will be empty.
     */
    public var segments: [UIButton] {
        get {
            
            if let segmentView = segmentedScrollView.segmentView {
                return segmentView.segments
            }
            
            return [UIButton]()
        }
    }
    
    public var delegate:SJSegmentedViewControllerDelegate?
    var viewObservers = [UIView]()
    var segmentedScrollView = SJSegmentedScrollView(frame: CGRectZero)
    var segmentScrollViewTopConstraint: NSLayoutConstraint?
    //var gradientHeaderView = GradientHeaderView(frame: CGRect(x: 0, y: 0, width: 375, height: 64) )
    var gradientHeaderView = GradientHeaderView(frame: CGRectZero)
    
    /**
     Custom initializer for SJSegmentedViewController.
     
     - parameter headerViewController: A UIViewController
     - parameter segmentControllers:   Array of UIViewControllers for segments.
     
     */
    convenience public init(headerViewController: UIViewController?,
                            segmentControllers: [UIViewController]) {
        self.init(nibName: nil, bundle: nil)
        self.headerViewController = headerViewController
        self.segmentControllers = segmentControllers
        setDefaultValuesToSegmentedScrollView()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        for view in viewObservers {
            view.removeObserver(self,
                                forKeyPath: "contentOffset",
                                context: nil)
        }
    }
    
    override public func loadView() {
        super.loadView()
        addSegmentedScrollView()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        addGradientHeaderView()
        loadControllers()
    }
    
    
    /**
     * Update view as per the current layout
     */
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        let topSpacing = SJUtil.getTopSpacing(self)
        let topSpacing = CGFloat(0)
        segmentedScrollView.topSpacing = topSpacing
        segmentedScrollView.bottomSpacing = SJUtil.getBottomSpacing(self)
        segmentScrollViewTopConstraint?.constant = topSpacing
        segmentedScrollView.updateSubviewsFrame(self.view.bounds)
    }
    
    /**
     * Set the default values for the segmented scroll view.
     */
    func setDefaultValuesToSegmentedScrollView() {
        
        segmentedScrollView.contentOffsetDelegate       = self
        segmentedScrollView.selectedSegmentViewColor    = self.selectedSegmentViewColor
        segmentedScrollView.selectedSegmentViewHeight   = self.selectedSegmentViewHeight
        segmentedScrollView.segmentTitleColor           = self.segmentTitleColor
        segmentedScrollView.segmentBackgroundColor      = self.segmentBackgroundColor
        segmentedScrollView.segmentShadow               = self.segmentShadow
        segmentedScrollView.segmentTitleFont            = self.segmentTitleFont
        segmentedScrollView.segmentBounces              = self.segmentBounces
        segmentedScrollView.headerViewHeight            = self.headerViewHeight
        segmentedScrollView.headerViewOffsetHeight      = self.headerViewOffsetHeight
        segmentedScrollView.segmentViewHeight           = self.segmentViewHeight
    }
    
    func addGradientHeaderView() {
        self.view.addSubview(gradientHeaderView)
        gradientHeaderView.frame = CGRectMake(0, 0, view.frame.size.width, 64)
    }
    
    /**
     * Private method for adding the segmented scroll view.
     */
    func addSegmentedScrollView() {
        
        let topSpacing = SJUtil.getTopSpacing(self)
        segmentedScrollView.topSpacing = topSpacing
        
        let bottomSpacing = SJUtil.getBottomSpacing(self)
        segmentedScrollView.bottomSpacing = bottomSpacing
        
        self.view.addSubview(segmentedScrollView)
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[scrollView]-0-|",
                                                                                   options: [],
                                                                                   metrics: nil,
                                                                                   views: ["scrollView": segmentedScrollView])
        self.view.addConstraints(horizontalConstraints)
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[scrollView]-bp-|",
                                                                                 options: [],
                                                                                 metrics: ["tp": topSpacing,
                                                                                    "bp": bottomSpacing],
                                                                                 views: ["scrollView": segmentedScrollView])
        self.view.addConstraints(verticalConstraints)
        
        segmentScrollViewTopConstraint = NSLayoutConstraint(item: segmentedScrollView,
                                                            attribute: .Top,
                                                            relatedBy: .Equal,
                                                            toItem: self.view,
                                                            attribute: .Top,
                                                            multiplier: 1.0,
                                                            constant: topSpacing)
        self.view.addConstraint(segmentScrollViewTopConstraint!)
        
        segmentedScrollView.setContentView()
        
        // selected segment at index
        segmentedScrollView.didSelectSegmentAtIndex = {(segment,index) in
            let selectedController = self.segmentControllers[index]
            
            self.delegate?.didMoveToPage?(selectedController, segment: segment!, index: index)
            
        }
    }
    
    /**
     Method for adding the HeaderViewController into the container
     
     - parameter headerViewController: Header ViewController.
     */
    func addHeaderViewController(headerViewController: UIViewController) {
        
        self.addChildViewController(headerViewController)
        segmentedScrollView.addHeaderView(headerViewController.view)
        headerViewController.didMoveToParentViewController(self)
    }
    
    /**
     Method for adding the array of content ViewControllers into the container
     
     - parameter contentControllers: array of ViewControllers
     */
    func addContentControllers(contentControllers: [UIViewController]) {
        
        viewObservers.removeAll()
        segmentedScrollView.addSegmentView(contentControllers, frame: self.view.bounds)
        
        var index = 0
        for controller in contentControllers {
            
            self.addChildViewController(controller)
            segmentedScrollView.addContentView(controller.view, frame: self.view.bounds)
            controller.didMoveToParentViewController(self)
            
            let delegate = controller as? SJSegmentedViewControllerViewSource
            var observeView = controller.view
            
            if let view = delegate?.viewForSegmentControllerToObserveContentOffsetChange!(controller,
                                                                                          index: index) {
                observeView = view
            }
            
            viewObservers.append(observeView)
            segmentedScrollView.addObserverFor(view: observeView)
            index += 1
        }
        
        segmentedScrollView.segmentView?.contentView = segmentedScrollView.contentView
    }
    
    /**
     * Method for loading content ViewControllers and header ViewController
     */
    func loadControllers() {
        
        if headerViewController == nil  {
            headerViewController = UIViewController()
        }
        
        addHeaderViewController(headerViewController!)
        addContentControllers(segmentControllers)
        
        
        //Delegate call for setting the first view of segments.
        var segment: UIButton?
        if segments.count > 0 {
            segment = self.segments[0]
        }
        
        delegate?.didMoveToPage?(segmentControllers[0],
                                 segment: segment,
                                 index: 0)
    }
    
    
    // MARK : - SJSegmentedScrollViewDelegate
    func scrollViewContentOffsetChanged(scrollView: SJSegmentedScrollView, offset: CGPoint) {
        self.delegate?.didChangedContentOffset?(scrollView, offset: offset)
        let openRate = offset.y / (self.headerViewHeight - 64)
        var colorPoint = openRate + 0.15
        if colorPoint > 1.0 {
            colorPoint = 1.0
        }
        
        print("openRate \(openRate)")
        print("colorPoint \(colorPoint)")
        let startColor = UIColor(red: colorPoint, green: colorPoint, blue: colorPoint, alpha: 1.0)
        let endColor = UIColor(red: colorPoint, green: colorPoint, blue: colorPoint, alpha: openRate)

        self.gradientHeaderView.changeStartColor(startColor)
        self.gradientHeaderView.changeEndColor(endColor)
    }
}
