//
//  TUIGeometrySpec.m
//  RoomsTests
//
//  Created by Diego Lafuente on 29/05/14.
//  Copyright (c) 2014 Tui Travel A&D. All rights reserved.
//

#import "Kiwi.h"
#import "TUIGeometry.h"

SPEC_BEGIN(TUIGeometrySpec)

describe(@"TUIGeometrySpec", ^{
    
    CGPoint point1 = CGPointMake(3.45, 4.46);
    CGPoint point2 = CGPointMake(-2.21, 6.63);
    
    context(@"when calculating distance between two points", ^{
        
        it(@"should be commutative", ^{
            [[theValue([TUIGeometry distanceBetweenPoint:point1 andPoint:point2]) should] equal:theValue([TUIGeometry distanceBetweenPoint:point2 andPoint:point1])];
        });
    });
    
    context(@"when calculating angle of a line with respect to the x-axis", ^{
        
        it(@"should be calculate the opposite angle if the points are swapped", ^{
            CGFloat epsilon = 0.0000001;
            
            [[theValue(fabs([TUIGeometry angleWithTheXAxisAndLineDefinedByPoint:point1 andPoint:point2] - M_PI - [TUIGeometry angleWithTheXAxisAndLineDefinedByPoint:point2 andPoint:point1]) <= epsilon) should] beYes];
        });
    });
    
    context(@"when translating coordinates from a relative system to the absolute system", ^{
        
        CGPoint origin = CGPointMake(-6.0, 5.0);
        CGFloat rotation = 1.0;
        __block TUI2DCartesianCoordinatesSystem *relativeSystem = [[TUI2DCartesianCoordinatesSystem alloc] initWithOrigin:origin andRotation:rotation];
        
        it(@"should be translate the (0,0) to the origin of the relative system", ^{
            CGPoint translated = [TUIGeometry absoluteCoordinatesOfPoint:CGPointMake(0.0, 0.0) givenInCoordinateSystem:relativeSystem];
            [[theValue(translated.x) should] equal:theValue(origin.x)];
            [[theValue(translated.y) should] equal:theValue(origin.y)];
        });
        
        it(@"should translate the (3,2) point into the second quadrant", ^{
            CGPoint translated = [TUIGeometry absoluteCoordinatesOfPoint:CGPointMake(3.0, 2.0) givenInCoordinateSystem:relativeSystem];
            [[theValue(translated.x < 0.0) should] beYes];
            [[theValue(translated.y > 0.0) should] beYes];
        });
        
        it(@"should translate the (-10,2) point into the third quadrant", ^{
            CGPoint translated = [TUIGeometry absoluteCoordinatesOfPoint:CGPointMake(-10.0, 2.0) givenInCoordinateSystem:relativeSystem];
            [[theValue(translated.x < 0.0) should] beYes];
            [[theValue(translated.y < 0.0) should] beYes];
        });
        
        it(@"should leave the point intact if the relative system IS the absolute system", ^{
            TUI2DCartesianCoordinatesSystem *identity = [[TUI2DCartesianCoordinatesSystem alloc] initWithOrigin:CGPointMake(0.0, 0.0) andRotation:0.0];
            CGPoint point = CGPointMake(-3.67, 2.42);
            CGPoint translated = [TUIGeometry absoluteCoordinatesOfPoint:point givenInCoordinateSystem:identity];
            [[theValue(translated.x) should] equal:theValue(point.x)];
            [[theValue(translated.y) should] equal:theValue(point.y)];
        });
    });
    
    context(@"when calculating the intersection between two circles", ^{
        
        it(@"should return an empty array when the circles are the same", ^{
            TUICircle *circle = [[TUICircle alloc] initWithCenter:CGPointMake(5.6, -4.5) andRadius:3.23];
            NSArray *intersectionPoints = [TUIGeometry intersectionOfCircle:circle andCircle:circle];
            [[intersectionPoints should] beEmpty];
        });
        
        it(@"should return an empty array when the circles are concentric", ^{
            TUICircle *circle1 = [[TUICircle alloc] initWithCenter:CGPointMake(5.6, -4.5) andRadius:3.23];
            TUICircle *circle2 = [[TUICircle alloc] initWithCenter:CGPointMake(5.6, -4.5) andRadius:6.23];
            NSArray *intersectionPoints = [TUIGeometry intersectionOfCircle:circle1 andCircle:circle2];
            [[intersectionPoints should] beEmpty];
        });
        
        it(@"should return an empty array when the circles do not intersect", ^{
            TUICircle *circle1 = [[TUICircle alloc] initWithCenter:CGPointMake(5.6, -4.5) andRadius:3.23];
            TUICircle *circle2 = [[TUICircle alloc] initWithCenter:CGPointMake(5.6, 4.5) andRadius:4.23];
            NSArray *intersectionPoints = [TUIGeometry intersectionOfCircle:circle1 andCircle:circle2];
            [[intersectionPoints should] beEmpty];
        });
        
        it(@"should return two points in case of collision", ^{
            TUICircle *circle1 = [[TUICircle alloc] initWithCenter:CGPointMake(5.6, -4.5) andRadius:3.23];
            TUICircle *circle2 = [[TUICircle alloc] initWithCenter:CGPointMake(3.4, -2.7) andRadius:4.23];
            NSArray *intersectionPoints = [TUIGeometry intersectionOfCircle:circle1 andCircle:circle2];
            [[intersectionPoints should] haveLengthOf:2];
            [[theValue([(NSValue *)intersectionPoints[0] CGPointValue].x > 0.0) should] beYes];
            [[theValue([(NSValue *)intersectionPoints[0] CGPointValue].y < 0.0) should] beYes];
        });
        
        it(@"should be commutative", ^{
            TUICircle *circle1 = [[TUICircle alloc] initWithCenter:CGPointMake(-5.6, 4.5) andRadius:3.23];
            TUICircle *circle2 = [[TUICircle alloc] initWithCenter:CGPointMake(-3.4, 2.7) andRadius:4.23];
            
            NSArray *intersectionPoints = [TUIGeometry intersectionOfCircle:circle1 andCircle:circle2];
            NSArray *intersectionPointsReverse = [TUIGeometry intersectionOfCircle:circle2 andCircle:circle1];
    
            [[intersectionPoints should] haveLengthOf:2];
            [[theValue([(NSValue *)intersectionPoints[0] CGPointValue].x < 0.0) should] beYes];
            [[theValue([(NSValue *)intersectionPoints[0] CGPointValue].y > 0.0) should] beYes];
            
            CGFloat epsilon = 0.000001;
            
            if (fabs([(NSValue *)intersectionPoints[0] CGPointValue].x - [(NSValue *)intersectionPointsReverse[0] CGPointValue].x) <= epsilon &&
                fabs([(NSValue *)intersectionPoints[0] CGPointValue].y - [(NSValue *)intersectionPointsReverse[0] CGPointValue].y) <= epsilon)
            {
                [[theValue(fabs([(NSValue *)intersectionPoints[1] CGPointValue].x - [(NSValue *)intersectionPointsReverse[1] CGPointValue].x) <= epsilon) should] beYes];
                [[theValue(fabs([(NSValue *)intersectionPoints[1] CGPointValue].y - [(NSValue *)intersectionPointsReverse[1] CGPointValue].y) <= epsilon) should] beYes];
            }
            else
            {
                [[theValue(fabs([(NSValue *)intersectionPoints[0] CGPointValue].x - [(NSValue *)intersectionPointsReverse[1] CGPointValue].x) <= epsilon) should] beYes];
                [[theValue(fabs([(NSValue *)intersectionPoints[0] CGPointValue].y - [(NSValue *)intersectionPointsReverse[1] CGPointValue].y) <= epsilon) should] beYes];
                [[theValue(fabs([(NSValue *)intersectionPoints[1] CGPointValue].x - [(NSValue *)intersectionPointsReverse[0] CGPointValue].x) <= epsilon) should] beYes];
                [[theValue(fabs([(NSValue *)intersectionPoints[1] CGPointValue].y - [(NSValue *)intersectionPointsReverse[0] CGPointValue].y) <= epsilon) should] beYes];
            }
            
        });
    });
    
});

SPEC_END