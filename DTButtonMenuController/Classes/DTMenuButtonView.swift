//
//  DTMenuButtonView.swift
//  Pods
//
//  Created by Admin on 13/03/2017.
//
//

import UIKit

open class DTMenuButtonView: UIButton {
    var buttonItem: DTMenuButtonItem!
    
    init(item: DTMenuButtonItem) {
        super.init(frame: CGRect.zero)
        self.buttonItem = item
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
