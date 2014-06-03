//
//  TUIFloorPlan.h
//  Rooms
//
//  Created by Diego Lafuente on 30/05/14.
//  Copyright (c) 2014 Tui Travel A&D. All rights reserved.
//

#import "TUIBaseModel.h"

/**
 TUIFloorPlan provides a model for a building. It uses the database in rooms.sqlite.
 */
@interface TUIFloorPlan : TUIBaseModel

/**
 @methodName sharedInstance
 @abstract Returns the unique instance of the floor plan
 @discussion This method creates and returns a unique instance of the floor plan object.
 
 @return The unique instance of TUIFloorPlan
 */
+ (TUIFloorPlan *)sharedInstance;

/**
 @methodName floorList
 @abstract Returns a list for all the floorIds available
 @discussion This method returns a list for all the floors available. It is a list of
 the floorIds.
 
 @return The list of all the floors available
 */
- (NSArray *)floorList;

/**
 @methodName roomList
 @abstract Returns a list for all the roomIds available
 @discussion This method returns a list for all the rooms available. It is a list of
 the roomIds.
 
 @return The list of all the rooms available
 */
- (NSArray *)roomList;

/**
 @methodName roomList
 @abstract Returns a list for all the roomIds available
 @discussion This method returns a list for all the rooms available. It is a list of
 the roomIds.
 
 @return The list of all the rooms available
 */
- (NSArray *)roomListForFloor:(NSString *)floorId;

/**
 @methodName northForFloor:
 @abstract Returns the north vector for a given floor
 @discussion This method returns the north vector of a floor given its floorId.
 
 @param floorId The id of the floor
 
 @return The north vector of the floor
 */
- (CGPoint)northForFloor:(NSString *)floorId;

/**
 @methodName locationForRoom:
 @abstract Returns the location of a given room
 @discussion This method returns the location of a room given its roomId.
 
 @param roomId The id of the room
 
 @return The location of a room
 */
- (CGPoint)locationForRoom:(NSString *)roomId;

/**
 @methodName floorForRoom:
 @abstract Returns the floor of a given room
 @discussion This method returns the floor (via the floorId) of a room given its roomId.
 
 @param roomId The id of the room
 
 @return The floorId of a room
 */
- (NSString *)floorForRoom:(NSString *)roomId;

/**
 @methodName headingForRoom:beingInPosition:
 @abstract Returns the heading that a user located in a certain point should follow
 if he wants to reach a certain room.
 @discussion This method returns the heading (measured in clockwise radians between 0 and 2*M_PI) that a user located 
 in a certain point should follow if he wants to reach a certain room.
 
 @param roomId The id of the room the user wanst to reach
 @param position The current position of the user
 
 @return The heading to follow
 */
- (CGFloat)headingForRoom:(NSString *)roomId
          beingInPosition:(CGPoint)position;

@end
