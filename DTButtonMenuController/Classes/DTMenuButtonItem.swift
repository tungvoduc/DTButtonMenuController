//
//  DTMenuButtonItem.swift
//  Pods
//
//  Created by Admin on 13/03/2017.
//
//

import Foundation
open class DTMenuButtonItem: NSObject {
    public required init(id: AnyHashable) {
        super.init()
        self.id = id
    }

    public var id: AnyHashable!
}

