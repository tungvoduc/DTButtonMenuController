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

enum TouchPointPosition {
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    case center
}

class ButtonPositioningDriver: NSObject {
    
    /// Automatically shrink the arc of buttons
    var shouldShrinkArc = true
    
    /// Number of buttons that will be displayed.
    var numberOfItems: Int
    
    var buttonAngle: Double
    
    /// Radius of button.
    var buttonRadius: CGFloat
    
    /// Positioning type
    var positioningType: ButtonPositionDriverType
    
    /// Arc
    var buttonsArc: Double = Double.pi / 2 + Double.pi / 6
    
    /// Distance from touchPoint to a button
    var distance: CGFloat = 80.0
    
    /// Allow the buttons and the distance from touchPoint to the button center to be scaled
    var scaleable: Bool = false
    
    /// Margin to the edge to the screen or the defined view
    var margin: CGFloat = 8.0
    
    /// If not provide maxButtonsAngle, maxButtonsAngle will be automatically calculated by numberOfButtons, maxButtonsAngle = Pi/(numberOfButtons * 2)
    init(numberOfButtons: Int = 1, buttonRadius radius: CGFloat, buttonsAngle angle: Double = Double.pi/6, positioningType type: ButtonPositionDriverType = .Arc) {
        numberOfItems = numberOfButtons
        buttonRadius = radius
        
        buttonAngle = angle
        
        positioningType = type;
        
        super.init()
    }
    
    func positionsOfItemsInView(with size: CGSize, at touchPoint: CGPoint) -> [CGPoint] {
        var points = [CGPoint]()
        
        let fromAndToAngles = self.fromAngleAndToAngleInView(withSize: size, atPoint: touchPoint)
        let fromAngle = fromAndToAngles[0]
        let toAngle = fromAndToAngles[1]
        
        var startingAngle = 0.0
        
        let difference = toAngle - fromAngle
        
        let sign = toAngle - fromAngle > 0 ? 1.0 : -1.0
        var step = (buttonsArc * sign) / Double(numberOfItems - 1)
        
        if fabs(difference) > buttonsArc {
            startingAngle = difference > 0 ? (difference - buttonsArc) / 2 : (difference +  buttonsArc) / 2
        }
        
        if fabs(difference) < buttonsArc {
            if (shouldShrinkArc) {
                step = fabs(difference) * sign / Double(numberOfItems - 1)
            }
        }
        
        for i in 0 ..< numberOfItems {
            let angle = step * Double(i) + fromAngle + startingAngle;
            let x = touchPoint.x + (distance + buttonRadius) * CGFloat(cos(angle))
            let y = touchPoint.y + (distance + buttonRadius) * CGFloat(sin(angle))
            let point = CGPoint(x: x, y: y)
            points.append(point)
        }
        
        return points
    }
    
