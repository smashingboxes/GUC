//
//  CustomLoadingView.m
//  GUC
//
//  Created by Michael Brodeur on 4/12/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "CustomLoadingView.h"
#import <QuartzCore/QuartzCore.h>

@interface CustomLoadingView()

@property(nonatomic)UIActivityIndicatorView *activityIndicator;

@end


@implementation CustomLoadingView

@synthesize activityIndicator;
@synthesize isLoading;

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.alpha = 0.0f;
        self.backgroundColor = [UIColor clearColor];
        UIImageView *backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.alpha = 0.3f;
        [self addSubview:backgroundView];
        UIImageView *activityIndicatorBackground = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        activityIndicatorBackground.backgroundColor = [UIColor blackColor];
        activityIndicatorBackground.layer.cornerRadius = 7.0f;
        activityIndicatorBackground.center = CGPointMake((frame.size.width/2), (frame.size.width/2));
        activityIndicatorBackground.alpha = 0.7f;
        [self addSubview:activityIndicatorBackground];
        activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.center = CGPointMake((frame.size.width/2), (frame.size.width/2)-10);
        [self addSubview:activityIndicator];
        UILabel *loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        loadingLabel.center = CGPointMake((frame.size.width/2), (frame.size.width/2)+30);
        loadingLabel.text = title;
        loadingLabel.backgroundColor = [UIColor clearColor];
        loadingLabel.textColor = [UIColor whiteColor];
        loadingLabel.textAlignment = NSTextAlignmentCenter;
        loadingLabel.font = [UIFont fontWithName:@"Arial" size:11];
        [self addSubview:loadingLabel];
    }
    return self;
}

-(void)beginLoading{
    [activityIndicator startAnimating];
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 1.0f;
    }];
    isLoading = YES;
}

-(void)stopLoading{
    [UIView animateWithDuration:0.2f animations:^{
        self.alpha = 0.0f;
    }];
    [activityIndicator stopAnimating];
    isLoading = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
