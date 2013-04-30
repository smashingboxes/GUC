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
@property(nonatomic)NSInteger pdfPage;

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

// SwitchBoard Labels
@property(nonatomic)IBOutlet UILabel *maxAmpALabel;
@property(nonatomic)IBOutlet UILabel *maxAmpBLabel;
@property(nonatomic)IBOutlet UILabel *maxAmpCLabel;
@property(nonatomic)IBOutlet UILabel *presentAmpALabel;
@property(nonatomic)IBOutlet UILabel *presentAmpBLabel;
@property(nonatomic)IBOutlet UILabel *presentAmpCLabel;
@property(nonatomic)IBOutlet UILabel *minVoltsALabel;
@property(nonatomic)IBOutlet UILabel *minVoltsBLabel;
@property(nonatomic)IBOutlet UILabel *minVoltsCLabel;
@property(nonatomic)IBOutlet UILabel *presentVoltsALabel;
@property(nonatomic)IBOutlet UILabel *presentVoltsBLabel;
@property(nonatomic)IBOutlet UILabel *presentVoltsCLabel;
@property(nonatomic)IBOutlet UILabel *maxVoltsALabel;
@property(nonatomic)IBOutlet UILabel *maxVoltsBLabel;
@property(nonatomic)IBOutlet UILabel *maxVoltsCLabel;
@property(nonatomic)IBOutlet UITextView *targetsAndAlarmsView;

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
@synthesize pdfPage;

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

