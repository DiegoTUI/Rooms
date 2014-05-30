//
//  TUIFloorPlan.m
//  Rooms
//
//  Created by Diego Lafuente on 30/05/14.
//  Copyright (c) 2014 Tui Travel A&D. All rights reserved.
//

#import "TUIFloorPlan.h"
// Extensions
#import "TUIFloorPlan_Testing.h"
// SQLite
#import <sqlite3.h>


#pragma mark - Private interface

@interface TUIFloorPlan ()

/**
 The sqlite database where the floor plan is stored
 */
@property (nonatomic) sqlite3 *database;

@end


#pragma mark - Implementation

@implementation TUIFloorPlan

static NSString *const kDatabaseName = @"rooms";
static NSString *const kDatabaseTestName = @"test";
static NSString *const kDatabaseExtension = @"sqlite";
static NSString *const kBeaconsTable = @"beacons";
static NSString *const kFloorsTable = @"floors";
static NSString *const kRoomsTable = @"rooms";


#pragma mark - Singleton

+ (TUIFloorPlan *)sharedInstance
{
    static TUIFloorPlan *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TUIFloorPlan alloc] init];
    });
    return sharedInstance;
}

+ (TUIFloorPlan *)sharedInstanceForTesting
{
    static TUIFloorPlan *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TUIFloorPlan alloc] initForTesting];
    });
    return sharedInstance;
}


#pragma mark - Floors and rooms

- (NSArray *)floorList
{
    NSMutableArray *result = [NSMutableArray array];
    // prepare sqlite query
    NSString *sqlString = [NSString stringWithFormat:@"SELECT id FROM %@", kFloorsTable];
    const char *sql = [sqlString UTF8String];
    sqlite3_stmt *sqlStatement;
    if(sqlite3_prepare(_database, sql, -1, &sqlStatement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(sqlStatement)==SQLITE_ROW)
        {
            NSString *floorId = [NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(sqlStatement,0)];
            [result addObject:floorId];
        }
    }
    else //didnt prepare the statement right
    {
        NSLog(@"Problem when prepare statement: %@", sqlString);
    }
    
    //finalize statement
    sqlite3_finalize(sqlStatement);
    
    return result;
}

- (NSArray *)roomList
{
    NSMutableArray *result = [NSMutableArray array];
    // prepare sqlite query
    NSString *sqlString = [NSString stringWithFormat:@"SELECT id FROM %@", kRoomsTable];
    const char *sql = [sqlString UTF8String];
    sqlite3_stmt *sqlStatement;
    if(sqlite3_prepare(_database, sql, -1, &sqlStatement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(sqlStatement)==SQLITE_ROW)
        {
            NSString *roomId = [NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(sqlStatement,0)];
            [result addObject:roomId];
        }
    }
    else //didnt prepare the statement right
    {
        NSLog(@"Problem when prepare statement: %@", sqlString);
    }
    
    //finalize statement
    sqlite3_finalize(sqlStatement);
    
    return result;
}

- (NSArray *) roomListForFloor:(NSString *)floorId
{
    NSMutableArray *result = [NSMutableArray array];
    // prepare sqlite query
    NSString *sqlString = [NSString stringWithFormat:@"SELECT id FROM %@ WHERE floorId='%@'", kRoomsTable, floorId];
    const char *sql = [sqlString UTF8String];
    sqlite3_stmt *sqlStatement;
    if(sqlite3_prepare(_database, sql, -1, &sqlStatement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(sqlStatement)==SQLITE_ROW)
        {
            NSString *roomId = [NSString stringWithFormat:@"%s",(char *) sqlite3_column_text(sqlStatement,0)];
            [result addObject:roomId];
        }
    }
    else //didnt prepare the statement right
    {
        NSLog(@"Problem when prepare statement: %@", sqlString);
    }
    
    //finalize statement
    sqlite3_finalize(sqlStatement);
    
    return result;
}


#pragma mark - Floors and rooms

- (CGPoint)locationForRoom:(NSString *)roomId
{
    CGPoint result = CGPointMake(INVALID_X_COORDINATE, INVALID_Y_COORDINATE);
    // prepare sqlite query
    NSString *sqlString = [NSString stringWithFormat:@"SELECT x, y FROM %@ WHERE id='%@'", kRoomsTable, roomId];
    const char *sql = [sqlString UTF8String];
    sqlite3_stmt *sqlStatement;
    if(sqlite3_prepare(_database, sql, -1, &sqlStatement, NULL) == SQLITE_OK)
    {
        while (sqlite3_step(sqlStatement)==SQLITE_ROW)
        {
            CGFloat x = sqlite3_column_double(sqlStatement,0);
            CGFloat y = sqlite3_column_double(sqlStatement,1);
            
            result = CGPointMake(x, y);
        }
    }
    else //didnt prepare the statement right
    {
        NSLog(@"Problem when prepare statement: %@", sqlString);
    }
    
    //finalize statement
    sqlite3_finalize(sqlStatement);
    
    return result;
}

#pragma mark - Init

- (TUIFloorPlan *)init
{
    self = [super init];
    if (self)
    {
        _database = nil;
        NSString *dbPath = [[NSBundle mainBundle] pathForResource:kDatabaseName ofType:kDatabaseExtension];
        if(sqlite3_open([dbPath UTF8String], &_database) != SQLITE_OK)
        {
            NSLog(@"Error opening database: %@", dbPath);
        }
        else
        {
            NSLog(@"Database properly opened: %@", dbPath);
        }
    }
    return self;
}

- (TUIFloorPlan *)initForTesting
{
    self = [super init];
    if (self)
    {
        _database = nil;
        NSString *dbPath = [[NSBundle mainBundle] pathForResource:kDatabaseTestName ofType:kDatabaseExtension];
        if(sqlite3_open([dbPath UTF8String], &_database) != SQLITE_OK)
        {
            NSLog(@"Error opening TEST database: %@", dbPath);
        }
        else
        {
            NSLog(@"TEST database properly opened: %@", dbPath);
        }
    }
    return self;
}


#pragma mark - Dealloc

-(void) dealloc
{
    //Close the database
    if (sqlite3_close (_database) != SQLITE_OK)
    {
        NSLog(@"Problem closing database");
    }
    _database = nil;
}

@end
