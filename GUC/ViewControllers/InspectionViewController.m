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
#import "Inspection.h"
#import "NetworkConnectionManager.h"
#import "Field.h"
#import "RenderPDFViewController.h"
#import "NavigationBarHelper.h"
#import "MenuButtonHelper.h"
#import "CustomLoadingView.h"
#import <QuartzCore/QuartzCore.h>

#define kDataPurpose @"Data"
#define kStringPurpose @"String"

#define kOperatorInformation @"guc_operator.plist"

#define DEFAULT_ROW_HEIGHT 64
#define HEADER_HEIGHT 60
#define HEADER_HEIGHT_TALLSCREEN 72

@interface InspectionViewController ()

@property(nonatomic)NSString *stationName;
@property(nonatomic)IBOutlet UITableView *theTableView;
@property(nonatomic)IBOutlet UIView *targetsAndAlarmsView;
@property(nonatomic)IBOutlet UIView *dimBackgroundView;
@property(nonatomic)IBOutlet UITextView *targetsAndAlarmsTextView;
@property(nonatomic)InspectionFormHelper *inspectionFormHelper;
@property(nonatomic)NSInteger openSectionIndex;
@property(nonatomic)Inspection *currentInspection;
@property(nonatomic)int headerHeight;
@property(nonatomic)CustomLoadingView *customLoadingView;
@property(nonatomic)BOOL checking;
@property(nonatomic)NSArray *substations;
@property(nonatomic)NSMutableArray *inspections;
@property(nonatomic)PickerViewHelper *pickerHelper;
@property(nonatomic)NSString *pickerType;
@property(nonatomic)UITextField *currentTextField;
@property(nonatomic)NSArray *currentChoices;
@property(nonatomic) NSIndexPath *textViewIndexPath;
@property(nonatomic) BOOL isKeyboardPresent;



@end

@implementation InspectionViewController

@synthesize stationName;
@synthesize theTableView;
@synthesize targetsAndAlarmsView;
@synthesize dimBackgroundView;
@synthesize targetsAndAlarmsTextView;
@synthesize inspectionFormHelper;
@synthesize openSectionIndex;
@synthesize currentInspection;
@synthesize headerHeight;
@synthesize customLoadingView;
@synthesize checking;
@synthesize substations;
@synthesize inspections;
@synthesize pickerHelper;
@synthesize pickerType;
@synthesize currentTextField;
@synthesize currentChoices;
@synthesize textViewIndexPath;
@synthesize isKeyboardPresent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithStation:(NSString*)station{
    if(self == [super init]){
        stationName = station;
    }
    return self;
}

- (void)viewDidLoad
{
    if(stationName){
        customLoadingView = [[CustomLoadingView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height) andTitle:@"Loading..."];
        [self.view addSubview:customLoadingView];
        [self beginInitialLoad];
    }
    
    checking = NO;
    isKeyboardPresent=NO;
    
    [NavigationBarHelper setBackButtonTitle:@"Back" forViewController:self];
    
    [PickerViewHelper setParentView:self];
    [self setAccessibilityLabel:@"Inspection"];
    pickerType = kDataPurpose;
    
    openSectionIndex = NSNotFound;
     
    if([UIScreen mainScreen].bounds.size.height == 568){
        headerHeight = HEADER_HEIGHT_TALLSCREEN;
    }else{
        headerHeight = HEADER_HEIGHT;
    }
    
    theTableView.sectionHeaderHeight = headerHeight;
    
    [dimBackgroundView setFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    [dimBackgroundView setAlpha:0];
    [dimBackgroundView setBackgroundColor:[UIColor blackColor]];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    [targetsAndAlarmsTextView.layer setBorderWidth:2.0];
    [targetsAndAlarmsTextView.layer setBorderColor:[[UIColor blackColor] CGColor]];
    [targetsAndAlarmsTextView setDelegate:self];
    [targetsAndAlarmsView addGestureRecognizer:tgr];
    [targetsAndAlarmsView setFrame:CGRectMake(39, -41-targetsAndAlarmsView.frame.size.height, targetsAndAlarmsView.frame.size.width, targetsAndAlarmsView.frame.size.height)];
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
    [self setMenuButtons];
}

-(void)setMenuButtons{
    if([substations count] > 1){
        NSArray *buttonTitlesArray = [[NSArray alloc]initWithObjects:@"Create Report", @"Refresh Form", @"Change Substation",nil];
        [[MenuButtonHelper sharedHelper]addButtonsWithTitlesToActionSheet:buttonTitlesArray];
        [[MenuButtonHelper sharedHelper]setButtonThreeTarget:self forSelector:@selector(showPicker)];
    }else{
        NSArray *buttonTitlesArray = [[NSArray alloc]initWithObjects:@"Create Report", @"Refresh Form", nil];
        [[MenuButtonHelper sharedHelper]addButtonsWithTitlesToActionSheet:buttonTitlesArray];
    }
    [[MenuButtonHelper sharedHelper]setButtonOneTarget:self forSelector:@selector(transitionToPDFView)];
    [[MenuButtonHelper sharedHelper]setButtonTwoTarget:self forSelector:@selector(beginInitialLoad)];
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
    NSArray *fieldsArray = [firstArray objectAtIndex:1];
    
    NSDictionary *fieldDictionary = [fieldsArray objectAtIndex:indexPath.row];
    
    Field *currentField = [[Field alloc]init];
    currentField.choices = [fieldDictionary objectForKey:@"choices"];
    currentField.name = [fieldDictionary objectForKey:@"name"];
    currentField.range = [fieldDictionary objectForKey:@"range"];
    currentField.type = [fieldDictionary objectForKey:@"type"];
    currentField.value = [fieldDictionary objectForKey:@"value"];
    
    NSString *fieldIndexPath = [[NSString alloc]initWithFormat:@"%i,%i", indexPath.section, indexPath.row];
    
    cell.cellLabel.text = currentField.name;
    cell.cellField.delegate = self;
    cell.cellField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    cell.cellField.userInteractionEnabled = YES;
    cell.cellField.accessibilityLabel = fieldIndexPath;
    cell.cellField.text = [self checkModelForTextValue:cell.cellLabel.text];
    cell.cellControl.accessibilityLabel = cell.cellLabel.text;
    cell.cellControl.selectedSegmentIndex = [self checkModelForBoolValue:cell.cellLabel.text];
    [cell.cellControl addTarget:self action:@selector(controlPressed:) forControlEvents:UIControlEventValueChanged];
    
    // "If" block for determining which controls exist for each individual cell
    if([currentField.type isEqualToString:@"String"] || [currentField.type isEqualToString:@"Float"] || [currentField.type isEqualToString:@"SingleChoice"]){
        cell.cellField.hidden = NO;
        cell.cellControl.hidden = YES;
    }else if([currentField.type isEqualToString:@"Boolean"]){
        cell.cellField.hidden = YES;
        cell.cellControl.hidden = NO;
    }
    
    if([currentField.name isEqualToString:@"StationName"]){
        cell.cellField.text = currentInspection.generalSettings.stationName;
        cell.cellField.userInteractionEnabled = NO;
    }
    if([currentField.name isEqualToString:@"DateTime"]){
        if(!currentInspection.generalSettings.dateTime){
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"MMMM dd, yyyy"];
            NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
            currentInspection.generalSettings.dateTime = dateString;
        }
        cell.cellField.text = currentInspection.generalSettings.dateTime;
        cell.cellField.userInteractionEnabled = NO;
    }
    if([currentField.name isEqualToString:@"Technician"]){
        if(!currentInspection.generalSettings.technician){
            currentInspection.generalSettings.technician = [self loadOperatorName];
        }
        cell.cellField.text = currentInspection.generalSettings.technician;
        cell.cellField.userInteractionEnabled = YES;
    }
    if([currentField.name isEqualToString:@"TargetsAndAlarms"]){
        textViewIndexPath = indexPath;
        if(indexPath.row == [fieldsArray count]-1){
            cell.cellField.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
    }
    
    return cell;
}


-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    NSArray *headerTitleArray = [inspectionFormHelper.containerArray objectAtIndex:section];
    NSString *titleString = [headerTitleArray objectAtIndex:0];
    
    InspectionCellHeaderView *headerView = [[InspectionCellHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, theTableView.bounds.size.width, headerHeight) title:titleString section:section theDelegate:self];
    
    return headerView;
}


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return DEFAULT_ROW_HEIGHT;
}


