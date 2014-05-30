//
//  TUIFloorPlan_Testing.h
//  Rooms
//
//  Created by Diego Lafuente on 30/05/14.
//  Copyright (c) 2014 Tui Travel A&D. All rights reserved.
//

#import "TUIFloorPlan.h"

/**
 TUIFloorPlan extension for unit-testing purposes.
 */
@interface TUIFloorPlan ()

/**
 @methodName sharedInstance
 @abstract Returns the unique instance of the floor plan
 @discussion This method creates and returns a unique instance of the floor plan object.
 
 @return The unique instance of TUIFloorPlan
 */
+ (TUIFloorPlan *)sharedInstanceForTesting;

@end
