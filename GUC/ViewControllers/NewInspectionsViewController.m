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
#import "CustomLoadingView.h"
#import "PastInspectionsViewController.h"
#import "MenuButtonHelper.h"

@interface NewInspectionsViewController ()

@property(nonatomic)NSMutableArray *stationArray;
@property(nonatomic)NSArray *stationInfoArray;
@property(nonatomic)IBOutlet UITableView *stationTableView;
@property(nonatomic)LocationHelper *locationHelper;
@property(nonatomic)NSString *stationNameString;
@property(nonatomic)CustomLoadingView *customLoadingView;

@end

@implementation NewInspectionsViewController

@synthesize stationArray;
@synthesize stationInfoArray;
@synthesize stationTableView;
@synthesize locationHelper;
@synthesize stationNameString;
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
    [NavigationBarHelper setBackButtonTitle:@"Back" forViewController:self];
    
    self.navigationItem.title = @"New Inspection";
    
    stationInfoArray = [[NSArray alloc] initWithArray:[self stationInformation]];
    stationArray = [[NSMutableArray alloc]init];
    
    NSLog(@"There are %i stations in the array",[stationInfoArray count]);
    
    [self startFindingLocation];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [MenuButtonHelper setParentController:self];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Menu"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(displayMenuForButton)];
    NSArray *buttonTitlesArray = [[NSArray alloc]initWithObjects:@"View Past Inspections", @"Refresh Table", nil];
    [[MenuButtonHelper sharedHelper]addButtonsWithTitlesToActionSheet:buttonTitlesArray];
    [[MenuButtonHelper sharedHelper]setButtonOneTarget:self forSelector:@selector(transitionToPastInspections)];
    [[MenuButtonHelper sharedHelper]setButtonTwoTarget:self forSelector:@selector(startFindingLocation)];
}

-(void)startFindingLocation{
    stationTableView.hidden = YES;
    customLoadingView = [[CustomLoadingView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) andTitle:@"Finding Location..."];
    [self.view addSubview:customLoadingView];
    [customLoadingView beginLoading];
    
    if(stationInfoArray && ([stationInfoArray count] > 0)){
        if(!locationHelper){
            locationHelper = [[LocationHelper alloc]initWithDelegate:self];
        }
        [locationHelper findLocation];
    }
}

-(void)displayMenuForButton{
    [[MenuButtonHelper sharedHelper]displayMenu];
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
    if(stationArray){
        return [stationArray count];
    }
    return 0;
}


-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    stationTableView.hidden = YES;
    
    NewInspectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewInspectionCell"];
    
    if(cell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"NewInspectionCell" owner:nil options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
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
    
    cell.accessibilityLabel = currentStation.stationIdentifier;
    
    int totalFeet = [[currentStationArray objectAtIndex:1]intValue];
    
    if(totalFeet < 1000){
        cell.backgroundColorImageView.backgroundColor = [UIColor greenColor];
    }else{
        cell.backgroundColorImageView.backgroundColor = [UIColor redColor];
    }
    cell.feetLabel.text = [NSString stringWithFormat:@"%i", totalFeet];
    
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
    
    stationNameString = cell.accessibilityLabel;
    
    NSString *titleString = [NSString stringWithFormat:@"Begin inspection for %@?", cell.nameLabel.text];
    
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
    InspectionViewController *inspectionVC = [[InspectionViewController alloc]initWithStation:stationNameString];
    [self.navigationController pushViewController:inspectionVC animated:YES];
}


#pragma mark Location Helper Delegate Methods

-(void)locationHelperDidFail{
    NSLog(@"Reverse Geocoding failed.");
}

-(void)locationHelperDidSucceed:(CLLocation *)theLocation{
    if([stationArray count] > 0){
        [stationArray removeAllObjects];
    }
    
    CLLocation *returnedLocation = theLocation;
    
    NSMutableArray *tempStorageArray = [[NSMutableArray alloc]init];
    
    for(int i = 0; i < [stationInfoArray count]; i++){
        NSDictionary *aDictionary = [stationInfoArray objectAtIndex:i];
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
    
    [tempStorageArray sortUsingComparator:^(id obj1, id obj2){
        NSArray *array1 = (NSArray *)obj1;
        NSArray *array2 = (NSArray *)obj2;
        NSInteger num1String = [[array1 objectAtIndex:1]intValue];
        NSInteger num2String = [[array2 objectAtIndex:1]intValue];
        if(num1String > num2String){
            return (NSComparisonResult)NSOrderedDescending;
        }else if(num1String < num2String){
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    [stationArray addObjectsFromArray:tempStorageArray];
    NSLog(@"%@", stationArray);
    
    [stationTableView reloadData];
    stationTableView.hidden = NO;
    [customLoadingView stopLoading];
}

-(void)locationHelperAuthorizationStatusDidChange{
    NSLog(@"Authorization status changed.");
}


#pragma mark - MenuButtonHelper Methods

-(void)transitionToPastInspections{
    PastInspectionsViewController *pastInspectionsVC = [[PastInspectionsViewController alloc]init];
    [self.navigationController pushViewController:pastInspectionsVC animated:YES];
}

@end