    private func fromAngleAndToAngleInView(withSize size: CGSize, atPoint point: CGPoint) -> [Double] {
        var fromAngle = 0.0;
        var toAngle = 0.0;
        
        if (positioningType == .Satellite) {
            fromAngle = 0.0;
            toAngle = Double.pi * 2;
        } else {
            if (buttonsArc > Double.pi * 2) {
                fromAngle = (buttonsArc - Double.pi) / 2
                toAngle = fromAngle - buttonsArc
            } else {
                fromAngle = -(Double.pi - buttonsArc) / 2
                toAngle = -(Double.pi -  abs(fromAngle))
            }
        }
        
        let outerRadius: CGFloat = distance +  buttonRadius * 2 + margin;
        let touchPointInset = self.distanceOfTouchPointToEdges(touchPoint: point, inViewWithSize: size)
        let touchPointPosition = self.touchPointPositionInView(withSize: size, touchPoint: point)
        
        // This version prioritises to display the buttons to the TOP therefore it does not check touchPointInset.bottom > outerRadius
        if (touchPointInset.top > outerRadius && touchPointInset.left > outerRadius && touchPointInset.right > outerRadius) {
            return [fromAngle, toAngle]
        }
        
        if (touchPointInset.top < outerRadius && touchPointInset.left > outerRadius && touchPointInset.right > outerRadius) {
            return [-fromAngle, -toAngle]
        }
        
        if (touchPointInset.top > outerRadius && touchPointInset.bottom > outerRadius && touchPointInset.left < touchPointInset.right) {
            return [-(Double.pi / 2 + fromAngle), (Double.pi / 2 + fromAngle)]
        }
        
        if (touchPointInset.top > outerRadius && touchPointInset.bottom > outerRadius && touchPointInset.left > touchPointInset.right) {
            return [(Double.pi / 2 + fromAngle) - Double.pi, (Double.pi / 2 + fromAngle) - Double.pi - buttonsArc]
        }
        
        let thresholdPoints = self.thresholdPointsOfButtonsArcInView(withSize: size, atTouchPoint: point);
        let firstPoint = thresholdPoints[0];
        let secondPoint = thresholdPoints[1];
        
        var firstAngle: Double = (Double)(self.angleBetweenHorizontalLineAndLineHasCenterPointAndAnotherPoint(centerPoint: point, anotherPoint: firstPoint))
        var secondAngle: Double = (Double)(self.angleBetweenHorizontalLineAndLineHasCenterPointAndAnotherPoint(centerPoint: point, anotherPoint: secondPoint))
        
        if (firstAngle > secondAngle) {
            let temp = secondAngle
            secondAngle = firstAngle
            firstAngle = temp
        }
        
        if touchPointPosition == .topLeft || touchPointPosition == .bottomLeft {
            //secondAngle = secondAngle < 0 ? Double.pi + fabs(Double.pi - fabs(secondAngle)) : secondAngle
        } else if touchPointPosition == .topRight || touchPointPosition == .bottomRight {
            secondAngle = secondAngle > 0 ? -(Double.pi * 2 - secondAngle) : secondAngle;
        }
        return [firstAngle, secondAngle];
    }
    
    
    private func touchPointPositionInView(withSize size: CGSize, touchPoint:CGPoint) -> TouchPointPosition {
        let rect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        let centerPoint = CGPoint(x: size.width/2 + rect.origin.x, y: size.height/2 + rect.origin.y)
        var touchPosition: TouchPointPosition = .center
        
        if touchPoint.x <= centerPoint.x && touchPoint.y <= centerPoint.y {
            touchPosition = .topLeft
        }
        
        if touchPoint.x >= centerPoint.x && touchPoint.y <= centerPoint.y {
            touchPosition = .topRight
        }
        
        if touchPoint.x <= centerPoint.x && touchPoint.y >= centerPoint.y {
            touchPosition = .bottomLeft
        }
        
        if touchPoint.x >= centerPoint.x && touchPoint.y >= centerPoint.y {
            touchPosition = .bottomRight
        }
        
        return touchPosition
    }
    
