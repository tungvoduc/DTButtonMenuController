//
//  ButtonPositioningDriver.swift
//  Pods
//
//  Created by Admin on 17/03/2017.
//
//

import UIKit

enum Position {
    case left
    case right
    case top
    case bottom
}

class ButtonPositioningDriver: NSObject {
    /// Number of buttons that will be displayed.
    var numberOfItems: Int
    
    var buttonAngle: Double
    
    /// Radius of button.
    var buttonRadius: CGFloat
    
    /// If not provide maxButtonsAngle, maxButtonsAngle will be automatically calculated by numberOfButtons, maxButtonsAngle = Pi/(numberOfButtons * 2)
    init(numberOfButtons: Int, buttonRadius radius: CGFloat, buttonsAngle angle: Double = Double.pi/6) {
        numberOfItems = numberOfButtons
        buttonRadius = radius
        
        buttonAngle = angle
        
        super.init()
    }
    
    func positionsOfItemsInView(with size: CGSize, at touchPoint: CGPoint) -> [CGPoint] {
        // Get sin of angle (which is half of button angle
        let radius = getRadiusOfCirleIntesectsCircleCenter(with: buttonRadius, angle: buttonAngle)
        let positions = suitablePositionsInView(with: size, at: touchPoint, radius: radius)
        
        var points = [CGPoint]()
        
        for _ in 0...(numberOfItems - 1) {
            points.append(CGPoint(x: CGFloat(arc4random_uniform(300)), y: CGFloat(arc4random_uniform(500))))
        }
        
        return points
    }
    
    func getRadiusOfCirleIntesectsCircleCenter(with radius: CGFloat, angle: Double) -> CGFloat {
        let sinus = sin(angle/2)
        return radius/CGFloat(sinus)
    }
    
    func suitablePositionsInView(with size: CGSize, at touchPoint: CGPoint, radius: CGFloat) -> [Position] {
        // Get distance to four sides of view
        let leftDistance = touchPoint.x
        let topDistance = touchPoint.y
        let rightDistance = size.width - touchPoint.x
        let bottomDistance = size.height - touchPoint.y
        let offset: CGFloat = 50
        var positions = [Position]()
        
        if leftDistance - offset > radius {
            positions.append(.left)
        }
        
        if topDistance - offset > radius {
            positions.append(.top)
        }
        
        if rightDistance - offset > radius {
            positions.append(.right)
        }
        
        if bottomDistance - offset > radius {
            positions.append(.bottom)
        }
        
        return positions
    }
}
