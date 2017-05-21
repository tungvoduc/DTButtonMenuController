//
//  DTButtonMenuController.swift
//  Pods
//
//  Created by Admin on 13/03/2017.
//
//

import UIKit

public typealias DTButtonItemHandlerBlock = ((DTMenuButton) -> Void)

open class DTButtonMenuController: UIViewController {
    /// Point where all menu buttons will center around. This is the point where user starts the menu.
    public internal(set) var touchPoint: CGPoint = .zero
    
    /// Highlight view
    /// View that is highlighted when menu is displayed.
    public var highlightedView: UIView?
    
    /// Background color
    /// Background color of view controller when menu is displayed. 
    /// Default value if black.
    public var backgroundColor = UIColor.black.withAlphaComponent(0.7) {
        didSet {
            view.backgroundColor = backgroundColor
        }
    }
    
    /// shouldHighlightView indicates whether or not highlightedView should be highlighted when menu is displayed. 
    /// Default value if true.
    public var shouldHighlightView = true
    
    /// Indicates whether or not controller should be automatically dismissed when pressing a button item or background view.
    /// Default value is true.
    public var shouldDismissOnAction = true
    
    /// Size of each item
    public var itemSize: CGSize = CGSize(width: 60, height: 60)
    
    /// Array of actions
    var items = [DTMenuButton]()
    
    /// Transition controller
    var transitionController: TransitionController!
    
    public init(point: CGPoint) {
        super.init(nibName: nil, bundle: nil)
        touchPoint = point
        commonInit()
    }
    
    public init(highlightedView: UIView) {
        super.init(nibName: nil, bundle: nil)
    
        touchPoint = highlightedView.center
        self.highlightedView = highlightedView
        commonInit()
    }
    
    public init(highlightedView: UIView, point: CGPoint) {
        super.init(nibName: nil, bundle: nil)

        touchPoint = point
        self.highlightedView = highlightedView
        commonInit()
    }
    
    func commonInit() {
        transitionController = TransitionController(menuController: self)
        modalPresentationStyle = .custom
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor
        
        // Intial positions
        for item in items {
            item.view.center = touchPoint
            item.view.frame.size = itemSize
            view.addSubview(item.view)
        }
        
        if let highlightedView = highlightedView {
            if let superview = highlightedView.superview {
                let frame = (superview.convert(highlightedView.frame, to: self.view))
                let imageView = self.screenshotHighlightedView(view: highlightedView)
                imageView.frame = frame
                
                self.view.addSubview(imageView)
            }
        }
        
        view.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGestureRecognizer)
        
        // Do any additional setup after loading the view.
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Add an button item
    /// buttonConfiguration block gives the opportunity to customize UI of each button view
    /// completionHandler specifies action of each button
    public func addItem(_ item: DTMenuButton) {
        items.append(item)
        
        // Modify completion handler
        let handler = item.completionHandlerBlock
        item.completionHandlerBlock = {[weak self](item: DTMenuButton) in
            handler?(item)
            
            guard let strongSelf = self else { return }
            
            if strongSelf.shouldDismissOnAction {
                strongSelf.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    /// Calculate position of each items with this method.
    /// Size is the current size of view controller's view.
    /// Calculation of positions should based on size, touchPoint and itemSize.
    func calculateItemPositions(with size: CGSize) {
        let positioningProvider = ButtonPositioningDriver(numberOfButtons: items.count, buttonRadius: itemSize.width/2)
        let positions = positioningProvider.positionsOfItemsInView(with: self.view.bounds.size, at: touchPoint)
        for (index, position) in positions.enumerated() {
            items[index].position = position
        }
    }
    
    func viewTapped(_ gestureRecognizer: UIGestureRecognizer) {
        if shouldDismissOnAction {
            dismiss(animated: true, completion: nil)
        }
    }
    
    /// Screenshot highlighted view
    func screenshotHighlightedView(view: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        // view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFit
        imageView.bounds.size = view.frame.size
        
        return imageView
    }
}