-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    if (indexPath.row == textViewIndexPath.row && indexPath.section == textViewIndexPath.section)
    {
        [theTableView setUserInteractionEnabled:NO];
        [UIView animateWithDuration:0.5 animations:^{
            [dimBackgroundView setAlpha:0.5];
            [targetsAndAlarmsView setFrame:CGRectMake(39, 41, targetsAndAlarmsView.frame.size.width, targetsAndAlarmsView.frame.size.height)];
        }];
    }
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
    [theTableView beginUpdates];
    [theTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [theTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [theTableView endUpdates];
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


#pragma mark - UITextField Delegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    currentTextField = textField;
    
    NSArray *fieldValues = [self getValuesForCurrentField:textField];
    
    if(pickerHelper.pickerInView == NO){
        if([fieldValues count] > 3){
            pickerType = kStringPurpose;
            currentChoices = [fieldValues objectAtIndex:3];
            [self showPicker];
            return NO;
        }
    }else if(pickerHelper.pickerInView == YES){
        [pickerHelper removePicker];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(checking == NO){
        checking = YES;
        [textField resignFirstResponder];
        NSArray *fieldValues = [self getValuesForCurrentField:textField];
        BOOL dataSaved = [self saveValueForCurrentField:fieldValues];
        
        NSArray *valueArray = [self getIndexPathForCurrentTextField:textField];
        int section = [[valueArray objectAtIndex:0]integerValue];
        int row = [[valueArray objectAtIndex:1]integerValue];
        
        InspectionContentCell *cell = (InspectionContentCell*)[theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
        if(dataSaved){
            cell.cellImageView.backgroundColor = [UIColor greenColor];
        }else{
            cell.cellImageView.backgroundColor = [UIColor redColor];
        }
        
        if([textField.text isEqualToString:@""]){
            cell.cellImageView.backgroundColor = [UIColor clearColor];
        }
    }
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if(checking == NO){
        checking = YES;
        NSArray *fieldValues = [self getValuesForCurrentField:textField];
        BOOL dataSaved = [self saveValueForCurrentField:fieldValues];
        
        NSArray *valueArray = [self getIndexPathForCurrentTextField:textField];
        int section = [[valueArray objectAtIndex:0]integerValue];
        int row = [[valueArray objectAtIndex:1]integerValue];
        
        InspectionContentCell *cell = (InspectionContentCell*)[theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
        if(dataSaved){
            cell.cellImageView.backgroundColor = [UIColor greenColor];
        }else{
            cell.cellImageView.backgroundColor = [UIColor redColor];
        }
        
        if([textField.text isEqualToString:@""]){
            cell.cellImageView.backgroundColor = [UIColor clearColor];
        }
    }
    
    return YES;
}
                                                               
-(NSArray*)getIndexPathForCurrentTextField:(UITextField*)textField{
    NSString *indexPathString = textField.accessibilityLabel;
    NSArray *valueArray = [indexPathString componentsSeparatedByString:@","];
    
    return valueArray;
}

-(NSArray*)getValuesForCurrentField:(UITextField*)textField{
    NSArray *valueArray = [self getIndexPathForCurrentTextField:textField];
    int section = [[valueArray objectAtIndex:0]integerValue];
    int row = [[valueArray objectAtIndex:1]integerValue];
    
    NSArray *firstArray = [inspectionFormHelper.containerArray objectAtIndex:section];
    NSArray *fieldsArray = [firstArray objectAtIndex:1];
    
    NSDictionary *fieldDictionary = [fieldsArray objectAtIndex:row];
    
    Field *currentField = [[Field alloc]init];
    currentField.choices = [fieldDictionary objectForKey:@"choices"];
    currentField.name = [fieldDictionary objectForKey:@"name"];
    currentField.range = [fieldDictionary objectForKey:@"range"];
    currentField.type = [fieldDictionary objectForKey:@"type"];
    currentField.value = [fieldDictionary objectForKey:@"value"];
    
    NSString *fieldValue = textField.text;
    
    NSArray *fieldValues;
    if(currentField.choices != (id)[NSNull null]){
        fieldValues = [[NSArray alloc]initWithObjects:currentField.name, fieldValue, currentField.range, currentField.choices,nil];
    }else{
        fieldValues = [[NSArray alloc]initWithObjects:currentField.name, fieldValue, currentField.range, nil];
    }
    
    return fieldValues;
}

-(BOOL)saveValueForCurrentField:(NSArray *)fieldValues{
    if(currentInspection){
        NSString *fieldName = [fieldValues objectAtIndex:0];
        NSString *fieldValue = [fieldValues objectAtIndex:1];
        NSArray *fieldRange = [fieldValues objectAtIndex:2];
        
        if([fieldRange count] > 0 && ![fieldValue isEqualToString:@""]){
            float rangeA = [[fieldRange objectAtIndex:0]floatValue];
            float rangeB = [[fieldRange objectAtIndex:1]floatValue];
            float value = [fieldValue floatValue];
            
            //NSString *message = [[NSString alloc]initWithFormat:@"The value you've entered for %@ is out of range.\nPlease re-enter and try again.", fieldName];
            
            if(value > rangeB || value < rangeA){
                /*UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Value Out of Range!" message:message delegate:self cancelButtonTitle:@"Okay." otherButtonTitles:nil];
                [alertView show];*/
                checking = NO;
                return NO;
            }
        }
        
        if([fieldName isEqualToString:@"KWH"]){
            currentInspection.generalSettings.kwh = fieldValue;
        }else if([fieldName isEqualToString:@"MWD"]){
            currentInspection.generalSettings.mwd = fieldValue;
        }else if([fieldName isEqualToString:@"+KVARH"]){
            currentInspection.generalSettings.positiveKVARH = fieldValue;
        }else if([fieldName isEqualToString:@"-KVARH"]){
            currentInspection.generalSettings.negativeKVARH = fieldValue;
        }else if([fieldName isEqualToString:@"MAXVARD"]){
            currentInspection.generalSettings.maxVARD = fieldValue;
        }else if([fieldName isEqualToString:@"MINVARD"]){
            currentInspection.generalSettings.minVARD = fieldValue;
        }else if([fieldName isEqualToString:@"MaxAmp A"]){
            currentInspection.switchBoard.maxAmpA = fieldValue;
        }else if([fieldName isEqualToString:@"MaxAmp B"]){
            currentInspection.switchBoard.maxAmpB = fieldValue;
        }else if([fieldName isEqualToString:@"MaxAmp C"]){
            currentInspection.switchBoard.maxAmpC = fieldValue;
        }else if([fieldName isEqualToString:@"Present Amp A"]){
            currentInspection.switchBoard.presentAmpA = fieldValue;
        }else if([fieldName isEqualToString:@"Present Amp B"]){
            currentInspection.switchBoard.presentAmpB = fieldValue;
        }else if([fieldName isEqualToString:@"Present Amp C"]){
            currentInspection.switchBoard.presentAmpC = fieldValue;
        }else if([fieldName isEqualToString:@"Min Volts A"]){
            currentInspection.switchBoard.minVoltsA = fieldValue;
        }else if([fieldName isEqualToString:@"Min Volts B"]){
            currentInspection.switchBoard.minVoltsB = fieldValue;
        }else if([fieldName isEqualToString:@"Min Volts C"]){
            currentInspection.switchBoard.minVoltsC = fieldValue;
        }else if([fieldName isEqualToString:@"Present Volts A"]){
            currentInspection.switchBoard.presentVoltsA = fieldValue;
        }else if([fieldName isEqualToString:@"Present Volts B"]){
            currentInspection.switchBoard.presentVoltsB = fieldValue;
        }else if([fieldName isEqualToString:@"Present Volts C"]){
            currentInspection.switchBoard.presentVoltsC = fieldValue;
        }else if([fieldName isEqualToString:@"Max Volts A"]){
            currentInspection.switchBoard.maxVoltsA = fieldValue;
        }else if([fieldName isEqualToString:@"Max Volts B"]){
            currentInspection.switchBoard.maxVoltsB = fieldValue;
        }else if([fieldName isEqualToString:@"Max Volts C"]){
            currentInspection.switchBoard.maxVoltsC = fieldValue;
        }else if([fieldName isEqualToString:@"Volts 48V #1"]){
            currentInspection.batteryCharger.volts48VOne = fieldValue;
        }else if([fieldName isEqualToString:@"Amps 48V #1"]){
            currentInspection.batteryCharger.amps48VOne = fieldValue;
        }else if([fieldName isEqualToString:@"Spec. Gravity 48V #1"]){
            currentInspection.batteryCharger.specGravity48VOne = fieldValue;
        }else if([fieldName isEqualToString:@"Pressure"]){
            currentInspection.transformer.pressure = fieldValue;
        }else if([fieldName isEqualToString:@"Nitrogen Tank"]){
            currentInspection.transformer.nitrogenTank = fieldValue;
        }else if([fieldName isEqualToString:@"Min Step A"]){
            currentInspection.ltcRegulator.minStepA = fieldValue;
        }else if([fieldName isEqualToString:@"Pres. Step A"]){
            currentInspection.ltcRegulator.pressureStepA = fieldValue;
        }else if([fieldName isEqualToString:@"Max Step A"]){
            currentInspection.ltcRegulator.maxStepA = fieldValue;
        }else if([fieldName isEqualToString:@"Counter A"]){
            currentInspection.ltcRegulator.counterA = fieldValue;
        }else if([fieldName isEqualToString:@"Voltage A"]){
            currentInspection.ltcRegulator.voltageA = fieldValue;
        }else if([fieldName isEqualToString:@"Min Step B"]){
            currentInspection.ltcRegulator.minStepB = fieldValue;
        }else if([fieldName isEqualToString:@"Pres. Step B"]){
            currentInspection.ltcRegulator.pressureStepB = fieldValue;
        }else if([fieldName isEqualToString:@"Max Step B"]){
            currentInspection.ltcRegulator.maxStepB = fieldValue;
        }else if([fieldName isEqualToString:@"Counter B"]){
            currentInspection.ltcRegulator.counterB = fieldValue;
        }else if([fieldName isEqualToString:@"Voltage B"]){
            currentInspection.ltcRegulator.voltageB = fieldValue;
        }else if([fieldName isEqualToString:@"Min Step C"]){
            currentInspection.ltcRegulator.minStepC = fieldValue;
        }else if([fieldName isEqualToString:@"Pres. Step C"]){
            currentInspection.ltcRegulator.pressureStepC = fieldValue;
        }else if([fieldName isEqualToString:@"Max Step C"]){
            currentInspection.ltcRegulator.maxStepC = fieldValue;
        }else if([fieldName isEqualToString:@"Counter C"]){
            currentInspection.ltcRegulator.counterC = fieldValue;
        }else if([fieldName isEqualToString:@"Voltage C"]){
            currentInspection.ltcRegulator.voltageC = fieldValue;
        }else if([fieldName isEqualToString:currentInspection.breakers.busSlotCounterName]){
            currentInspection.breakers.busSlotCounterValue = fieldValue;
        }else if([fieldName isEqualToString:currentInspection.breakers.busSlotTargetName]){
            currentInspection.breakers.busSlotTargetValue = fieldValue;
        }else if([fieldName isEqualToString:currentInspection.breakers.busSlotOperationName]){
            currentInspection.breakers.busSlotOperationValue = fieldValue;
        }else if([fieldName isEqualToString:currentInspection.breakers.cktSlotOneCounterName]){
            currentInspection.breakers.cktSlotOneCounterValue = fieldValue;
        }else if([fieldName isEqualToString:currentInspection.breakers.cktSlotOneTargetName]){
            currentInspection.breakers.cktSlotOneTargetValue = fieldValue;
        }else if([fieldName isEqualToString:currentInspection.breakers.cktSlotOneOperationName]){
            currentInspection.breakers.cktSlotOneOperationValue = fieldValue;
        }else {
            // Do nothing.
        }
        
        checking = NO;
        
        return YES;
    }
    return NO;
}

-(NSString*)checkModelForTextValue:(NSString*)cellTitle{
    if([cellTitle isEqualToString:@"KWH"]){
        if(currentInspection.generalSettings.kwh)
            return currentInspection.generalSettings.kwh;
    }else if([cellTitle isEqualToString:@"MWD"]){
        if(currentInspection.generalSettings.mwd)
            return currentInspection.generalSettings.mwd;
    }else if([cellTitle isEqualToString:@"+KVARH"]){
        if(currentInspection.generalSettings.positiveKVARH)
            return currentInspection.generalSettings.positiveKVARH;
    }else if([cellTitle isEqualToString:@"-KVARH"]){
        if(currentInspection.generalSettings.negativeKVARH)
            return currentInspection.generalSettings.negativeKVARH;
    }else if([cellTitle isEqualToString:@"MAXVARD"]){
        if(currentInspection.generalSettings.maxVARD)
            return currentInspection.generalSettings.maxVARD;
    }else if([cellTitle isEqualToString:@"MINVARD"]){
        if(currentInspection.generalSettings.minVARD)
            return currentInspection.generalSettings.minVARD;
    }else if([cellTitle isEqualToString:@"MaxAmp A"]){
        if(currentInspection.switchBoard.maxAmpA)
            return currentInspection.switchBoard.maxAmpA;
    }else if([cellTitle isEqualToString:@"MaxAmp B"]){
        if(currentInspection.switchBoard.maxAmpB)
            return currentInspection.switchBoard.maxAmpB;
    }else if([cellTitle isEqualToString:@"MaxAmp C"]){
        if(currentInspection.switchBoard.maxAmpC)
            return currentInspection.switchBoard.maxAmpC;
    }else if([cellTitle isEqualToString:@"Present Amp A"]){
        if(currentInspection.switchBoard.presentAmpA)
            return currentInspection.switchBoard.presentAmpA;
    }else if([cellTitle isEqualToString:@"Present Amp B"]){
        if(currentInspection.switchBoard.presentAmpB)
            return currentInspection.switchBoard.presentAmpB;
    }else if([cellTitle isEqualToString:@"Present Amp C"]){
        if(currentInspection.switchBoard.presentAmpC)
            return currentInspection.switchBoard.presentAmpC;
    }else if([cellTitle isEqualToString:@"Min Volts A"]){
        if(currentInspection.switchBoard.minVoltsA)
            return currentInspection.switchBoard.minVoltsA;
    }else if([cellTitle isEqualToString:@"Min Volts B"]){
        if(currentInspection.switchBoard.minVoltsB)
            return currentInspection.switchBoard.minVoltsB;
    }else if([cellTitle isEqualToString:@"Min Volts C"]){
        if(currentInspection.switchBoard.minVoltsC)
            return currentInspection.switchBoard.minVoltsC;
    }else if([cellTitle isEqualToString:@"Present Volts A"]){
        if(currentInspection.switchBoard.presentVoltsA)
            return currentInspection.switchBoard.presentVoltsA;
    }else if([cellTitle isEqualToString:@"Present Volts B"]){
        if(currentInspection.switchBoard.presentVoltsB)
            return currentInspection.switchBoard.presentVoltsB;
    }else if([cellTitle isEqualToString:@"Present Volts C"]){
        if(currentInspection.switchBoard.presentVoltsC)
            return currentInspection.switchBoard.presentVoltsC;
    }else if([cellTitle isEqualToString:@"Max Volts A"]){
        if(currentInspection.switchBoard.maxVoltsA)
            return currentInspection.switchBoard.maxVoltsA;
    }else if([cellTitle isEqualToString:@"Max Volts B"]){
        if(currentInspection.switchBoard.maxVoltsB)
            return currentInspection.switchBoard.maxVoltsB;
    }else if([cellTitle isEqualToString:@"Max Volts C"]){
        if(currentInspection.switchBoard.maxVoltsC)
            return currentInspection.switchBoard.maxVoltsC;
    }else if([cellTitle isEqualToString:@"Volts 48V #1"]){
            return currentInspection.batteryCharger.volts48VOne;
    }else if([cellTitle isEqualToString:@"Amps 48V #1"]){
        if(currentInspection.batteryCharger.amps48VOne)
            return currentInspection.batteryCharger.amps48VOne;
    }else if([cellTitle isEqualToString:@"Spec. Gravity 48V #1"]){
        if(currentInspection.batteryCharger.specGravity48VOne)
            return currentInspection.batteryCharger.specGravity48VOne;
    }else if([cellTitle isEqualToString:@"Pressure"]){
        if(currentInspection.transformer.pressure)
            return currentInspection.transformer.pressure;
    }else if([cellTitle isEqualToString:@"Nitrogen Tank"]){
        if(currentInspection.transformer.nitrogenTank)
            return currentInspection.transformer.nitrogenTank;
    }else if([cellTitle isEqualToString:@"Min Step A"]){
        if(currentInspection.ltcRegulator.minStepA)
            return currentInspection.ltcRegulator.minStepA;
    }else if([cellTitle isEqualToString:@"Pressure Step A"]){
        if(currentInspection.ltcRegulator.pressureStepA)
            return currentInspection.ltcRegulator.pressureStepA;
    }else if([cellTitle isEqualToString:@"Max Step A"]){
        if(currentInspection.ltcRegulator.maxStepA)
            return currentInspection.ltcRegulator.maxStepA;
    }else if([cellTitle isEqualToString:@"Counter A"]){
        if(currentInspection.ltcRegulator.counterA)
            return currentInspection.ltcRegulator.counterA;
    }else if([cellTitle isEqualToString:@"Voltage A"]){
        if(currentInspection.ltcRegulator.voltageA)
            return currentInspection.ltcRegulator.voltageA;
    }else if([cellTitle isEqualToString:@"Min Step B"]){
        if(currentInspection.ltcRegulator.minStepB)
            return currentInspection.ltcRegulator.minStepB;
    }else if([cellTitle isEqualToString:@"Pressure Step B"]){
        if(currentInspection.ltcRegulator.pressureStepB)
            return currentInspection.ltcRegulator.pressureStepB;
    }else if([cellTitle isEqualToString:@"Max Step B"]){
        if(currentInspection.ltcRegulator.maxStepB)
            return currentInspection.ltcRegulator.maxStepB;
    }else if([cellTitle isEqualToString:@"Counter B"]){
        if(currentInspection.ltcRegulator.counterB)
            return currentInspection.ltcRegulator.counterB;
    }else if([cellTitle isEqualToString:@"Voltage B"]){
        if(currentInspection.ltcRegulator.voltageB)
            return currentInspection.ltcRegulator.voltageB;
    }else if([cellTitle isEqualToString:@"Min Step C"]){
        if(currentInspection.ltcRegulator.minStepC)
            return currentInspection.ltcRegulator.minStepC;
    }else if([cellTitle isEqualToString:@"Pressure Step C"]){
        if(currentInspection.ltcRegulator.pressureStepC)
            return currentInspection.ltcRegulator.pressureStepC;
    }else if([cellTitle isEqualToString:@"Max Step C"]){
        if(currentInspection.ltcRegulator.maxStepC)
            return currentInspection.ltcRegulator.maxStepC;
    }else if([cellTitle isEqualToString:@"Counter C"]){
        if(currentInspection.ltcRegulator.counterC)
            return currentInspection.ltcRegulator.counterC;
    }else if([cellTitle isEqualToString:@"Voltage C"]){
        if(currentInspection.ltcRegulator.voltageC)
            return currentInspection.ltcRegulator.voltageC;
    }else if([cellTitle isEqualToString:currentInspection.breakers.busSlotCounterName]){
        if(currentInspection.breakers.busSlotCounterValue)
            return currentInspection.breakers.busSlotCounterValue;
    }else if([cellTitle isEqualToString:currentInspection.breakers.busSlotTargetName]){
        if(currentInspection.breakers.busSlotTargetValue)
            return currentInspection.breakers.busSlotTargetValue;
    }else if([cellTitle isEqualToString:currentInspection.breakers.busSlotOperationName]){
        if(currentInspection.breakers.busSlotOperationValue)
            return currentInspection.breakers.busSlotOperationValue;
    }else if([cellTitle isEqualToString:currentInspection.breakers.cktSlotOneCounterName]){
        if(currentInspection.breakers.cktSlotOneCounterValue)
            return currentInspection.breakers.cktSlotOneCounterValue;
    }else if([cellTitle isEqualToString:currentInspection.breakers.cktSlotFourTargetName]){
        if(currentInspection.breakers.cktSlotOneTargetValue)
            return currentInspection.breakers.cktSlotOneTargetValue;
    }else if([cellTitle isEqualToString:currentInspection.breakers.cktSlotOneOperationName]){
        if(currentInspection.breakers.cktSlotOneOperationValue)
            return currentInspection.breakers.cktSlotOneOperationValue;
    }else{
        // Do nothing.
    }
    return @"";
}


#pragma mark - UISegmentedControl Methods

-(void)controlPressed:(id)sender{
    UISegmentedControl *theControl = sender;
    if(currentInspection){
        if([theControl.accessibilityLabel isEqualToString:@"Gas A"]){
            currentInspection.circuitSwitcher.gasA = [theControl selectedSegmentIndex];
        }else if([theControl.accessibilityLabel isEqualToString:@"Gas B"]){
            currentInspection.circuitSwitcher.gasB = [theControl selectedSegmentIndex];
        }else if([theControl.accessibilityLabel isEqualToString:@"Gas C"]){
            currentInspection.circuitSwitcher.gasC = [theControl selectedSegmentIndex];
        }else if([theControl.accessibilityLabel isEqualToString:@"Tank Oil Level"]){
            currentInspection.transformer.tankOilLevel = [theControl selectedSegmentIndex];
        }else if([theControl.accessibilityLabel isEqualToString:@"Bushing Oil Level"]){
            currentInspection.transformer.bushingOilLevel = [theControl selectedSegmentIndex];
        }else if([theControl.accessibilityLabel isEqualToString:@"Pressure A"]){
            currentInspection.ltcRegulator.pressureA = [theControl selectedSegmentIndex];
        }else if([theControl.accessibilityLabel isEqualToString:@"Oil Level A"]){
            currentInspection.ltcRegulator.oilLevelA = [theControl selectedSegmentIndex];
        }else if([theControl.accessibilityLabel isEqualToString:@"Test Operation A"]){
            currentInspection.ltcRegulator.testOperationA = [theControl selectedSegmentIndex];
        }else if([theControl.accessibilityLabel isEqualToString:@"Pressure B"]){
            currentInspection.ltcRegulator.pressureB = [theControl selectedSegmentIndex];
        }else if([theControl.accessibilityLabel isEqualToString:@"Oil Level B"]){
            currentInspection.ltcRegulator.oilLevelB = [theControl selectedSegmentIndex];
        }else if([theControl.accessibilityLabel isEqualToString:@"Test Operation B"]){
            currentInspection.ltcRegulator.testOperationB = [theControl selectedSegmentIndex];
        }else if([theControl.accessibilityLabel isEqualToString:@"Pressure C"]){
            currentInspection.ltcRegulator.pressureC = [theControl selectedSegmentIndex];
        }else if([theControl.accessibilityLabel isEqualToString:@"Oil Level C"]){
            currentInspection.ltcRegulator.oilLevelC = [theControl selectedSegmentIndex];
        }else if([theControl.accessibilityLabel isEqualToString:@"Test Operation C"]){
            currentInspection.ltcRegulator.testOperationC = [theControl selectedSegmentIndex];
        }else{
            // Do nothing.
        }
    }
}

-(BOOL)checkModelForBoolValue:(NSString*)cellTitle{
    if([cellTitle isEqualToString:@"Gas A"]){
        if(currentInspection.circuitSwitcher.gasA)
            return currentInspection.circuitSwitcher.gasA;
    }else if([cellTitle isEqualToString:@"Gas B"]){
        if(currentInspection.circuitSwitcher.gasB)
            return currentInspection.circuitSwitcher.gasB;
    }else if([cellTitle isEqualToString:@"Gas C"]){
        if(currentInspection.circuitSwitcher.gasC)
            return currentInspection.circuitSwitcher.gasC;
    }else if([cellTitle isEqualToString:@"Tank Oil Level"]){
        if(currentInspection.transformer.tankOilLevel)
            return currentInspection.transformer.tankOilLevel;
    }else if([cellTitle isEqualToString:@"Bushing Oil Level"]){
        if(currentInspection.transformer.bushingOilLevel)
            return currentInspection.transformer.bushingOilLevel;
    }else if([cellTitle isEqualToString:@"Pressure A"]){
        if(currentInspection.ltcRegulator.pressureA)
            return currentInspection.ltcRegulator.pressureA;
    }else if([cellTitle isEqualToString:@"Oil Level A"]){
        if(currentInspection.ltcRegulator.oilLevelA)
            return currentInspection.ltcRegulator.oilLevelA;
    }else if([cellTitle isEqualToString:@"Test Operation A"]){
        if(currentInspection.ltcRegulator.testOperationA)
            return currentInspection.ltcRegulator.testOperationA;
    }else if([cellTitle isEqualToString:@"Pressure B"]){
        if(currentInspection.ltcRegulator.pressureB)
            return currentInspection.ltcRegulator.pressureB;
    }else if([cellTitle isEqualToString:@"Oil Level B"]){
        if(currentInspection.ltcRegulator.oilLevelB)
            return currentInspection.ltcRegulator.oilLevelB;
    }else if([cellTitle isEqualToString:@"Test Operation B"]){
        if(currentInspection.ltcRegulator.testOperationB)
            return currentInspection.ltcRegulator.testOperationB;
    }else if([cellTitle isEqualToString:@"Pressure C"]){
        if(currentInspection.ltcRegulator.pressureC)
            return currentInspection.ltcRegulator.pressureC;
    }else if([cellTitle isEqualToString:@"Oil Level C"]){
        if(currentInspection.ltcRegulator.oilLevelC)
            return currentInspection.ltcRegulator.oilLevelC;
    }else if([cellTitle isEqualToString:@"Test Operation C"]){
        if(currentInspection.ltcRegulator.testOperationC)
            return currentInspection.ltcRegulator.testOperationC;
    }else{
        // Do nothing.
    }
    return NO;
}


#pragma mark - AsyncResponse Delegate Methods

-(void)asyncResponseDidReturnObjects:(NSArray *)theObjects{
    if([theObjects count] > 0){
        NSLog(@"Returned substations are:\n%@",theObjects);
        if([theObjects count] > 1){
            //Handle for if there are multiple substations at the site.
            
            substations = [[NSArray alloc]initWithArray:theObjects];
            
            if(!inspections){
                inspections = [[NSMutableArray alloc]init];
            }
            for(int i = 0; i < [substations count]; i++){
                Inspection *anInspection = [[Inspection alloc]init];
                [inspections addObject:anInspection];
            }
            
            [self setMenuButtons];
            [self showPicker];
        }else{
            //Handle for if there is only one substation at the site.
            
            NSDictionary *stationDictionary = [theObjects objectAtIndex:0];
            NSDictionary *stationInfo = [stationDictionary objectForKey:@"stationInfo"];
            NSLog(@"Station information is:\n%@", stationInfo);
            
            if(self.navigationItem.title != [stationInfo objectForKey:@"name"]){
                self.navigationItem.title = [stationInfo objectForKey:@"name"];
            }
             
            if(!currentInspection){
                currentInspection = [[Inspection alloc]init];
            }
            
            currentInspection.generalSettings.stationName = [stationInfo objectForKey:@"name"];
            
            NSArray *sectionsArray = [stationDictionary objectForKey:@"sections"];
            
            NSArray *breakersArray;
            
            for(int i = 0; i < [sectionsArray count]; i++){
                NSDictionary *currentDictionary = [sectionsArray objectAtIndex:i];
                
                if([[currentDictionary objectForKey:@"name"] isEqualToString:@"Breakers"]){
                    breakersArray = [currentDictionary objectForKey:@"fields"];
                }
            }
            
            // Set the names of the Bus and Circuit fields.
            [self setBreakersFieldsFromArray:breakersArray];
            
            if(!inspectionFormHelper){
                inspectionFormHelper = [[InspectionFormHelper alloc]initWithSections:[stationInfo objectForKey:@"sections"]];
            }
            
            theTableView.hidden = NO;
            [theTableView reloadData];
        }
    }
    if(customLoadingView.isLoading == YES){
        [customLoadingView stopLoading];
    }
}

-(void)asyncResponseDidFailWithError{
    NSLog(@"Error! Connection failed.");
}


#pragma mark - PickerHelper Delegate Methods

-(void)pickerDidPickData:(id)theData atIndex:(NSInteger)theIndex forPurpose:(NSString*)purpose{
    if([purpose isEqualToString:kDataPurpose]){
        NSDictionary *stationDictionary = theData;
        NSDictionary *stationInfo = [stationDictionary objectForKey:@"stationInfo"];
        NSLog(@"Station information is:\n%@", stationInfo);
        
        if(self.navigationItem.title != [stationInfo objectForKey:@"name"]){
            self.navigationItem.title = [stationInfo objectForKey:@"name"];
        }
        
        if(!currentInspection){
            currentInspection = [[Inspection alloc]init];
        }
        
        currentInspection = [inspections objectAtIndex:theIndex];
        currentInspection.generalSettings.stationName = [stationInfo objectForKey:@"name"];
        
        NSArray *sectionsArray = [stationDictionary objectForKey:@"sections"];
        
        NSArray *breakersArray;
        
        for(int i = 0; i < [sectionsArray count]; i++){
            NSDictionary *currentDictionary = [sectionsArray objectAtIndex:i];
            
            if([[currentDictionary objectForKey:@"name"] isEqualToString:@"Breakers"]){
                breakersArray = [currentDictionary objectForKey:@"fields"];
            }
        }
        
        // Set the names of the Bus and Circuit fields.
        [self setBreakersFieldsFromArray:breakersArray];
            
        inspectionFormHelper = [[InspectionFormHelper alloc]initWithSections:[stationInfo objectForKey:@"sections"]];
        
        theTableView.hidden = NO;
        
        openSectionIndex = NSNotFound;
        
        [theTableView reloadData];
    }else{
        NSString *technicianName = theData;
        
        currentInspection.generalSettings.technician = technicianName;
        
        currentTextField.text = currentInspection.generalSettings.technician;
    }
}

-(void)setBreakersFieldsFromArray:(NSArray*)breakersArray{
    for(int i = 0; i < [breakersArray count]; i++){
        NSDictionary *fieldDictionary = [breakersArray objectAtIndex:i];
        Field *aField = [[Field alloc]init];
        aField.name = [fieldDictionary objectForKey:@"name"];
        
        if([aField.name rangeOfString:@"Bus"].location != NSNotFound){
            if([aField.name rangeOfString:@"Counter"].location > 0){
                currentInspection.breakers.busSlotCounterName = aField.name;
            }else if([aField.name rangeOfString:@"Target"].location > 0){
                currentInspection.breakers.busSlotTargetName = aField.name;
            }else if([aField.name rangeOfString:@"Oper"].location > 0){
                currentInspection.breakers.busSlotOperationName = aField.name;
            }else if([aField.name rangeOfString:@"Pressure"].location > 0){
                currentInspection.breakers.busSlotPressureName = aField.name;
            }
        }else if([aField.name rangeOfString:@"CKT"].location != NSNotFound){
            if([aField.name rangeOfString:@"Counter"].location > 0){
                if(!currentInspection.breakers.cktSlotOneCounterName){
                    currentInspection.breakers.cktSlotOneCounterName = aField.name;
                }else if(!currentInspection.breakers.cktSlotTwoCounterName){
                    currentInspection.breakers.cktSlotTwoCounterName = aField.name;
                }else if(!currentInspection.breakers.cktSlotThreeCounterName){
                    currentInspection.breakers.cktSlotThreeCounterName = aField.name;
                }else if(!currentInspection.breakers.cktSlotFourCounterName){
                    currentInspection.breakers.cktSlotFourCounterName = aField.name;
                }else if(!currentInspection.breakers.cktSlotFiveCounterName){
                    currentInspection.breakers.cktSlotFiveCounterName = aField.name;
                }else if(!currentInspection.breakers.cktSlotSixCounterName){
                    currentInspection.breakers.cktSlotSixCounterName = aField.name;
                }else if(!currentInspection.breakers.cktSlotSevenCounterName){
                    currentInspection.breakers.cktSlotSevenCounterName = aField.name;
                }
            }else if([aField.name rangeOfString:@"Target"].location > 0){
                if(!currentInspection.breakers.cktSlotOneTargetName){
                    currentInspection.breakers.cktSlotOneTargetName = aField.name;
                }else if(!currentInspection.breakers.cktSlotTwoTargetName){
                    currentInspection.breakers.cktSlotTwoTargetName = aField.name;
                }else if(!currentInspection.breakers.cktSlotThreeTargetName){
                    currentInspection.breakers.cktSlotThreeTargetName = aField.name;
                }else if(!currentInspection.breakers.cktSlotFourTargetName){
                    currentInspection.breakers.cktSlotFourTargetName = aField.name;
                }else if(!currentInspection.breakers.cktSlotFiveTargetName){
                    currentInspection.breakers.cktSlotFiveTargetName = aField.name;
                }else if(!currentInspection.breakers.cktSlotSixTargetName){
                    currentInspection.breakers.cktSlotSixTargetName = aField.name;
                }else if(!currentInspection.breakers.cktSlotSevenTargetName){
                    currentInspection.breakers.cktSlotSevenTargetName = aField.name;
                }
            }else if([aField.name rangeOfString:@"Oper"].location > 0){
                
            }else if([aField.name rangeOfString:@"Pressure"].location > 0){
                
            }
        }
    }
}


#pragma mark - Class Related Methods

-(void)beginInitialLoad{
    theTableView.hidden = YES;
    [customLoadingView beginLoading];
    [[NetworkConnectionManager sharedManager]beginConnectionWithStation:stationName forCaller:self];
}

-(void)transitionToPDFView{
    /*for(int i = 0; i < [inspectionFormHelper.containerArray count]; i++){
        NSArray *firstArray = [inspectionFormHelper.containerArray objectAtIndex:i];
        NSArray *fieldsArray = [firstArray objectAtIndex:1];
        
        for(int i = 0; i < [fieldsArray count]; i++){
            NSDictionary *fieldDictionary = [fieldsArray objectAtIndex:i];
            
            Field *currentField = [[Field alloc]init];
            currentField.choices = [fieldDictionary objectForKey:@"choices"];
            currentField.name = [fieldDictionary objectForKey:@"name"];
            currentField.range = [fieldDictionary objectForKey:@"range"];
            currentField.type = [fieldDictionary objectForKey:@"type"];
            currentField.value = [fieldDictionary objectForKey:@"value"];
            
            NSString *returnedString = [self checkModelForTextValue:currentField.name];
            
            if(returnedString == nil || returnedString == (id)[NSNull null] || [returnedString isEqualToString:@""]){
                [self createAlertViewForField:currentField.name];
                return;
            }
        }
    }*/
    RenderPDFViewController *renderPDFVC = [[RenderPDFViewController alloc]initWithInspection:currentInspection];
    [self.navigationController pushViewController:renderPDFVC animated:YES];
}

-(void)showPicker{
    if(pickerHelper){
        pickerHelper = nil;
    }
    if([pickerType isEqualToString:kDataPurpose]){
        pickerHelper = [[PickerViewHelper alloc]initWithDataSource:substations andPurpose:kDataPurpose];
    }else{
        pickerHelper = [[PickerViewHelper alloc]initWithDataSource:currentChoices andPurpose:kStringPurpose];
    }
    pickerHelper.delegate = self;
    [pickerHelper displayPicker];
}


#pragma mark - UIAlertView Methods

-(void)createAlertViewForField:(NSString*)fieldName{
    NSString *message = [[NSString alloc]initWithFormat:@"The %@ field requires a value.\nPlease fill it out and try again.",fieldName];
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Form Incomplete!" message:message delegate:self cancelButtonTitle:@"Okay." otherButtonTitles:nil];
    [alertView show];
}


#pragma mark - MenuButton Methods

-(void)displayMenuForButton{
    pickerType = kDataPurpose;
    [[MenuButtonHelper sharedHelper]displayMenu];
}

#pragma mark - Dismiss TargetsAndAlarms view

-(IBAction)dismissTargetsAndAlarms:(id)sender
{
    InspectionContentCell *cell = (InspectionContentCell *)[theTableView cellForRowAtIndexPath:textViewIndexPath];
    
    isKeyboardPresent = NO;
    
    if (![targetsAndAlarmsTextView.text isEqualToString:@"Enter targets and alarms here..."] )
    {
        cell.cellDetailsLabel.text = targetsAndAlarmsTextView.text;
        currentInspection.switchBoard.targetsAlarms = targetsAndAlarmsTextView.text;
    }

    [theTableView setUserInteractionEnabled:YES];
    [UIView animateWithDuration:0.5 animations:^{
        [targetsAndAlarmsView setFrame:CGRectMake(39, -41-targetsAndAlarmsView.frame.size.height, targetsAndAlarmsView.frame.size.width, targetsAndAlarmsView.frame.size.height)];
        [dimBackgroundView setAlpha:0];
    }];

    [targetsAndAlarmsTextView resignFirstResponder];
}

#pragma mark - Dismiss keyboard

- (void) dismissKeyboard
{
    if (targetsAndAlarmsTextView && ![targetsAndAlarmsTextView isHidden])
    {
        [targetsAndAlarmsTextView resignFirstResponder];
    }
}

#pragma mark - TextView Delegates

-(void)textViewDidBeginEditing:(UITextView *)textView
{    
    isKeyboardPresent = YES;
    [UIView animateWithDuration:0.2 animations:^{
        [targetsAndAlarmsView setCenter:CGPointMake(targetsAndAlarmsView.center.x, 80)];
    }];
    if ([textView.text isEqualToString:@"Enter targets and alarms here..."])
    {
        [textView setText:@""];
    }
}

- (void) textViewDidEndEditing:(UITextView *)textView
{
    if (isKeyboardPresent)
        [UIView animateWithDuration:0.2 animations:^{
            [targetsAndAlarmsView setCenter:CGPointMake(targetsAndAlarmsView.center.x, 178)];
        }];
    isKeyboardPresent = NO;
    if ([textView.text length] == 0)
    {
        [textView setText:@"Enter targets and alarms here..."];
    }
}


@end
