//
//  StationNetworkFactory.m
//  GUC
//
//  Created by Michael Brodeur on 4/22/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "StationNetworkFactory.h"

@implementation StationNetworkFactory

+(NSURL*)generateURLForStation:(NSString *)stationName{
    NSString *urlString = [[NSString alloc]initWithFormat:@"https://wsvcs.guc.com/SubInspections/Substation%%20Inspection/SubstationInspection.php?station=%@", stationName];
    NSURL *theURL = [[NSURL alloc]initWithString:urlString];
    
    return theURL;
}

+(NSURL*)generateURLForTechnicianNames{
    NSString *urlString = @"https://wsvcs.guc.com/substationtechnicianlist.php";
    NSURL *theURL = [[NSURL alloc]initWithString:urlString];
    
    return theURL;
}

+(NSURL*)generateURLForPDF{
    NSString *urlString = @"https://wsvcs.guc.com/SubInspections/inspectionservice.php";
    NSURL *theURL = [[NSURL alloc]initWithString:urlString];
    
    return theURL;
}

+(NSURL*)generateURLForPDFDownloadWithInspectionID:(NSString *)inspectionID stationName:(NSString *)stationName andDate:(NSString *)date{
    NSString *urlString = [[NSString alloc]initWithFormat:@"https://wsvcs.guc.com/SubInspections/inspectionservice.php?station_id=%@&station_name=%@&date=%@", inspectionID, stationName, date];
    NSURL *theURL = [[NSURL alloc]initWithString:urlString];
    
    return theURL;
}

@end
