//
//  TUI2DCartesianCoordinatesSystemSpec.m
//  RoomsTests
//
//  Created by Diego Lafuente on 29/05/14.
//  Copyright (c) 2014 Tui Travel A&D. All rights reserved.
//

#import "Kiwi.h"
#import "TUI2DCartesianCoordinatesSystem.h"

SPEC_BEGIN(TUI2DCartesianCoordinatesSystemSpec)

describe(@"TUI2DCartesianCoordinatesSystemSpec", ^{
    
    CGFloat kRotation = 2.34;
    CGPoint kOrigin = CGPointMake(5.34, 3.25);
    
    context(@"when being initialized", ^{
        TUI2DCartesianCoordinatesSystem *system = [[TUI2DCartesianCoordinatesSystem alloc] initWithOrigin:kOrigin andRotation:kRotation];
        
        it(@"should have the right center and radius", ^{
            [[theValue(system.rotation) should] equal:theValue(kRotation)];
            [[theValue(system.origin.x) should] equal:theValue(kOrigin.x)];
            [[theValue(system.origin.y) should] equal:theValue(kOrigin.y)];
        });
    });
    
});

SPEC_END
