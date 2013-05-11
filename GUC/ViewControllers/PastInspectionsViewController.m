//
//  PastInspectionsViewController.m
//  GUC
//
//  Created by Michael Brodeur on 4/8/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "PastInspectionsViewController.h"
#import "NetworkConnectionManager.h"
#import "PastInspectionsCell.h"
#import "PastInspectionsSummaryViewController.h"
#import "CustomLoadingView.h"
#import "NavigationBarHelper.h"

#define kInspectionPropertyList @"guc_inspection.plist"

@interface PastInspectionsViewController ()

@property(nonatomic)IBOutlet UITableView *theTableView;
@property(nonatomic)NSArray *dataArray;
@property(nonatomic)CustomLoadingView *customLoadingView;

@end


@implementation PastInspectionsViewController

@synthesize theTableView;
@synthesize dataArray;
@synthesize customLoadingView;

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
    
    [NavigationBarHelper setBackButtonTitle:@"Back" forViewController:self];
    
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
    theTableView.hidden = YES;
    [[NetworkConnectionManager sharedManager]beginConnectionWithPurpose:@"PDF" withParameters:nil withJSONDictionary:nil forCaller:self];
    customLoadingView = [[CustomLoadingView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) andTitle:@"Loading..."];
    [self.view addSubview:customLoadingView];
    [customLoadingView beginLoading];
}


#pragma mark - UITableView Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}


-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    if(dataArray){
        return [dataArray count];
    }
    return 0;
}


-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    PastInspectionsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PastInspectionsCell"];
    
    if(cell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"PastInspectionsCell" owner:nil options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    NSDictionary *currentObject = [dataArray objectAtIndex:indexPath.row];
    
    cell.dateLabel.text = [currentObject objectForKey:@"date"];
    cell.stationNameLabel.text = [currentObject objectForKey:@"station_name"];
    cell.accessibilityLabel = [currentObject objectForKey:@"station_id"];
    
    return cell;
}


/*-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
 return nil;
 }*/


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return 44;
}


-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    PastInspectionsCell *cell = (PastInspectionsCell*)[theTableView cellForRowAtIndexPath:indexPath];
    
    [self saveInspectionToDisk:cell.accessibilityLabel stationName:cell.stationNameLabel.text andDate:cell.dateLabel.text];
    
    PastInspectionsSummaryViewController *pastInspectionsSummaryVC = [[PastInspectionsSummaryViewController alloc]initWithNibName:@"PastInspectionsSummary" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:pastInspectionsSummaryVC animated:YES];
}

-(void)saveInspectionToDisk:(NSString*)inspectionID stationName:(NSString*)stationName andDate:(NSString*)date{
    NSArray *nameArray = [[NSArray alloc]initWithObjects:inspectionID, stationName, date,nil];
    [nameArray writeToFile:[self inspectionPropertyList] atomically:YES];
}

-(NSString*)inspectionPropertyList{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kInspectionPropertyList];
}

#pragma mark - AsyncResponse Delegate Methods

-(void)asyncResponseDidReturnObjects:(NSArray *)theObjects{
    if(theObjects){
        dataArray = [[NSArray alloc]initWithArray:theObjects];
        NSLog(@"Objects returned are:\n%@", dataArray);
        [theTableView reloadData];
        theTableView.hidden = NO;
        [customLoadingView stopLoading];
    }
    
}

-(void)asyncResponseDidFailWithError{
    NSLog(@"Error!");
}

@end
