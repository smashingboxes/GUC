//
//  Field.h
//  GUC
//
//  Created by Michael Brodeur on 4/22/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Field : NSObject

@property(nonatomic)NSString *name;
@property(nonatomic)NSArray *range;
@property(nonatomic)NSString *type;
@property(nonatomic)NSArray *choices;
@property(nonatomic)NSString *number;
@property(nonatomic)NSString *value;

@end
