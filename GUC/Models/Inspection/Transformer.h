//
//  Transformer.h
//  GUC
//
//  Created by Michael Brodeur on 4/8/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transformer : NSObject

@property(nonatomic)BOOL tankOilLevel;
@property(nonatomic)NSString *pressure;
@property(nonatomic)NSString *nitrogenTank;
@property(nonatomic)NSString *windingTemp;
@property(nonatomic)NSString *oilTemp;
@property(nonatomic)BOOL bushingOilLevel;

@end
