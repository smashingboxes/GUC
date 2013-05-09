//
//  StationNetworkFactory.h
//  GUC
//
//  Created by Michael Brodeur on 4/22/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StationNetworkFactory : NSObject

+(NSURL*)generateURLForStation:(NSString*)stationName;
+(NSURL*)generateURLForTechnicianNames;
+(NSURL*)generateURLForPDF;

@end
