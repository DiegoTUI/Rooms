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
            [[theValue(location.x) should] equal:theValue(ZERO_FLOAT)];
            [[theValue(location.y) should] equal:theValue(TWO_FLOAT)];
        });
    });
    
});

SPEC_END