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
#define kOperatorInformation @"guc_operator.plist"

@interface MainViewController ()

@property(nonatomic)IBOutlet UITextField *nameField;

-(IBAction)loginButtonPressed:(id)sender;

@end

@implementation MainViewController

@synthesize nameField;

- (void)viewDidLoad
{
    self.navigationItem.title = @"Welcome!";
    
    [NavigationBarHelper setBackButtonTitle:@"Back" forViewController:self];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

-(IBAction)loginButtonPressed:(id)sender{
    if([nameField.text length] > 0){
        [self saveNameToDisk];
        NewInspectionsViewController *newInspectionVC = [[NewInspectionsViewController alloc]init];
        [self.navigationController pushViewController:newInspectionVC animated:YES];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"No Name"
                                                           message:@"Please enter your name to continue."
                                                          delegate:self
                                                 cancelButtonTitle:@"Okay"
                                                 otherButtonTitles:nil];
        [alertView show];
    }
}

-(void)saveNameToDisk{
    NSArray *nameArray = [[NSArray alloc]initWithObjects:nameField.text, nil];
    [nameArray writeToFile:[self operatorPropertyList] atomically:YES];
}

-(NSString*)operatorPropertyList{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kOperatorInformation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

@end
