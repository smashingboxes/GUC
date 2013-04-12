//
//  CustomLoadingView.h
//  GUC
//
//  Created by Michael Brodeur on 4/12/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLoadingView : UIView

-(id)initWithFrame:(CGRect)frame andTitle:(NSString*)title;
-(void)beginLoading;
-(void)stopLoading;

@end
