//
//  TUIFloorPlanSpec.m
//  RoomsTests
//
//  Created by Diego Lafuente on 30/05/14.
//  Copyright (c) 2014 Tui Travel A&D. All rights reserved.
//

#import "Kiwi.h"
#import "TUIFloorPlan.h"
#import "TUIFloorPlan_Testing.h"

SPEC_BEGIN(TUIFloorPlanSpec)

describe(@"TUIFloorPlanSpec", ^{
    
    context(@"when querying for the floor list", ^{
        
        it(@"should return the right results", ^{
            NSArray *floors = [[TUIFloorPlan sharedInstanceForTesting] floorList];
            [[floors should] haveLengthOf:1];
            [[floors[0] should] equal:@"testFloor"];
        });
    });
    
    context(@"when querying for the room list", ^{
        
        it(@"should return the right results", ^{
            NSArray *rooms = [[TUIFloorPlan sharedInstanceForTesting] roomList];
            [[rooms should] haveLengthOf:1];
            [[rooms[0] should] equal:@"testRoom"];
        });
    });
    
    context(@"when querying for the room list for a particular floor", ^{
        
        it(@"should return an empty array if the floor does not exist", ^{
            NSArray *rooms = [[TUIFloorPlan sharedInstanceForTesting] roomListForFloor:@"unexistingFloor"];
            [[rooms should] haveLengthOf:0];
        });
        
        it(@"should return the right results for a valid floor", ^{
            NSArray *rooms = [[TUIFloorPlan sharedInstanceForTesting] roomListForFloor:@"testFloor"];
            [[rooms should] haveLengthOf:1];
            [[rooms[0] should] equal:@"testRoom"];
        });
    });
    
    context(@"when querying for the location of a room", ^{
        
        it(@"should return an invalid location if the room does not exist", ^{
            CGPoint location = [[TUIFloorPlan sharedInstanceForTesting] locationForRoom:@"unexistingRoom"];
            [[theValue(location.x) should] equal:theValue(INVALID_X_COORDINATE)];
            [[theValue(location.y) should] equal:theValue(INVALID_Y_COORDINATE)];
        });
        
        it(@"should return the right results for a valid room", ^{
            CGPoint location = [[TUIFloorPlan sharedInstanceForTesting] locationForRoom:@"testRoom"];
            [[theValue(location.x) should] equal:ZERO_FLOAT withDelta:EPSILON];
            [[theValue(location.y) should] equal:TWO_FLOAT withDelta:EPSILON];
        });
    });
    
    context(@"when querying for the floor of a room", ^{
        
        it(@"should return an nil string if the room does not exist", ^{
            NSString *floor = [[TUIFloorPlan sharedInstanceForTesting] floorForRoom:@"unexistingRoom"];
            [[floor should] beNil];
        });
        
        it(@"should return the right results for a valid room", ^{
            NSString *floor = [[TUIFloorPlan sharedInstanceForTesting] floorForRoom:@"testRoom"];
            [[floor should] equal:@"testFloor"];
        });
    });
    
    context(@"when querying for the north vector of a floor", ^{
        
        it(@"should return an invalid north if the floor does not exist", ^{
            CGPoint north = [[TUIFloorPlan sharedInstanceForTesting] locationForRoom:@"unexistingFloor"];
            [[theValue(north.x) should] equal:theValue(INVALID_X_COORDINATE)];
            [[theValue(north.y) should] equal:theValue(INVALID_Y_COORDINATE)];
        });
        
        it(@"should return the right results for a valid room", ^{
            CGPoint north = [[TUIFloorPlan sharedInstanceForTesting] northForFloor:@"testFloor"];
            [[theValue(north.x) should] equal:-ONE_FLOAT withDelta:EPSILON];
            [[theValue(north.y) should] equal:ZERO_FLOAT withDelta:EPSILON];
        });
    });
    
    context(@"when calculating the heading of a room", ^{
        
        it(@"should return the right heading", ^{
            CGFloat heading = [[TUIFloorPlan sharedInstanceForTesting] headingForRoom:@"testRoom" beingInPosition:CGPointMake(ZERO_FLOAT, ZERO_FLOAT)];
            [[theValue(heading) should] equal:M_PI_2 withDelta:EPSILON];
        });
        
    });
    
});

SPEC_END