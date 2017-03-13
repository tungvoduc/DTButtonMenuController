//
//  DTButtonMenuController.swift
//  Pods
//
//  Created by Admin on 13/03/2017.
//
//

import UIKit

public typealias DTButtonConfigurationBlock = ((DTMenuButtonView) -> Void)
public typealias DTButtonCompletionHandlerBlock = ((DTMenuButtonItem) -> Void)

open class DTButtonMenuController: UIViewController {
    /// Point where all menu buttons will center around. This is the point where user starts the menu.
    public internal(set) var touchPoint: CGPoint?
    
    /// Highlight view
    /// View that is highlighted when menu is displayed.
    public var highlightedView: UIView?
    
    /// Background color
    /// Background color of view controller when menu is displayed. 
    /// Default value if black.
    public var backgroundColor = UIColor.black
    
    /// shouldHighlightView indicates whether or not highlightedView should be highlighted when menu is displayed. 
    /// Default value if true.
    public var shouldHighlightView = true
    
    /// Indicates whether or not controller should be automatically dismissed when pressing a button item or background view.
    /// Default value is true.
    public var shouldDismissOnAction = true
    
    /// Array of actions
    var actions = [DTMenuButtonAction]()
    
    init(point: CGPoint) {
        super.init(nibName: nil, bundle: nil)
        touchPoint = point
    }
    
    init(highlightedView: UIView?) {
        super.init(nibName: nil, bundle: nil)
        self.highlightedView = highlightedView
        
        // Calculate point from highlighted view as well here
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Add an button item
    /// buttonConfiguration block gives the opportunity to customize UI of each button view
    /// completionHandler specifies action of each button
    public func addItem(_ item: DTMenuButtonItem, buttonConfiguration: DTButtonConfigurationBlock?, completionHandler: DTButtonCompletionHandlerBlock?) {
        let action = DTMenuButtonAction(item: item, configurationBlock: buttonConfiguration, completionHandlerBlock: completionHandler)
        actions.append(action)
    }
}

/// Class DTMenuButtonAction
internal class DTMenuButtonAction: NSObject {
    let item: DTMenuButtonItem
    var configurationBlock: DTButtonConfigurationBlock?
    var completionHandlerBlock: DTButtonCompletionHandlerBlock?
    
    convenience init(item buttonItem: DTMenuButtonItem) {
        self.init(item: buttonItem, configurationBlock: nil, completionHandlerBlock: nil)
    }
    
    init(item buttonItem: DTMenuButtonItem, configurationBlock: DTButtonConfigurationBlock?, completionHandlerBlock: DTButtonCompletionHandlerBlock?) {
        item = buttonItem
        super.init()
        self.configurationBlock = configurationBlock
        self.completionHandlerBlock = completionHandlerBlock
    }
}
