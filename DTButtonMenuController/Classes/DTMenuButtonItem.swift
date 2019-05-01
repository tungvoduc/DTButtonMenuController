//
//  DTMenuButtonItem.swift
//  Pods
//
//  Created by tungvoduc on 13/03/2017.
//
//

import Foundation

public final class DTMenuButton: NSObject {
    public init(view: DTMenuItemView = DTMenuItemView(type: .custom), completionHandlerBlock: DTButtonItemHandlerBlock?) {
        super.init()
        self.view = view
        self.completionHandlerBlock = completionHandlerBlock
        view.addTarget(self, action: #selector(buttonTapped(_:)), for: UIControl.Event.touchUpInside)
    }
    
    /// Handler for item
    public var completionHandlerBlock: DTButtonItemHandlerBlock?
    
    /// View presenting for the item
    public var view: UIView!
    
    /// Final position of item when displaying on menu controller. Public get only.
    var position: CGPoint = CGPoint.zero
    
    @objc func buttonTapped(_ button: UIButton) {
        completionHandlerBlock?(self)
    }
}

/// Class DTMenuButtonView.
/// Default view class for view in DTMenuButton.
open class DTMenuItemView: UIButton {
    
}



