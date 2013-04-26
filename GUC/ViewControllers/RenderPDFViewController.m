//
//  RenderPDFViewController.m
//  GUC
//
//  Created by Michael Brodeur on 4/23/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "RenderPDFViewController.h"

@interface RenderPDFViewController ()

@property(nonatomic)Inspection *currentInspection;

// Header Labels
@property(nonatomic)IBOutlet UILabel *stationNameLabel;
@property(nonatomic)IBOutlet UILabel *dateTimeLabel;
@property(nonatomic)IBOutlet UILabel *technicianLabel;

// General Labels
@property(nonatomic)IBOutlet UILabel *kwhLabel;
@property(nonatomic)IBOutlet UILabel *mwdLabel;
@property(nonatomic)IBOutlet UILabel *plusKVARHLabel;
@property(nonatomic)IBOutlet UILabel *minusKVARHLabel;
@property(nonatomic)IBOutlet UILabel *maxVARDLabel;
@property(nonatomic)IBOutlet UILabel *minVARDLabel;

// Views
@property(nonatomic)IBOutlet UIView *generalView;

@end

@implementation RenderPDFViewController

@synthesize currentInspection;

@synthesize stationNameLabel;
@synthesize dateTimeLabel;
@synthesize technicianLabel;

@synthesize kwhLabel;
@synthesize mwdLabel;
@synthesize plusKVARHLabel;
@synthesize minusKVARHLabel;
@synthesize maxVARDLabel;
@synthesize minVARDLabel;

@synthesize generalView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithInspection:(Inspection *)theInspection{
    if(self == [super init]){
        if(!currentInspection){
            currentInspection = [[Inspection alloc]init];
        }
        currentInspection = theInspection;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
