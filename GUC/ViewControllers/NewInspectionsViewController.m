//
//  NewInspectionsViewController.m
//  GUC
//
//  Created by Michael Brodeur on 4/8/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "NewInspectionsViewController.h"
#import "Station.h"
#import "NewInspectionCell.h"
#import "InspectionViewController.h"
#import "NavigationBarHelper.h"

@interface NewInspectionsViewController ()

@property(nonatomic)NSMutableArray *stationArray;
@property(nonatomic)IBOutlet UITableView *stationTableView;
@property(nonatomic)LocationHelper *locationHelper;
@property(nonatomic)NSString *stationNameString;

@end

@implementation NewInspectionsViewController

@synthesize stationArray;
@synthesize stationTableView;
@synthesize locationHelper;
@synthesize stationNameString;

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
    self.navigationItem.title = @"New Inspection";
    
    stationArray = [[NSMutableArray alloc] initWithArray:[self stationInformation]];
    
    NSLog(@"There are %i stations in the array",[stationArray count]);
    
    if(stationArray && ([stationArray count] > 0)){
        locationHelper = [[LocationHelper alloc]initWithDelegate:self];
        [locationHelper findLocation];
    }
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray*)stationInformation{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Stations" withExtension:@"plist"];
    if(url){
        NSDictionary *stationsDictionary = [[NSDictionary alloc] initWithContentsOfURL:url];
        NSArray *stationsArray = [stationsDictionary objectForKey:@"Stations"];
        return stationsArray;
    }
    return nil;
}


#pragma mark TableView Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}


-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [stationArray count];
}


-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    stationTableView.hidden = YES;
    
    NewInspectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewInspectionCell"];
    
    if(cell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"NewInspectionCell" owner:nil options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    if([[stationArray objectAtIndex:0] respondsToSelector:@selector(initWithObjects:)]){
        stationTableView.hidden = NO;
        
        NSArray *currentStationArray = [stationArray objectAtIndex:indexPath.row];
        Station *currentStation = [currentStationArray objectAtIndex:0];
        
        cell.typeLabel.text = @"Type";
        cell.typeImageView.backgroundColor = [UIColor blueColor];
        if((currentStation.stationName != nil) && (![currentStation.stationName isEqualToString:@""])){
            cell.nameLabel.text = currentStation.stationName;
        }else{
            cell.nameLabel.text = currentStation.stationIdentifier;
        }
        int totalFeet = [[currentStationArray objectAtIndex:1]intValue];
        
        if(totalFeet < 1000){
            cell.backgroundColorImageView.backgroundColor = [UIColor greenColor];
        }else{
            cell.backgroundColorImageView.backgroundColor = [UIColor redColor];
        }
        cell.backgroundColorImageView.alpha = 0.75f;
        cell.feetLabel.text = [NSString stringWithFormat:@"%i", totalFeet];
    }
    
    return cell;
}


/*-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}*/


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return 58;
}


-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    NewInspectionCell *cell = (NewInspectionCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    stationNameString = cell.nameLabel.text;
    
    NSString *titleString = [NSString stringWithFormat:@"Begin inspection for %@?", stationNameString];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:titleString message:@"Are you ready to begin your inspection of this site?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alertView show];
}


#pragma mark - UIAlertView Delegate Methods

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            // Do nothing
            break;
        case 1:
            [self transitionToInspectionView];
            break;
        default:
            break;
    }
}

-(void)transitionToInspectionView{
    [NavigationBarHelper setBackButtonTitle:@"Back" forViewController:self];
    InspectionViewController *inspectionVC = [[InspectionViewController alloc]initWithTitle:stationNameString];
    [self.navigationController pushViewController:inspectionVC animated:YES];
}


#pragma mark Location Helper Delegate Methods

-(void)locationHelperDidFail{
    NSLog(@"Reverse Geocoding failed.");
}

-(void)locationHelperDidSucceed:(CLLocation *)theLocation{
    CLLocation *returnedLocation = theLocation;
    
    NSMutableArray *tempStorageArray = [[NSMutableArray alloc]init];
    
    for(int i = 0; i < [stationArray count]; i++){
        NSDictionary *aDictionary = [stationArray objectAtIndex:i];
        Station *newStation = [[Station alloc]init];
        newStation.stationIdentifier = [aDictionary objectForKey:@"Identifier"];
        newStation.stationName = [aDictionary objectForKey:@"Name"];
        newStation.stationNumber = [[aDictionary objectForKey:@"Number"] intValue];
        newStation.stationLatitude = [aDictionary objectForKey:@"Latitude"];
        newStation.stationLongitude = [aDictionary objectForKey:@"Longitude"];
        
        NSLog(@"The coordinates for %@ are: %@, %@", newStation.stationName, newStation.stationLatitude, newStation.stationLongitude);
        
        CLLocation *stationLocation = [[CLLocation alloc]initWithLatitude:[newStation.stationLatitude doubleValue] longitude:[newStation.stationLongitude doubleValue]];
        
        CLLocationDistance locationDistance = [stationLocation distanceFromLocation:returnedLocation];
        
        NSLog(@"The distance from %@ is %f feet.",newStation.stationName,(locationDistance*3.280));
        
        NSString *distanceString = [NSString stringWithFormat:@"%f", (locationDistance*3.280)];
        
        NSArray *containerArray = [[NSArray alloc]initWithObjects:newStation, distanceString, nil];
        
        [tempStorageArray addObject:containerArray];
    }
    
    [tempStorageArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSArray *array1 = (NSArray *)obj1;
        NSArray *array2 = (NSArray *)obj2;
        NSNumber *num1String = [array1 objectAtIndex:1];
        NSNumber *num2String = [array2 objectAtIndex:1];
        
        return [num1String compare:num2String];
    }];
    
    [stationArray removeAllObjects];
    [stationArray addObjectsFromArray:tempStorageArray];
    NSLog(@"%@", stationArray);
    
    [stationTableView reloadData];
}

-(void)locationHelperAuthorizationStatusDidChange{
    NSLog(@"Authorization status changed.");
}

@end