@synthesize maxAmpALabel;
@synthesize maxAmpBLabel;
@synthesize maxAmpCLabel;
@synthesize presentAmpALabel;
@synthesize presentAmpBLabel;
@synthesize presentAmpCLabel;
@synthesize minVoltsALabel;
@synthesize minVoltsBLabel;
@synthesize minVoltsCLabel;
@synthesize presentVoltsALabel;
@synthesize presentVoltsBLabel;
@synthesize presentVoltsCLabel;
@synthesize maxVoltsALabel;
@synthesize maxVoltsBLabel;
@synthesize maxVoltsCLabel;
@synthesize targetsAndAlarmsView;

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
    
    pdfPage = 0;
    
    [self addInspectionDataToLabels];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)addInspectionDataToLabels{
    if(currentInspection){
        NSString *notAvailable = @"N/A";
        
        if(currentInspection.generalSettings.stationName){
            stationNameLabel.text = currentInspection.generalSettings.stationName;
        }else{
            stationNameLabel.text = notAvailable;
        }
        if(currentInspection.generalSettings.dateTime){
            dateTimeLabel.text = currentInspection.generalSettings.dateTime;
        }else{
            dateTimeLabel.text = notAvailable;
        }
        if(currentInspection.generalSettings.technician){
            technicianLabel.text = currentInspection.generalSettings.technician;
        }else{
            technicianLabel.text = notAvailable;
        }
        if(currentInspection.generalSettings.kwh){
            kwhLabel.text = currentInspection.generalSettings.kwh;
        }else{
            kwhLabel.text = notAvailable;
        }
        if(currentInspection.generalSettings.mwd){
            mwdLabel.text = currentInspection.generalSettings.mwd;
        }else{
            mwdLabel.text = notAvailable;
        }
        if(currentInspection.generalSettings.positiveKVARH){
            plusKVARHLabel.text = currentInspection.generalSettings.positiveKVARH;
        }else{
            plusKVARHLabel.text = notAvailable;
        }
        if(currentInspection.generalSettings.negativeKVARH){
            minusKVARHLabel.text = currentInspection.generalSettings.negativeKVARH;
        }else{
            minusKVARHLabel.text = notAvailable;
        }
        if(currentInspection.generalSettings.maxVARD){
            maxVARDLabel.text = currentInspection.generalSettings.maxVARD;
        }else{
            maxVARDLabel.text = notAvailable;
        }
        if(currentInspection.generalSettings.minVARD){
            minVARDLabel.text = currentInspection.generalSettings.minVARD;
        }else{
            minVARDLabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.maxAmpA){
            maxAmpALabel.text = currentInspection.switchBoard.maxAmpA;
        }else{
            maxAmpALabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.maxAmpB){
            maxAmpBLabel.text = currentInspection.switchBoard.maxAmpB;
        }else{
            maxAmpBLabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.maxAmpC){
            maxAmpCLabel.text = currentInspection.switchBoard.maxAmpC;
        }else{
            maxAmpCLabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.presentAmpA){
            presentAmpALabel.text = currentInspection.switchBoard.presentAmpA;
        }else{
            presentAmpALabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.presentAmpB){
            presentAmpBLabel.text = currentInspection.switchBoard.presentAmpB;
        }else{
            presentAmpBLabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.presentAmpC){
            presentAmpCLabel.text = currentInspection.switchBoard.presentAmpC;
        }else{
            presentAmpCLabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.minVoltsA){
            minVoltsALabel.text = currentInspection.switchBoard.minVoltsA;
        }else{
            minVoltsALabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.minVoltsB){
            minVoltsBLabel.text = currentInspection.switchBoard.minVoltsB;
        }else{
            minVoltsBLabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.minVoltsC){
            minVoltsCLabel.text = currentInspection.switchBoard.minVoltsC;
        }else{
            minVoltsCLabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.presentVoltsA){
            presentVoltsALabel.text = currentInspection.switchBoard.presentVoltsA;
        }else{
            presentVoltsALabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.presentVoltsB){
            presentVoltsBLabel.text = currentInspection.switchBoard.presentVoltsB;
        }else{
            presentVoltsBLabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.presentVoltsC){
            presentVoltsCLabel.text = currentInspection.switchBoard.presentVoltsC;
        }else{
            presentVoltsCLabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.maxVoltsA){
            maxVoltsALabel.text = currentInspection.switchBoard.maxVoltsA;
        }else{
            maxVoltsALabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.maxVoltsB){
            maxVoltsBLabel.text = currentInspection.switchBoard.maxVoltsB;
        }else{
            maxVoltsBLabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.maxVoltsC){
            maxVoltsCLabel.text = currentInspection.switchBoard.maxVoltsC;
        }else{
            maxVoltsCLabel.text = notAvailable;
        }
        if(currentInspection.switchBoard.targetsAlarms){
            targetsAndAlarmsView.text = currentInspection.switchBoard.targetsAlarms;
        }else{
            targetsAndAlarmsView.text = notAvailable;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)pdfFilePathWithStation:(NSString*)station date:(NSString*)date andTechnician:(NSString*)technician{
    NSString *trimmedDate = [self trimString:date];
    
    NSString *theFileName = [[NSString alloc]initWithFormat:@"%@_%@_%@.pdf", station, trimmedDate, technician];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:theFileName];
}

-(NSString*)createPDFFileNameWithStation:(NSString*)station date:(NSString*)date andTechnician:(NSString*)technician{
    NSString *trimmedDate = [self trimString:date];
    
    NSString *theFileName = [[NSString alloc]initWithFormat:@"%@_%@_%@.pdf", station, trimmedDate, technician];
    NSLog(@"File name is: %@",theFileName);
    
    return theFileName;
}

-(NSString*)trimString:(NSString*)theString{
    NSString *trimmedString = [theString stringByReplacingOccurrencesOfString:@" " withString:@""];
    trimmedString = [trimmedString stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    return trimmedString;
}

-(void)changePage{
    switch(pdfPage){
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
    pdfPage += 1;
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
    UIGraphicsBeginPDFContextToFile([self pdfFilePathWithStation:currentInspection.generalSettings.stationName date:currentInspection.generalSettings.dateTime andTechnician:currentInspection.generalSettings.technician], CGRectZero, nil);
    
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
    NSString *pdfFilePath = [self pdfFilePathWithStation:currentInspection.generalSettings.stationName date:currentInspection.generalSettings.dateTime andTechnician:currentInspection.generalSettings.technician];
    
    NSData *pdfData = [[NSData alloc]initWithContentsOfFile:pdfFilePath];
    
    NSString *pdfFileName = [self createPDFFileNameWithStation:currentInspection.generalSettings.stationName date:currentInspection.generalSettings.dateTime andTechnician:currentInspection.generalSettings.technician];
    
    
    NSString *subjectString = [[NSString alloc]initWithFormat:@"%@ %@",currentInspection.generalSettings.stationName, currentInspection.generalSettings.dateTime];
    [mailComposer setSubject:subjectString];
    [mailComposer addAttachmentData:pdfData mimeType:@"application/pdf" fileName:pdfFileName];
    [self presentViewController:mailComposer animated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if(result == MFMailComposeResultSent){
        NSLog(@"Mail sent!");
    }else if(result == MFMailComposeResultFailed){
        NSLog(@"Mail failed to be sent.");
    }else if(result == MFMailComposeResultCancelled){
        NSLog(@"Mail cancelled");
    }
    [mailComposer dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
