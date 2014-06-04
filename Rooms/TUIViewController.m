//
//  TUIViewController.m
//  Rooms
//
//  Created by Diego Lafuente on 29/05/14.
//  Copyright (c) 2014 Tui Travel A&D. All rights reserved.
//

#import "TUIViewController.h"
// Beacons
#import "ESTBeaconManager.h"


@interface TUIViewController () <ESTBeaconManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *proximityLabel;
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfBeaconsLabel;

@property (nonatomic, strong) ESTBeaconManager* beaconManager;

@end

@implementation TUIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // create manager instance
    self.beaconManager = [[ESTBeaconManager alloc] init];
    self.beaconManager.delegate = self;
    
    // create sample region object (you can additionaly pass major / minor values)
    ESTBeaconRegion* region = [[ESTBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"54fbdbd7-621f-4153-9466-47c86ecf886b"] identifier:@"testRegion"];
    
    // start looking for estimote beacons in region
    // when beacon ranged beaconManager:didRangeBeacons:inRegion: invoked
    [self.beaconManager startRangingBeaconsInRegion:region];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beaconManager:(ESTBeaconManager *)manager
     didRangeBeacons:(NSArray *)beacons
            inRegion:(ESTBeaconRegion *)region
{
    
    if([beacons count] == 1)
    {
        for (ESTBeacon* beacon in beacons)
        {
            _majorLabel.text = [[beacon major] stringValue];
            _minorLabel.text = [[beacon minor] stringValue];
            _distanceLabel.text = [[beacon distance] stringValue];
            //TO DO: go on with the rest of labels
            
        }
    }
}

@end
