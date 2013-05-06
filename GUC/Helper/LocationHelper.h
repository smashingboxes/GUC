//
//  LocationHelper.h
//  GUC
//
//  Created by Michael Brodeur on 4/10/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationHelperDelegate<NSObject>

-(void)locationHelperDidFail;
-(void)locationHelperDidSucceed:(CLLocation*)theLocation;
-(void)locationHelperAuthorizationStatusDidChange;

@end


@interface LocationHelper : NSObject <CLLocationManagerDelegate>

@property(nonatomic)CLLocationManager *locationManager;
@property(nonatomic, weak)id<LocationHelperDelegate> delegate;

-(id)initWithDelegate:(id<LocationHelperDelegate>)theDelegate;
-(void)findLocation;

@end
