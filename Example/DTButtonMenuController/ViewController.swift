//
//  ViewController.swift
//  DTButtonMenuController
//
//  Created by tungvoduc on 03/12/2017.
//  Copyright (c) 2017 tungvoduc. All rights reserved.
//

import UIKit
import DTButtonMenuController

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var topButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for button in [button, bottomButton, topButton] {
            button!.layer.cornerRadius = 25
            button!.layer.masksToBounds = true
            button!.layer.borderColor = UIColor.black.cgColor
            button!.layer.borderWidth = 1
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonTapped(_ button: UIButton) {
        let viewController = DTButtonMenuController(highlightedView: button)
        viewController.itemSize = CGSize(width: 50, height: 50)
        viewController.itemsDistanceToTouchPoint = 100
        viewController.addItem(DTMenuButton(view: CustomItemView(type: UIButtonType.system), completionHandlerBlock: {(item: DTMenuButton) in
            print("Button 1")
        }))
        viewController.addItem(DTMenuButton(view: CustomItemView(type: UIButtonType.system), completionHandlerBlock: {(item: DTMenuButton) in
            print("Button 2")
        }))
        viewController.addItem(DTMenuButton(view: CustomItemView(type: UIButtonType.system), completionHandlerBlock: {(item: DTMenuButton) in
            print("Button 3")
        }))
        viewController.addItem(DTMenuButton(view: CustomItemView(type: UIButtonType.system), completionHandlerBlock: {(item: DTMenuButton) in
            print("Button 4")
        }))
        viewController.addItem(DTMenuButton(view: CustomItemView(type: UIButtonType.system), completionHandlerBlock: {(item: DTMenuButton) in
            print("Button 5")
        }))
        
        self.present(viewController, animated: true, completion: nil)
    }
}

/// Custom DTMenuItemView
class CustomItemView: DTMenuItemView {
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor(red: CGFloat(arc4random_uniform(256))/255, green: CGFloat(arc4random_uniform(256))/255, blue: CGFloat(arc4random_uniform(256))/255, alpha: 1.0)
    }
}

