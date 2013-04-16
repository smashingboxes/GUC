//
//  InspectionCellHeaderView.h
//  GUC
//
//  Created by Michael Brodeur on 4/15/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InspectionCellHeaderViewDelegate;

@interface InspectionCellHeaderView : UIView

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *disclosureButton;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, weak) id <InspectionCellHeaderViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber theDelegate:(id <InspectionCellHeaderViewDelegate>)theDelegate;
-(void)toggleOpenWithUserAction:(BOOL)userAction;

@end


@protocol InspectionCellHeaderViewDelegate <NSObject>

@optional
-(void)inspectionCellHeaderView:(InspectionCellHeaderView*)inspectionCellHeaderView sectionOpened:(NSInteger)section;
-(void)inspectionCellHeaderView:(InspectionCellHeaderView*)inspectionCellHeaderView sectionClosed:(NSInteger)section;

@end