    private func thresholdPointsOfButtonsArcInView(withSize size: CGSize, atTouchPoint point: CGPoint) -> [CGPoint]  {
        
        let marginX: CGFloat = margin;
        let marginY: CGFloat = margin;
        let arcRadius: CGFloat = distance + buttonRadius * 2 + margin;
        
        let touchPointInset = self.distanceOfTouchPointToEdges(touchPoint: point, inViewWithSize: size)
        let touchPointPosition = self.touchPointPositionInView(withSize: size, touchPoint: point)
        
        var fromPointOffsetXSign: CGFloat = 1
        var fromPointOffsetYSign: CGFloat = 1
        var toPointOffsetXSign: CGFloat = 1
        var toPointOffsetYSign: CGFloat = 1
        
        switch touchPointPosition {
        case .topLeft:
            fromPointOffsetXSign = touchPointInset.top >= arcRadius ? -1 : 1
            fromPointOffsetYSign = marginY + buttonRadius >= touchPointInset.top ? -1 : 1
            toPointOffsetXSign = 1
            toPointOffsetYSign = 1
            
        case .topRight:
            fromPointOffsetXSign = touchPointInset.top >= arcRadius ? 1 : -1
            fromPointOffsetYSign = marginY + buttonRadius >= touchPointInset.top  ? -1 : 1
            toPointOffsetXSign = -1
            toPointOffsetYSign = 1
            
        case .bottomLeft:
            fromPointOffsetXSign = touchPointInset.bottom >= arcRadius ? -1 : 1
            fromPointOffsetYSign = marginY + buttonRadius >= touchPointInset.bottom ? 1 : -1
            toPointOffsetXSign = 1
            toPointOffsetYSign = -1
            
        case .bottomRight:
            fromPointOffsetXSign = touchPointInset.bottom >= arcRadius ? 1 : -1
            fromPointOffsetYSign = marginY + buttonRadius >= touchPointInset.bottom ? 1 : -1
            toPointOffsetXSign = -1
            toPointOffsetYSign = -1
            
        default:
            fromPointOffsetXSign = -1
            fromPointOffsetYSign = -1
            toPointOffsetXSign = 1
            toPointOffsetYSign = -1
        }
        
        let closestHorizontalDistanceToEdge = touchPointInset.left > touchPointInset.right ? touchPointInset.right : touchPointInset.left
        let closestVerticalDistanceToEdge = touchPointInset.top > touchPointInset.bottom ? touchPointInset.bottom : touchPointInset.top
        
        let offsetX: CGFloat = sqrt(pow(arcRadius, 2) - pow(max(abs((closestHorizontalDistanceToEdge - (marginX + buttonRadius))), (marginX + buttonRadius)), 2))
        let offsetY: CGFloat = sqrt(pow(arcRadius, 2) - pow(max(abs((closestVerticalDistanceToEdge - (marginY + buttonRadius))), (marginY + buttonRadius)), 2))
        
        let baseFromPointX = point.x;
        let baseFromPointY = touchPointPosition == .topLeft || touchPointPosition == .topRight ? 0.0 : size.height;
        let baseToPointX = touchPointPosition == .topLeft || touchPointPosition == .bottomLeft ? 0.0 : size.width;
        let baseToPointY = point.y;
        
        let fromPoint: CGPoint = CGPoint(x: baseFromPointX + fromPointOffsetXSign * offsetX, y: baseFromPointY + (marginY + buttonRadius) * fromPointOffsetYSign)
        let toPoint: CGPoint = CGPoint(x:baseToPointX + (marginX + buttonRadius) * toPointOffsetXSign, y: baseToPointY + toPointOffsetYSign * offsetY)
        
        return [fromPoint, toPoint]
    }
    
    private func distanceOfTouchPointToEdges(touchPoint point: CGPoint, inViewWithSize size: CGSize) -> UIEdgeInsets {
        
        var edgeInsets : UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        edgeInsets.top = point.y
        edgeInsets.bottom = size.height - edgeInsets.top
        edgeInsets.left = point.x
        edgeInsets.right = size.width - point.x
        
        return edgeInsets
    }
    
    private func angleBetweenHorizontalLineAndLineHasCenterPointAndAnotherPoint(centerPoint: CGPoint, anotherPoint: CGPoint) -> CGFloat {
        let sign: CGFloat = anotherPoint.y < centerPoint.y ? -1 : 1
        let isObstubeAngle: Bool = anotherPoint.x < centerPoint.x ? true : false
        let horizontalLength = fabs(centerPoint.x - anotherPoint.x)
        let verticalLength = fabs(centerPoint.y - anotherPoint.y)
        var angle = atan(verticalLength/horizontalLength)
        
        if isObstubeAngle {
            angle = ((CGFloat)(Double.pi) - angle) * sign
        } else {
            angle = angle * sign
        }
        
        return angle
    }
}
