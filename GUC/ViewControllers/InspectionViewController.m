//
//  InspectionViewController.m
//  GUC
//
//  Created by Michael Brodeur on 4/8/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "InspectionViewController.h"

@interface InspectionViewController ()

@property(nonatomic)NSString *viewTitle;

@end

@implementation InspectionViewController

@synthesize viewTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithTitle:(NSString*)title{
    if(self == [super init]){
        viewTitle = title;
    }
    return self;
}

- (void)viewDidLoad
{
    self.navigationItem.title = viewTitle;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
