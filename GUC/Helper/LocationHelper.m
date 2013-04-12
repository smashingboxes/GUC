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
    if([CLLocationManager locationServicesEnabled]){
        locationManager = [[CLLocationManager alloc]init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = 500;
        [locationManager startUpdatingLocation];
        NSLog(@"Beginning to update location...");
    }
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
        if(theLocation.horizontalAccuracy < 35.0){
            NSLog(@"latitude %+.11f, longitude %+.11f\n",
                  theLocation.coordinate.latitude,
                  theLocation.coordinate.longitude);
            NSLog(@"Horizontal Accuracy:%f", theLocation.horizontalAccuracy);
            
            [manager stopUpdatingLocation];
            
            NSLog(@"Update finished.");
            
            [delegate locationHelperDidSucceed:theLocation];
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    [delegate locationHelperAuthorizationStatusDidChange];
}

@end
