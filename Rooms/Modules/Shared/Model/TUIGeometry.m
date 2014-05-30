//
//  TUIGeometry.m
//  Rooms
//
//  Created by Diego Lafuente on 29/05/14.
//  Copyright (c) 2014 Tui Travel A&D. All rights reserved.
//

#import "TUIGeometry.h"

#pragma mark - Implementation

@implementation TUIGeometry

+ (CGFloat)distanceBetweenPoint:(CGPoint)firstPoint
                       andPoint:(CGPoint)secondPoint
{
    CGFloat xDistance = secondPoint.x - firstPoint.x;
    CGFloat yDistance = secondPoint.y - firstPoint.y;
    return sqrt((xDistance * xDistance) + (yDistance * yDistance));
}

+ (CGFloat)angleWithTheXAxisAndLineDefinedByPoint:(CGPoint)firstPoint
                                         andPoint:(CGPoint)secondPoint
{
    if (CGPointEqualToPoint(firstPoint, secondPoint))
    {
        return 0.0;
    }
    
    CGFloat deltaX = secondPoint.x - firstPoint.x;
    CGFloat deltaY = secondPoint.y - firstPoint.y;
    
    if (deltaX == 0.0)
    {
        return deltaY > 0.0 ? M_PI_2 : -M_PI_2;
    }
    
    if (deltaY == 0.0)
    {
        return deltaX > 0.0 ? 0.0 : M_PI;
    }
    
    return atan2(deltaY, deltaX);
}

+ (CGPoint)absoluteCoordinatesOfPoint:(CGPoint)point
              givenInCoordinateSystem:(TUI2DCartesianCoordinatesSystem *)coordinateSystem
{
    CGFloat sinAlpha = sin(coordinateSystem.rotation);
    CGFloat cosAlpha = cos(coordinateSystem.rotation);
    
    return CGPointMake((coordinateSystem.origin.x + (point.x * cosAlpha) - (point.y * sinAlpha)),
                       (coordinateSystem.origin.y + (point.x * sinAlpha) + (point.y * cosAlpha)));
}

+ (NSArray *)intersectionOfCircle:(TUICircle *)firstCircle
                        andCircle:(TUICircle *)secondCircle
{
    NSArray *relativeIntersectionPoints = nil;
    CGFloat distance = [TUIGeometry distanceBetweenPoint:firstCircle.center andPoint:secondCircle.center];
    
    // if the distance is zero or higher that firstCircle.radius + secondCircle.radius, then return an empy array
    if (distance == 0.0 || distance > (firstCircle.radius + secondCircle.radius))
    {
        return @[];
    }
    
    // We calculate the intersection point referred to a system centered on firstCircle with the x axis "looking at" secondCircle
    CGFloat relativeX = ((distance * distance) + (firstCircle.radius * firstCircle.radius) - (secondCircle.radius * secondCircle.radius)) / (2 * distance);
    CGFloat relativeSquareY = (firstCircle.radius * firstCircle.radius) - (relativeX * relativeX);
    // Check if relativeSquareY is a positive number
    if (relativeSquareY < 0.0)
    {
        return @[];
    }
    // check if the circles are tangent
    if (relativeSquareY == 0.0)
    {
        relativeIntersectionPoints = @[[NSValue valueWithCGPoint:CGPointMake(relativeX, 0.0)]];
    }
    else
    {
        CGFloat relativeY = sqrt(relativeSquareY);
        relativeIntersectionPoints = @[[NSValue valueWithCGPoint:CGPointMake(relativeX, relativeY)], [NSValue valueWithCGPoint:CGPointMake(relativeX, -relativeY)]];
    }
    
    //Create the relative coordinates system to perform the transformation
    CGFloat rotation = [TUIGeometry angleWithTheXAxisAndLineDefinedByPoint:firstCircle.center andPoint:secondCircle.center];
    TUI2DCartesianCoordinatesSystem *relativeCoordinatesSystem = [[TUI2DCartesianCoordinatesSystem alloc] initWithOrigin:firstCircle.center
                                                                                                             andRotation:rotation];
    // return the absolute coordinates of the intersection points
    NSMutableArray *absoluteIntersectionPoints = [NSMutableArray array];
    
    for (NSValue *relativePoint in relativeIntersectionPoints)
    {
        CGPoint absolutePoint = [TUIGeometry absoluteCoordinatesOfPoint:[relativePoint CGPointValue] givenInCoordinateSystem:relativeCoordinatesSystem];
        [absoluteIntersectionPoints addObject:[NSValue valueWithCGPoint:absolutePoint]];
    }
    //return result
    return absoluteIntersectionPoints;
}

@end
