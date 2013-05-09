//
//  PastInspectionsViewController.m
//  GUC
//
//  Created by Michael Brodeur on 4/8/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "PastInspectionsViewController.h"
#import "NetworkConnectionManager.h"

@interface PastInspectionsViewController ()

@end

@implementation PastInspectionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationItem.title = @"Past Inspections";
    
    [self beginInitialLoad];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)beginInitialLoad{
    [[NetworkConnectionManager sharedManager]beginConnectionWithPurpose:@"PDF" withJSONDictionary:nil forCaller:self];
}


#pragma mark - AsyncResponse Delegate Methods

-(void)asyncResponseDidReturnObjects:(NSArray *)theObjects{
    if(theObjects)
        NSLog(@"Objects returned are:\n%@", theObjects);
}

-(void)asyncResponseDidFailWithError{
    NSLog(@"Error!");
}

@end
