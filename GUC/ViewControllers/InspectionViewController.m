//
//  InspectionViewController.m
//  GUC
//
//  Created by Michael Brodeur on 4/8/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "InspectionViewController.h"
#import "InspectionFormHelper.h"
#import "InspectionContentCell.h"
#define kOperatorInformation @"guc_operator.plist"

#define DEFAULT_ROW_HEIGHT 64
#define HEADER_HEIGHT 45

@interface InspectionViewController ()

@property(nonatomic)NSString *viewTitle;
@property(nonatomic)IBOutlet UITableView *theTableView;
@property(nonatomic)InspectionFormHelper *inspectionFormHelper;
@property(nonatomic)NSInteger openSectionIndex;

@end

@implementation InspectionViewController

@synthesize viewTitle;
@synthesize theTableView;
@synthesize inspectionFormHelper;
@synthesize openSectionIndex;

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
    
    inspectionFormHelper = [[InspectionFormHelper alloc]init];
    
    openSectionIndex = NSNotFound;
    
    theTableView.sectionHeaderHeight = HEADER_HEIGHT;
    
    [theTableView reloadData];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Random Data Methods

-(NSString*)operatorPropertyList{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kOperatorInformation];
}

-(NSString*)loadOperatorName{
    NSString *plistPath = [self operatorPropertyList];
    if(plistPath){
        NSArray *nameArray = [[NSArray alloc]initWithContentsOfFile:plistPath];
        return [nameArray objectAtIndex:0];
    }
    return nil;
}


#pragma mark - UITableView Data Source Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    if(inspectionFormHelper){
        return [inspectionFormHelper.containerArray count];
    }
    return 0;
}


-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    
    BOOL openState = [[inspectionFormHelper.infoArray objectAtIndex:section]boolValue];
    NSArray *headerTitleArray = [inspectionFormHelper.containerArray objectAtIndex:section];
    NSArray *titleArray = [headerTitleArray objectAtIndex:1];
	NSInteger numRowsInSection = [titleArray count];
	
    return openState ? numRowsInSection : 0;
}


-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    InspectionContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InspectionContentCell"];
    
    if(cell == nil){
        NSArray *topLevelObjects = [[NSBundle mainBundle]loadNibNamed:@"InspectionContentCell" owner:nil options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *firstArray = [inspectionFormHelper.containerArray objectAtIndex:indexPath.section];
    NSArray *titleArray = [firstArray objectAtIndex:1];
    
    cell.cellLabel.text = [titleArray objectAtIndex:indexPath.row];
    
    cell.cellField.delegate = self;
    cell.cellField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    cell.cellField.hidden = NO;
    cell.cellField.text = @"";
    cell.cellField.userInteractionEnabled = YES;
    cell.cellField.accessibilityLabel = [NSString stringWithFormat:@"%i,%i",indexPath.section, indexPath.row];
    
    cell.cellControl.hidden = YES;
    
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            cell.cellField.text = viewTitle;
            cell.cellField.userInteractionEnabled = NO;
        }else if(indexPath.row == 1){
            cell.cellField.text = [NSString stringWithFormat:@"%@",[NSDate date]];
            cell.cellField.userInteractionEnabled = NO;
        }else if(indexPath.row == 2){
            cell.cellField.text = [self loadOperatorName];
            cell.cellField.userInteractionEnabled = NO;
        }else{
            // Do nothing.
        }
    }else if(indexPath.section == 1){
        if(indexPath.row == [titleArray count]-1){
            cell.cellField.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
    }else if(indexPath.section == 3){
        cell.cellField.hidden = YES;
        cell.cellControl.hidden = NO;
    }else if(indexPath.section == 4){
        if(indexPath.row == 0 || indexPath.row == 3){
            cell.cellField.hidden = YES;
            cell.cellControl.hidden = NO;
        }
    }else{
        // Do nothing.
    }
    
    return cell;
}


-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSArray *headerTitleArray = [inspectionFormHelper.containerArray objectAtIndex:section];
    NSString *titleString = [headerTitleArray objectAtIndex:0];
    
    InspectionCellHeaderView *headerView = [[InspectionCellHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, theTableView.bounds.size.width, HEADER_HEIGHT) title:titleString section:section theDelegate:self];
    
    return headerView;
}


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return DEFAULT_ROW_HEIGHT;
}


-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - InspectionCellHeaderView Delegate Methods

-(void)inspectionCellHeaderView:(InspectionCellHeaderView*)inspectionCellHeaderView sectionOpened:(NSInteger)section{
    [inspectionFormHelper.infoArray replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:YES]];
    
    NSArray *firstAddArray = [inspectionFormHelper.containerArray objectAtIndex:section];
    NSArray *titleAddArray = [firstAddArray objectAtIndex:1];
    
    /*
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     */
    NSInteger countOfRowsToInsert = [titleAddArray count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    /*
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     */
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = openSectionIndex;
    
    if (previousOpenSectionIndex != NSNotFound) {
        NSArray *firstDeleteArray = [inspectionFormHelper.containerArray objectAtIndex:previousOpenSectionIndex];
        NSArray *titleDeleteArray = [firstDeleteArray objectAtIndex:1];
        
        InspectionCellHeaderView *currentHeader = (InspectionCellHeaderView*)[theTableView headerViewForSection:previousOpenSectionIndex];
        
        [inspectionFormHelper.infoArray replaceObjectAtIndex:previousOpenSectionIndex withObject:[NSNumber numberWithBool:NO]];
        
        [currentHeader toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [titleDeleteArray count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // Style the animation so that there's a smooth flow in either direction.
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || section < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // Apply the updates.
    [self.theTableView beginUpdates];
    [self.theTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.theTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.theTableView endUpdates];
    openSectionIndex = section;
}

-(void)inspectionCellHeaderView:(InspectionCellHeaderView*)inspectionCellHeaderView sectionClosed:(NSInteger)section{
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
    [inspectionFormHelper.infoArray replaceObjectAtIndex:section withObject:[NSNumber numberWithBool:NO]];
    
    NSInteger countOfRowsToDelete = [theTableView numberOfRowsInSection:section];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        [theTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    openSectionIndex = NSNotFound;
}

#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}


@end
