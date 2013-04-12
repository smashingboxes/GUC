//
//  MenuButtonHelper.h
//  GUC
//
//  Created by Michael Brodeur on 4/12/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuButtonHelper : NSObject <UIActionSheetDelegate>

+(MenuButtonHelper*)sharedHelper;
+(void)setParentController:(UIViewController*)parentController;
-(void)displayMenu;

@end
