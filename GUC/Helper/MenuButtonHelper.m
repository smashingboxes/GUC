//
//  MenuButtonHelper.m
//  GUC
//
//  Created by Michael Brodeur on 4/12/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "MenuButtonHelper.h"
#import "PastInspectionsViewController.h"

@implementation MenuButtonHelper

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

-(void)displayMenu{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"View Past Inspections", nil];
    
    [actionSheet showInView:parentController.view];
}

-(void)transitionToPastInspections{
    PastInspectionsViewController *pastInspectionsVC = [[PastInspectionsViewController alloc]init];
    [parentController.navigationController pushViewController:pastInspectionsVC animated:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self transitionToPastInspections];
            break;
        case 1:
            // Cancel pressed. Do nothing.
            break;
        default:
            break;
    }
}

@end
