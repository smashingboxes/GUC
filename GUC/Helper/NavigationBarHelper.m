//
//  NavigationBarHelper.m
//  GUC
//
//  Created by Michael Brodeur on 4/8/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "NavigationBarHelper.h"

@implementation NavigationBarHelper

+(void)setBackButtonTitle:(NSString*)aTitle forViewController:(UIViewController*)viewController{
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:aTitle
                                                                                         style: UIBarButtonItemStyleBordered
                                                                                        target:nil                                                                                        action:nil];
}

@end
