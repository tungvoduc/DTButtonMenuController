//
//  DTButtonMenuControllerDelegate.swift
//  Pods
//
//  Created by Admin on 13/03/2017.
//
//

import Foundation

@objc public protocol DTButtonMenuControllerDelegate: NSObjectProtocol {
    func buttonMenuController(_ controller: DTButtonMenuController, didSelectButtonItem: DTMenuButton)
}
