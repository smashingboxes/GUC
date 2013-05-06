//
//  PickerViewHelper.h
//  GUC
//
//  Created by Michael Brodeur on 4/25/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PickerViewHelperDelegate <NSObject>

-(void)pickerDidPickData:(id)theData atIndex:(NSInteger)theIndex forPurpose:(NSString*)purpose;

@end

@interface PickerViewHelper : NSObject <UIPickerViewDelegate, UIPickerViewDataSource>

@property(nonatomic)BOOL pickerInView;
@property(nonatomic, weak)id<PickerViewHelperDelegate> delegate;

+(void)setParentView:(UIViewController*)parentController;
-(id)initWithDataSource:(NSArray*)theData andPurpose:(NSString*)purpose;
-(void)displayPicker;
-(void)removePicker;

@end
