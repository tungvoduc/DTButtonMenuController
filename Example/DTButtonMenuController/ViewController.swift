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
        
        for button: UIButton in [button, bottomButton, topButton] {
            button.layer.cornerRadius = 25
            button.layer.masksToBounds = true
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 1
        }
    }

    @IBAction func buttonTapped(_ button: UIButton) {
        let viewController = DTButtonMenuController(highlightedView: button)
        viewController.itemSize = CGSize(width: 50, height: 50)
        viewController.itemsDistanceToTouchPoint = 100
        
        for i in 1...5 {
            viewController.addItem(DTMenuButton(view: CustomItemView(type: .system), completionHandlerBlock: {(item: DTMenuButton) in
                print("Button \(i) tapped!")
            }))
        }
        
        present(viewController, animated: true, completion: nil)
    }
}

/// Custom DTMenuItemView
class CustomItemView: DTMenuItemView {
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = UIColor.random()
    }
}

private extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1.0)
    }
}

