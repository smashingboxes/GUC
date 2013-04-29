//
//  RenderPDFViewController.m
//  GUC
//
//  Created by Michael Brodeur on 4/23/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "RenderPDFViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RenderPDFViewController ()

@property(nonatomic)Inspection *currentInspection;
@property(nonatomic)MFMailComposeViewController *mailComposer;
@property(nonatomic)NSMutableArray *imageArray;
@property(nonatomic)NSInteger currentPage;

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
@property(nonatomic)IBOutlet UIView *firstPage;
@property(nonatomic)IBOutlet UIView *secondPage;
@property(nonatomic)IBOutlet UIView *thirdPage;
@property(nonatomic)IBOutlet UIView *fourthPage;
@property(nonatomic)IBOutlet UIView *fifthPage;


@end

@implementation RenderPDFViewController

@synthesize currentInspection;
@synthesize mailComposer;
@synthesize imageArray;
@synthesize currentPage;

@synthesize stationNameLabel;
@synthesize dateTimeLabel;
@synthesize technicianLabel;

@synthesize kwhLabel;
@synthesize mwdLabel;
@synthesize plusKVARHLabel;
@synthesize minusKVARHLabel;
@synthesize maxVARDLabel;
@synthesize minVARDLabel;

@synthesize firstPage;
@synthesize secondPage;
@synthesize thirdPage;
@synthesize fourthPage;
@synthesize fifthPage;

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
    if(!mailComposer){
        mailComposer = [[MFMailComposeViewController alloc]init];
        mailComposer.mailComposeDelegate = self;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Next Page"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:self
                                                                            action:@selector(changePage)];
    
    imageArray = [[NSMutableArray alloc]init];
    
    currentPage = 0;
    
    [self addInspectionDataToLabels];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)addInspectionDataToLabels{
    if(currentInspection){
        if(currentInspection.generalSettings.stationName){
            stationNameLabel.text = currentInspection.generalSettings.stationName;
        }else{
            stationNameLabel.text = @"N/A";
        }
        if(currentInspection.generalSettings.dateTime){
            dateTimeLabel.text = currentInspection.generalSettings.dateTime;
        }else{
            dateTimeLabel.text = @"N/A";
        }
        if(currentInspection.generalSettings.technician){
            technicianLabel.text = currentInspection.generalSettings.technician;
        }else{
            technicianLabel.text = @"N/A";
        }
        if(currentInspection.generalSettings.kwh){
            kwhLabel.text = currentInspection.generalSettings.kwh;
        }else{
            kwhLabel.text = @"N/A";
        }
        if(currentInspection.generalSettings.mwd){
            mwdLabel.text = currentInspection.generalSettings.mwd;
        }else{
            mwdLabel.text = @"N/A";
        }
        if(currentInspection.generalSettings.positiveKVARH){
            plusKVARHLabel.text = currentInspection.generalSettings.positiveKVARH;
        }else{
            plusKVARHLabel.text = @"N/A";
        }
        if(currentInspection.generalSettings.negativeKVARH){
            minusKVARHLabel.text = currentInspection.generalSettings.negativeKVARH;
        }else{
            minusKVARHLabel.text = @"N/A";
        }
        if(currentInspection.generalSettings.maxVARD){
            maxVARDLabel.text = currentInspection.generalSettings.maxVARD;
        }else{
            maxVARDLabel.text = @"N/A";
        }
        if(currentInspection.generalSettings.minVARD){
            minVARDLabel.text = currentInspection.generalSettings.minVARD;
        }else{
            minVARDLabel.text = @"N/A";
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)pdfFilePathWithName:(NSString*)name date:(NSString*)date andTechnician:(NSString*)technician{
    NSString *trimmedDate = [date stringByReplacingOccurrencesOfString:@" " withString:@""];
    trimmedDate = [trimmedDate stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSString *theFileName = [[NSString alloc]initWithFormat:@"%@_%@_%@.pdf", name, trimmedDate, technician];
    NSLog(@"File name is: %@",theFileName);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:theFileName];
}

-(void)changePage{
    switch(currentPage){
        case 0:
            [self captureScreen];
            [self makeViewVanish:firstPage];
            break;
        case 1:
            [self captureScreen];
            [self makeViewVanish:secondPage];
            break;
        case 2:
            [self captureScreen];
            [self makeViewVanish:thirdPage];
            break;
        case 3:
            [self captureScreen];
            [self makeViewVanish:fourthPage];
            [self.navigationItem.rightBarButtonItem setTitle:@"Finish"];
            break;
        case 4:
            [self captureScreen];
            [self makeViewVanish:fifthPage];
            [self drawPDF];
            break;
        default:
            break;
    }
    currentPage += 1;
}

-(void)makeViewVanish:(UIView*)aView{
    [UIView animateWithDuration:0.5 animations:^{
        aView.alpha = 0.0;
    }];
}


#pragma mark - PDF Drawing Methods

-(void)captureScreen{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [imageArray addObject:image];
}

-(void)drawPDF{
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile([self pdfFilePathWithName:currentInspection.generalSettings.stationName date:currentInspection.generalSettings.dateTime andTechnician:currentInspection.generalSettings.technician], CGRectZero, nil);
    
    for(int i = 0; i < 5; i++){
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
        
        [[imageArray objectAtIndex:i] drawInRect:CGRectMake(0, 0, 612, 792)];
    }
    
    // End and save the PDF.
    UIGraphicsEndPDFContext();
    
    [self displayMailComposer];
}


#pragma mark - MailPicker Methods

-(void)displayMailComposer{
    NSString *pdfFileName = [self pdfFilePathWithName:currentInspection.generalSettings.stationName date:currentInspection.generalSettings.dateTime andTechnician:currentInspection.generalSettings.technician];
    
    NSData *pdfData = [[NSData alloc]initWithContentsOfFile:pdfFileName];
    
    [mailComposer addAttachmentData:pdfData mimeType:@"application/pdf" fileName:pdfFileName];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if(result == MFMailComposeResultSent){
        NSLog(@"Mail sent!");
    }else if(result == MFMailComposeResultFailed){
        NSLog(@"Mail failed to be sent.");
    }
    [mailComposer dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
