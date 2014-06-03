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
    
    context(@"when calculating the angle between 2 vectors", ^{
        
        it(@"should return 0.0 if the two vectors are zero", ^{
            CGPoint vector1 = CGPointZero;
            CGPoint vector2 = CGPointZero;
            
            CGFloat result = [TUIGeometry angleBetweenVector:vector1 andVector:vector2];
            
            [[theValue(result) should] equal:theValue(ZERO_FLOAT)];
        });
        
        it(@"should return 0.0 if one of the vectors is zero", ^{
            CGPoint vector1 = CGPointZero;
            CGPoint vector2 = CGPointMake(3.87, -5.89);
            
            CGFloat result = [TUIGeometry angleBetweenVector:vector1 andVector:vector2];
            CGFloat reverseResult = [TUIGeometry angleBetweenVector:vector2 andVector:vector1];
            
            [[theValue(result) should] equal:theValue(ZERO_FLOAT)];
            [[theValue(reverseResult) should] equal:theValue(ZERO_FLOAT)];
        });
        
        it(@"should return 0.0 if the two vectors are the same", ^{
            CGFloat result = [TUIGeometry angleBetweenVector:point1 andVector:point1];
            
            [[theValue(result) should] equal:theValue(ZERO_FLOAT)];
        });
        
        it(@"should return complementary angles when swapping vectors", ^{
            CGPoint vector1 = CGPointMake(2.34, -1.32);
            CGPoint vector2 = CGPointMake(-4.67, -7.32);;
            
            CGFloat result = [TUIGeometry angleBetweenVector:vector1 andVector:vector2];
            CGFloat reverseResult = [TUIGeometry angleBetweenVector:vector2 andVector:vector1];
            
            [[theValue(result + reverseResult) should] equal:TWO_PI withDelta:EPSILON];
        });
        
        it(@"should return an angle bwtween 0 and TWO_PI", ^{
            CGPoint vector1 = CGPointMake(10, 1);
            CGPoint vector2 = CGPointMake(10, 2);
            
            CGFloat angle = [TUIGeometry angleBetweenVector:vector1 andVector:vector2];
            [[theValue(angle > 0.0) should] beYes];
            [[theValue(M_PI_2 - angle > 0.0) should] beYes];
            
            vector2 = CGPointMake(-2, 2);
            angle = [TUIGeometry angleBetweenVector:vector1 andVector:vector2];
            [[theValue(angle - M_PI_2 > 0.0) should] beYes];
            [[theValue(M_PI - angle > 0.0) should] beYes];
            
            vector2 = CGPointMake(-2, -2);
            angle = [TUIGeometry angleBetweenVector:vector1 andVector:vector2];
            [[theValue(angle - M_PI > 0.0) should] beYes];
            [[theValue(3*M_PI_2 - angle > 0.0) should] beYes];
            
            vector2 = CGPointMake(10, -1);
            angle = [TUIGeometry angleBetweenVector:vector1 andVector:vector2];
            [[theValue(angle - 3*M_PI_2 > 0.0) should] beYes];
            [[theValue(TWO_PI - angle > 0.0) should] beYes];
        });
    });
    
    context(@"when calculating angle of a line with respect to the x-axis", ^{
        
        it(@"should be calculate the complementary angle if the points are swapped", ^{
            
            [[theValue(fabs([TUIGeometry angleWithTheXAxisAndLineDefinedByPoint:point1 andPoint:point2] - [TUIGeometry angleWithTheXAxisAndLineDefinedByPoint:point2 andPoint:point1])) should] equal:M_PI withDelta:EPSILON];
        });
    });
    
    context(@"when translating coordinates from a relative system to the absolute system", ^{
        
        CGPoint origin = CGPointMake(-6.0, 5.0);
        CGFloat rotation = ONE_FLOAT;
        __block TUI2DCartesianCoordinatesSystem *relativeSystem = [[TUI2DCartesianCoordinatesSystem alloc] initWithOrigin:origin andRotation:rotation];
        
        it(@"should be translate the (0,0) to the origin of the relative system", ^{
            CGPoint translated = [TUIGeometry absoluteCoordinatesOfPoint:CGPointZero givenInCoordinateSystem:relativeSystem];
            [[theValue(translated.x) should] equal:theValue(origin.x)];
            [[theValue(translated.y) should] equal:theValue(origin.y)];
        });
        
        it(@"should translate the (3,2) point into the second quadrant", ^{
            CGPoint translated = [TUIGeometry absoluteCoordinatesOfPoint:CGPointMake(3.0, 2.0) givenInCoordinateSystem:relativeSystem];
            [[theValue(translated.x < ZERO_FLOAT) should] beYes];
            [[theValue(translated.y > ZERO_FLOAT) should] beYes];
        });
        
        it(@"should translate the (-10,2) point into the third quadrant", ^{
            CGPoint translated = [TUIGeometry absoluteCoordinatesOfPoint:CGPointMake(-10.0, 2.0) givenInCoordinateSystem:relativeSystem];
            [[theValue(translated.x < ZERO_FLOAT) should] beYes];
            [[theValue(translated.y < ZERO_FLOAT) should] beYes];
        });
        
        it(@"should leave the point intact if the relative system IS the absolute system", ^{
            TUI2DCartesianCoordinatesSystem *identity = [[TUI2DCartesianCoordinatesSystem alloc] initWithOrigin:CGPointZero andRotation:ZERO_FLOAT];
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
            [[theValue([(NSValue *)intersectionPoints[0] CGPointValue].x > ZERO_FLOAT) should] beYes];
            [[theValue([(NSValue *)intersectionPoints[0] CGPointValue].y < ZERO_FLOAT) should] beYes];
        });
        
        it(@"should be commutative", ^{
            TUICircle *circle1 = [[TUICircle alloc] initWithCenter:CGPointMake(-5.6, 4.5) andRadius:3.23];
            TUICircle *circle2 = [[TUICircle alloc] initWithCenter:CGPointMake(-3.4, 2.7) andRadius:4.23];
            
            NSArray *intersectionPoints = [TUIGeometry intersectionOfCircle:circle1 andCircle:circle2];
            NSArray *intersectionPointsReverse = [TUIGeometry intersectionOfCircle:circle2 andCircle:circle1];
    
            [[intersectionPoints should] haveLengthOf:2];
            [[theValue([(NSValue *)intersectionPoints[0] CGPointValue].x < ZERO_FLOAT) should] beYes];
            [[theValue([(NSValue *)intersectionPoints[0] CGPointValue].y > ZERO_FLOAT) should] beYes];
            
            if (fabs([(NSValue *)intersectionPoints[0] CGPointValue].x - [(NSValue *)intersectionPointsReverse[0] CGPointValue].x) <= EPSILON &&
                fabs([(NSValue *)intersectionPoints[0] CGPointValue].y - [(NSValue *)intersectionPointsReverse[0] CGPointValue].y) <= EPSILON)
            {
                [[theValue([(NSValue *)intersectionPoints[1] CGPointValue].x) should] equal:[(NSValue *)intersectionPointsReverse[1] CGPointValue].x withDelta:EPSILON];
                [[theValue([(NSValue *)intersectionPoints[1] CGPointValue].y) should] equal:[(NSValue *)intersectionPointsReverse[1] CGPointValue].y withDelta:EPSILON];
            }
            else
            {
                [[theValue([(NSValue *)intersectionPoints[0] CGPointValue].x) should] equal:[(NSValue *)intersectionPointsReverse[1] CGPointValue].x withDelta:EPSILON];
                [[theValue([(NSValue *)intersectionPoints[0] CGPointValue].y) should] equal:[(NSValue *)intersectionPointsReverse[1] CGPointValue].y withDelta:EPSILON];
                [[theValue([(NSValue *)intersectionPoints[1] CGPointValue].x) should] equal:[(NSValue *)intersectionPointsReverse[0] CGPointValue].x withDelta:EPSILON];
                [[theValue([(NSValue *)intersectionPoints[1] CGPointValue].y) should] equal:[(NSValue *)intersectionPointsReverse[0] CGPointValue].y withDelta:EPSILON];
            }
            
        });
    });
    
});

SPEC_END