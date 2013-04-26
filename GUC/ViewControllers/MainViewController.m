//
//  MainViewController.m
//  GUC
//
//  Created by Michael Brodeur on 4/8/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "MainViewController.h"
#import "NewInspectionsViewController.h"
#import "NavigationBarHelper.h"
#import "NetworkConnectionManager.h"

#define kOperatorInformation @"guc_operator.plist"

@interface MainViewController ()

@property(nonatomic)IBOutlet UITextField *nameField;
@property(nonatomic)PickerViewHelper *pickerHelper;

//-(IBAction)loginButtonPressed:(id)sender;

@end

@implementation MainViewController

@synthesize nameField;
@synthesize pickerHelper;

- (void)viewDidLoad
{
    self.navigationItem.title = @"Welcome!";
    [self setAccessibilityLabel:@"Main"];
    
    [NavigationBarHelper setBackButtonTitle:@"Back" forViewController:self];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [PickerViewHelper setParentView:self];
    [[NetworkConnectionManager sharedManager]beginConnectionWithPurpose:@"Names" forCaller:self];
}

/*-(IBAction)loginButtonPressed:(id)sender{
    if([nameField.text length] > 0){
        [self saveNameToDisk:nameField.text];
        [self transitionToNewInspections];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"No Name"
                                                           message:@"Please enter your name to continue."
                                                          delegate:self
                                                 cancelButtonTitle:@"Okay"
                                                 otherButtonTitles:nil];
        [alertView show];
    }
}*/

-(void)saveNameToDisk:(NSString*)theName{
    NSArray *nameArray = [[NSArray alloc]initWithObjects:theName, nil];
    [nameArray writeToFile:[self operatorPropertyList] atomically:YES];
}

-(NSString*)operatorPropertyList{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kOperatorInformation];
}

-(void)transitionToNewInspections{
    NewInspectionsViewController *newInspectionVC = [[NewInspectionsViewController alloc]init];
    [self.navigationController pushViewController:newInspectionVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextField Delegate Methods

/*-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}*/


#pragma mark - AsyncResponse Delegate Methods

-(void)asyncResponseDidReturnObjects:(NSArray *)theObjects{
    if(theObjects){
        NSArray *technicianList = [[NSArray alloc]initWithArray:theObjects];
        
        NSLog(@"Returned objects are:\n%@", theObjects);

        if(pickerHelper){
            pickerHelper = nil;
        }
        pickerHelper = [[PickerViewHelper alloc]initWithDataSource:technicianList andPurpose:@"String"];
        pickerHelper.delegate = self;
        [pickerHelper displayPicker];
    }
}

-(void)asyncResponseDidFailWithError{
    NSLog(@"Error!");
}


#pragma mark - PickerViewHelper Delegate Methods

-(void)pickerDidPickData:(id)theData atIndex:(NSInteger)theIndex forPurpose:(NSString *)purpose{
    if(theData){
        NSLog(@"The name picked was: %@",theData);
        [self saveNameToDisk:theData];
        [self transitionToNewInspections];
    }
}

@end
