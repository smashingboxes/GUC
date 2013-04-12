//
//  NewInspectionCell.m
//  GUC
//
//  Created by Michael Brodeur on 4/9/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "NewInspectionCell.h"

@implementation NewInspectionCell

@synthesize backgroundColorImageView;
@synthesize typeLabel;
@synthesize typeImageView;
@synthesize nameLabel;
@synthesize feetLabel;

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
