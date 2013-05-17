//
//  InspectionContentCell.m
//  GUC
//
//  Created by Michael Brodeur on 4/15/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "InspectionContentCell.h"

@implementation InspectionContentCell

@synthesize cellLabel;
@synthesize cellField;
@synthesize cellControl;
@synthesize cellBackgroundImageView;
@synthesize cellTopDropShadow;
@synthesize cellBottomDivider;
@synthesize cellDetailsLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
