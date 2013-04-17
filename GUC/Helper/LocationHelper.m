//
//  LocationHelper.m
//  GUC
//
//  Created by Michael Brodeur on 4/10/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "LocationHelper.h"

@implementation LocationHelper

@synthesize locationManager;
@synthesize delegate;

-(id)initWithDelegate:(id)theDelegate{
    if(self == [super init]){
        self.delegate = theDelegate;
    }
    return self;
}

-(void)findLocation{
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.pausesLocationUpdatesAutomatically = NO;
    [locationManager startUpdatingLocation];
    NSLog(@"Beginning to update location...");
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [delegate locationHelperDidFail];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *theLocation = [locations lastObject];
    NSDate* eventDate = theLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0)
    {
        NSLog(@"latitude %+.11f, longitude %+.11f\n",
              theLocation.coordinate.latitude,
              theLocation.coordinate.longitude);
        NSLog(@"Horizontal Accuracy:%f", theLocation.horizontalAccuracy);
        
        [locationManager stopUpdatingLocation];
        
        NSLog(@"Update finished.");
        
        [delegate locationHelperDidSucceed:theLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if(status == kCLAuthorizationStatusAuthorized){
        NSLog(@"Authorized");
    }
    [delegate locationHelperAuthorizationStatusDidChange];
}

@end
