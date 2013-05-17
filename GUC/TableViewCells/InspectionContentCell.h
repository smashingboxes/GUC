//
//  InspectionContentCell.h
//  GUC
//
//  Created by Michael Brodeur on 4/15/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InspectionContentCell : UITableViewCell

@property(nonatomic)IBOutlet UILabel *cellLabel;
@property(nonatomic)IBOutlet UILabel *cellDetailsLabel;
@property(nonatomic)IBOutlet UITextField *cellField;
@property(nonatomic)IBOutlet UISegmentedControl *cellControl;
@property(nonatomic)IBOutlet UIImageView *cellBackgroundImageView;
@property(nonatomic)IBOutlet UIImageView *cellTopDropShadow;
@property(nonatomic)IBOutlet UIImageView *cellBottomDivider;

@end
