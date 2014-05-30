//
//  TUICircleSpec.m
//  RoomsTests
//
//  Created by Diego Lafuente on 29/05/14.
//  Copyright (c) 2014 Tui Travel A&D. All rights reserved.
//

#import "Kiwi.h"
#import "TUICircle.h"

SPEC_BEGIN(TUICircleSpec)

describe(@"TUICircleSpec", ^{
    
    CGFloat kRadius = 10.34;
    CGPoint kCenter = CGPointMake(5.34, 3.25);
    
    context(@"when being initialized", ^{
        TUICircle *circle = [[TUICircle alloc] initWithCenter:kCenter andRadius:kRadius];
        
        it(@"should have the right center and radius", ^{
            [[theValue(circle.radius) should] equal:theValue(kRadius)];
            [[theValue(circle.center.x) should] equal:theValue(kCenter.x)];
            [[theValue(circle.center.y) should] equal:theValue(kCenter.y)];
        });
    });
    
});

SPEC_END