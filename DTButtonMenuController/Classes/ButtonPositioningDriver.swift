//
//  ButtonPositioningDriver.swift
//  Pods
//
//  Created by Admin on 17/03/2017.
//
//

import UIKit

enum ButtonPositionDriverType {
    case Satellite
    case Arc
}

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
    
    /// Positioning type
    var positioningType: ButtonPositionDriverType
    
    /// Arc
    var buttonsArc: Double = Double.pi * 3 / 2
    
    /// Distance from touchPoint to a button
    var distance: CGFloat = 24.0
    
    /// If not provide maxButtonsAngle, maxButtonsAngle will be automatically calculated by numberOfButtons, maxButtonsAngle = Pi/(numberOfButtons * 2)
    init(numberOfButtons: Int, buttonRadius radius: CGFloat, buttonsAngle angle: Double = Double.pi/6, positioningType type: ButtonPositionDriverType = .Satellite) {
        numberOfItems = numberOfButtons
        buttonRadius = radius
        
        buttonAngle = angle
        
        positioningType = type;
        
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
    
    private func angleBetweenTwoButtons() -> Double {
        let totalAngle = numberOfItems - 1 == 0 ? 0.0 : buttonsArc;
        
        switch positioningType {
        case .Arc:
            return totalAngle / Double(numberOfItems - 1)
        case .Satellite:
            return Double.pi / Double(numberOfItems - 1)
        }
    }
    
    
    private func fromAngleAndToAngleInView(withSize size: CGSize, atPoint point: CGPoint) -> [Double] {
        var fromAngle = 0.0;
        var toAngle = 0.0;
        
        if (positioningType == .Satellite) {
            fromAngle = 0.0;
            toAngle = Double.pi * 2;
        } else {
            if (buttonsArc >= Double.pi * 2) {
                fromAngle = (buttonsArc - Double.pi) / 2
                toAngle = fromAngle - buttonsArc
            } else {
                fromAngle = -(Double.pi - buttonsArc) / 2
                toAngle = -(Double.pi - fromAngle) / 2
            }
        }
        
        // Now recalculate fromAngle and to Angle if the button is not fully visible on screen.
        // fromPoint and toPoint are two point on
        
        let fromPointX: CGFloat = (distance + buttonRadius) * cos(CGFloat(fromAngle)) + point.x
        let fromPointY: CGFloat = (distance + buttonRadius) * sin(CGFloat(fromAngle)) + point.y
        
        let toPointX: CGFloat = (distance + buttonRadius) * cos(CGFloat(toAngle)) + point.x
        let toPointY: CGFloat = (distance + buttonRadius) * sin(CGFloat(toAngle)) + point.y
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        let fromPointIsInView = rect.contains(CGPoint(x: fromPointX, y: fromPointY))
        let toPointIsInView = rect.contains(CGPoint(x: toPointX, y: toPointY))
        
        if (!fromPointIsInView || !toPointIsInView) {
            if (!fromPointIsInView) {
                
            }
        }
        
        return [fromAngle, toAngle];
    }
}
