//
//  PickerViewHelper.m
//  GUC
//
//  Created by Michael Brodeur on 4/25/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "PickerViewHelper.h"

@interface PickerViewHelper()

@property(nonatomic)NSArray *dataArray;
@property(nonatomic)UIPickerView *thePicker;
@property(nonatomic)UIView *containerView;
@property(nonatomic)NSString *thePurpose;

@end


@implementation PickerViewHelper

@synthesize dataArray;
@synthesize thePicker;
@synthesize pickerInView;
@synthesize delegate;
@synthesize containerView;
@synthesize thePurpose;

static UIViewController *parentViewController;

+(void)setParentView:(UIViewController *)parentController{
    parentViewController = parentController;
}

-(id)initWithDataSource:(NSArray *)theData andPurpose:(NSString*)purpose{
    
    if(self == [super init]){
        dataArray = [[NSArray alloc]initWithArray:theData];
        pickerInView = NO;
        thePurpose = purpose;
    }
    
    return self;
}

-(void)displayPicker{
    if(!containerView){
        containerView = [[UIView alloc]initWithFrame:CGRectMake(0, parentViewController.view.bounds.size.height + 244, 320, 244)];
        
        thePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, 320, 200)];
        thePicker.delegate = self;
        thePicker.showsSelectionIndicator = YES;
        
        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        toolBar.barStyle = UIBarStyleBlackTranslucent;
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];
        
        [toolBar setItems:[NSArray arrayWithObjects:flexibleSpace, btn, nil]];
        
        [containerView addSubview:thePicker];
        [containerView addSubview:toolBar];
    }
    [parentViewController.view addSubview:containerView];
    [self animatePicker];
}

-(void)animatePicker{
    if(!pickerInView){
        [UIView animateWithDuration:0.5 animations:^{
            containerView.center = CGPointMake(160, containerView.center.y - 468);
        }];
        pickerInView = YES;
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            containerView.center = CGPointMake(160, containerView.center.y + 468);
        }];
        pickerInView = NO;
    }
}

-(void)removePicker{
    if(thePicker){
        [self animatePicker];
        [self performSelector:@selector(removeSelfAfterDelay) withObject:nil afterDelay:0.5];
    }
}

-(void)removeSelfAfterDelay{
    [containerView removeFromSuperview];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component{
    return [dataArray count];
}

-(NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSMutableArray *nameArray = [[NSMutableArray alloc]init];
    if([parentViewController.accessibilityLabel isEqualToString:@"Inspection"]){
        if([thePurpose isEqualToString:@"Data"]){
            for(int i = 0; i < [dataArray count]; i++){
                NSDictionary *stationDictionary = [dataArray objectAtIndex:i];
                NSDictionary *stationInfo = [stationDictionary objectForKey:@"stationInfo"];
                
                [nameArray addObject:[stationInfo objectForKey:@"name"]];
            }
        }else{
            for(int i = 0; i < [dataArray count]; i++){
                [nameArray addObject:[dataArray objectAtIndex:i]];
            }
        }
    }else if([parentViewController.accessibilityLabel isEqualToString:@"Main"]){
        for(int i = 0; i < [dataArray count]; i++){
            [nameArray addObject:[dataArray objectAtIndex:i]];
        }
    }
    
    return [nameArray objectAtIndex:row];;
}

-(void)donePressed:(id)sender{
    if(delegate){
        [delegate pickerDidPickData:[dataArray objectAtIndex:[thePicker selectedRowInComponent:0]] atIndex:[thePicker selectedRowInComponent:0] forPurpose:thePurpose];
    }
    [self removePicker];
}


@end
