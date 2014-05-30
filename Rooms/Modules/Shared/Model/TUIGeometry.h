//
//  TUIGeometry.h
//  Rooms
//
//  Created by Diego Lafuente on 29/05/14.
//  Copyright (c) 2014 Tui Travel A&D. All rights reserved.
//

#import "TUIBaseModel.h"
//Models
#import "TUICircle.h"
#import "TUI2DCartesianCoordinatesSystem.h"

/**
 TUIGeometry provides a set of static geometric utility functions
 */
@interface TUIGeometry : TUIBaseModel

/**
 @methodName distanceBetweenPoint:andPoint:
 @abstract Calculates the distance between two points
 @discussion This method calculates and returns the distance between two points
 
 @param firstPoint The first point
 @param secondPoint The secong circle
 
 @return The distance between two given points
 */
+ (CGFloat)distanceBetweenPoint:(CGPoint)firstPoint
                       andPoint:(CGPoint)secondPoint;

/**
 @methodName angleWithTheXAxisAndLineDefinedByPoint:andPoint:
 @abstract Calculates the angle formed by a line and the x-axis of the reference system
 @discussion This method calculates the angle of a line defined by two points and the
 x-axis of the reference system. It takes into account the order of the points.
 firstPoint is the origin of the vector and secondPoint the end.If you swap the points,
 the angle will change its sign.
 
 @param firstPoint The point in the relative coordinate syste,
 @param secondCircle The relative coordinate system referred to the "absolute" reference system
 
 @return The (x,y) coordinates of a given point in the "absolute" reference system
 */
+ (CGFloat)angleWithTheXAxisAndLineDefinedByPoint:(CGPoint)firstPoint
                                         andPoint:(CGPoint)secondPoint;

/**
 @methodName absoluteCoordinatesOfPoint:givenInCoordinateSystem:
 @abstract Calculates the "absolute" coordinates of a point given its relative coordinates
 @discussion This method takes a point (x,y) whose coordinates are expressed with
 respect to a relative coordinates system, and translates these coordinates to the "absolute"
 coordinate system.
 
 @param point The point in the relative coordinate syste,
 @param secondCircle The relative coordinate system referred to the "absolute" reference system
 
 @return The (x,y) coordinates of a given point in the "absolute" reference system
 */
+ (CGPoint)absoluteCoordinatesOfPoint:(CGPoint)point
              givenInCoordinateSystem:(TUI2DCartesianCoordinatesSystem *)coordinateSystem;

/**
 @methodName intersectionOfCircle:andCircle:
 @abstract Calculates the intersection between two circles
 @discussion This method calculates and returns the intersection between two given circles
 
 @param firstCircle The first circle
 @param secondCircle The second circle
 
 @return An array of CGPoints. This array could contain 0, 1 or 2 points
 */
+ (NSArray *)intersectionOfCircle:(TUICircle *)firstCircle
                        andCircle:(TUICircle *)secondCircle;


@end
