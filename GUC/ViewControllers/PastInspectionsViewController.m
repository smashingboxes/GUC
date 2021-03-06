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
#import "UIColor+HexString.h"

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
    cell.dateLabel.textColor = [UIColor colorWithHexString:@"666666"];
    cell.stationNameLabel.text = [currentObject objectForKey:@"station_name"];
    cell.stationNameLabel.textColor = [UIColor colorWithHexString:@"666666"];;
    cell.backgroundImageView.backgroundColor = [UIColor colorWithHexString:@"E8E1D6"];
    cell.accessibilityLabel = [currentObject objectForKey:@"station_id"];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
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
    if([theObjects count] > 0){
        dataArray = [[NSArray alloc]initWithArray:theObjects];
        NSLog(@"Objects returned are:\n%@", dataArray);
        [theTableView reloadData];
        theTableView.hidden = NO;
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"No Data!" message:@"There are currently no entries for this section.\nPlease try again later." delegate:self cancelButtonTitle:@"Okay." otherButtonTitles:nil];
        [alertView show];
    }
    [customLoadingView stopLoading];
}

-(void)asyncResponseDidFailWithError{
    NSLog(@"Error!");
}


#pragma mark - UIAlertView Delegate Methods

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        default:
            break;
    }
}

@end
