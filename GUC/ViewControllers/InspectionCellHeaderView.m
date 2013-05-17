//
//  InspectionCellHeaderView.m
//  GUC
//
//  Created by Michael Brodeur on 4/15/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "InspectionCellHeaderView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+HexString.h"

@implementation InspectionCellHeaderView

@synthesize titleLabel;
@synthesize disclosureButton;
@synthesize delegate;
@synthesize section;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

+ (Class)layerClass {
    
    return [CAGradientLayer class];
}


-(id)initWithFrame:(CGRect)frame title:(NSString*)title section:(NSInteger)sectionNumber theDelegate:(id <InspectionCellHeaderViewDelegate>)theDelegate {
    
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        
        // Set up the tap gesture recognizer.
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpen:)];
        [self addGestureRecognizer:tapGesture];
        
        delegate = theDelegate;
        self.userInteractionEnabled = YES;
        
        // Create the background.
        UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:frame];
        backgroundImageView.backgroundColor = [UIColor colorWithHexString:@"C9B7A0"];
        
        UIImageView *darkBorderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.size.height - 4, frame.size.width, 4)];
        darkBorderImageView.image = [UIImage imageNamed:@"darktanlinebreak.png"];
        [self addSubview:backgroundImageView];
        [self addSubview:darkBorderImageView];
        
        // Create and configure the title label.
        section = sectionNumber;
        CGRect titleLabelFrame = self.bounds;
        titleLabelFrame.origin.x += 35.0;
        titleLabelFrame.size.width -= 35.0;
        CGRectInset(titleLabelFrame, 0.0, 5.0);
        UILabel *label = [[UILabel alloc] initWithFrame:titleLabelFrame];
        label.text = title;
        label.font = [UIFont boldSystemFontOfSize:17.0];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.shadowColor = [UIColor colorWithHexString:@"B4A48F"];
        label.shadowOffset = CGSizeMake(0.0f, 2.0f);
        [self addSubview:label];
        titleLabel = label;
        
        
        // Create and configure the disclosure button.
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(15.0, (frame.size.height/2)-4, 9.0, 9.0);
        [button setImage:[UIImage imageNamed:@"closed.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"open.png"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(toggleOpen:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        disclosureButton = button;
        
        // Set the colors for the gradient layer.
        /*static NSMutableArray *colors = nil;
        if (colors == nil) {
            colors = [[NSMutableArray alloc] initWithCapacity:3];
            UIColor *color = nil;
            color = [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
            color = [UIColor colorWithRed:0.50 green:0.50 blue:0.50 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
            color = [UIColor colorWithRed:0.30 green:0.30 blue:0.30 alpha:1.0];
            [colors addObject:(id)[color CGColor]];
        }
        [(CAGradientLayer *)self.layer setColors:colors];
        [(CAGradientLayer *)self.layer setLocations:[NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.48], [NSNumber numberWithFloat:1.0], nil]];*/
        
    }
    
    return self;
}


-(IBAction)toggleOpen:(id)sender {
    
    [self toggleOpenWithUserAction:YES];
}


-(void)toggleOpenWithUserAction:(BOOL)userAction {
    
    // Toggle the disclosure button state.
    disclosureButton.selected = !disclosureButton.selected;
    
    // If this was a user action, send the delegate the appropriate message.
    if (userAction) {
        if (disclosureButton.selected) {
            if ([delegate respondsToSelector:@selector(inspectionCellHeaderView:sectionOpened:)]) {
                [delegate inspectionCellHeaderView:self sectionOpened:section];
            }
        }
        else {
            if ([delegate respondsToSelector:@selector(inspectionCellHeaderView:sectionClosed:)]) {
                [delegate inspectionCellHeaderView:self sectionClosed:section];
            }
        }
    }
}

@end
