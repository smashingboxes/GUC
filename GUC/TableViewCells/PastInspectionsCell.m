//
//  PastInspectionsCell.m
//  GUC
//
//  Created by Michael Brodeur on 5/10/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "PastInspectionsCell.h"

@implementation PastInspectionsCell

@synthesize dateLabel;
@synthesize stationNameLabel;

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
