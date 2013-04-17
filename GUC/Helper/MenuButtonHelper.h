//
//  MenuButtonHelper.h
//  GUC
//
//  Created by Michael Brodeur on 4/12/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuButtonHelperDelegate <NSObject>

@optional

-(void)buttonForRefreshTableViewPressed;

@end

@interface MenuButtonHelper : NSObject <UIActionSheetDelegate>

@property(nonatomic,weak)id<MenuButtonHelperDelegate> delegate;

+(MenuButtonHelper*)sharedHelper;
+(void)setParentController:(UIViewController*)parentController;
-(void)displayMenu;

@end
