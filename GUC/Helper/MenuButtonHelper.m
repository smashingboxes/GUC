//
//  MenuButtonHelper.m
//  GUC
//
//  Created by Michael Brodeur on 4/12/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "MenuButtonHelper.h"

#define SuppressPerformSelectorLeakWarning(ArgumentsWithParameters) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
ArgumentsWithParameters; \
_Pragma("clang diagnostic pop") \
} while (0)

@interface MenuButtonHelper()

@property(nonatomic)UIActionSheet *actionSheet;
@property(nonatomic)id buttonOneTarget;
@property(nonatomic)SEL buttonOneSelector;
@property(nonatomic)id buttonTwoTarget;
@property(nonatomic)SEL buttonTwoSelector;

@end


@implementation MenuButtonHelper

@synthesize actionSheet;
@synthesize buttonOneTarget;
@synthesize buttonOneSelector;
@synthesize buttonTwoTarget;
@synthesize buttonTwoSelector; 

static UIViewController *parentController;

+(MenuButtonHelper*)sharedHelper{
    static MenuButtonHelper *sharedHelper;
    @synchronized(self){
        if(!sharedHelper){
            sharedHelper = [[MenuButtonHelper alloc]init];
        }
        return sharedHelper;
    }
}

+(void)setParentController:(UIViewController *)theParentController{
    parentController = theParentController;
}

-(void)setButtonOneTarget:(id)aTarget forSelector:(SEL)aSelector{
    buttonOneTarget = aTarget;
    buttonOneSelector = aSelector;
}

-(void)setButtonTwoTarget:(id)aTarget forSelector:(SEL)aSelector{
    buttonTwoTarget = aTarget;
    buttonTwoSelector = aSelector;
}

-(void)displayMenu{
    [actionSheet showInView:parentController.view];
}

-(void)addButtonsWithTitlesToActionSheet:(NSArray*)titles{
    if(actionSheet){
        actionSheet = nil;
    }
    actionSheet = [[UIActionSheet alloc]initWithTitle:@"Options" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for(int i = 0; i < [titles count]; i++){
        [actionSheet addButtonWithTitle:[titles objectAtIndex:i]];
    }
    [actionSheet addButtonWithTitle:@"Cancel"];
    actionSheet.cancelButtonIndex = [titles count];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            SuppressPerformSelectorLeakWarning([buttonOneTarget performSelector:buttonOneSelector]);
            break;
        case 1:
            SuppressPerformSelectorLeakWarning([buttonTwoTarget performSelector:buttonTwoSelector]);
            break;
        case 2:
            // Cancel pressed. Do nothing.
            break;
        default:
            break;
    }
}

@end
