//
//  PastInspectionsSummaryViewController.m
//  GUC
//
//  Created by Michael Brodeur on 4/8/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import "PastInspectionsSummaryViewController.h"
#import "NetworkConnectionManager.h"
#import <QuartzCore/QuartzCore.h>

#define kInspectionPropertyList @"guc_inspection.plist"

@interface PastInspectionsSummaryViewController()

@property(nonatomic)NSString *inspectionID;
@property(nonatomic)NSString *stationName;
@property(nonatomic)NSString *inspectionDate;
@property(nonatomic)IBOutlet UIWebView *theWebView;
@property(nonatomic)CGPDFDocumentRef pdf;
@property(nonatomic)NSInteger currentPage;

@end


@implementation PastInspectionsSummaryViewController

@synthesize inspectionID;
@synthesize stationName;
@synthesize inspectionDate;
@synthesize theWebView;
@synthesize pdf;
@synthesize currentPage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*-(id)initWithInspectionId:(NSString *)theInspectionID stationName:(NSString *)theStationName andDate:(NSString *)theDate{
    if(self == [super init]){
        inspectionID = theInspectionID;
        stationName = theStationName;
        inspectionDate = theDate;
    }
    
    return self;
}*/

- (void)viewDidLoad
{
    [self loadPDF];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)loadPDF{
    NSString *inspectionSring = [self inspectionPropertyList];
    
    if(inspectionSring){
        NSArray *inspectionArray = [[NSArray alloc]initWithContentsOfFile:inspectionSring];
        
        inspectionID = [inspectionArray objectAtIndex:0];
        stationName = [inspectionArray objectAtIndex:1];
        inspectionDate = [inspectionArray objectAtIndex:2];
        
        NSDictionary *dataDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:inspectionID, @"inspection_id", stationName, @"station_name", inspectionDate, @"date", nil];
    
        [[NetworkConnectionManager sharedManager]beginConnectionWithPurpose:@"PDF" withParameters:dataDictionary withJSONDictionary:nil forCaller:self];
    }
}

-(NSString*)inspectionPropertyList{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kInspectionPropertyList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - AsyncResponse Delegate Methods

-(void)asyncResponseDidReturnObjects:(NSArray *)theObjects{
    if(theObjects){
        NSLog(@"Objects returned are:\n%@", theObjects);
        NSDictionary *dataDictionary = [theObjects objectAtIndex:0];
        //NSString *pdfDataString = [[NSString alloc]initWithFormat:@"%@", [dataDictionary objectForKey:@"data"]];
        NSData *pdfData = [[NSData alloc]initWithBytes:[[dataDictionary objectForKey:@"data"] bytes] length:[[dataDictionary objectForKey:@"data"]length]];
        NSArray *imageArray = [NSKeyedUnarchiver unarchiveObjectWithData:pdfData];
        NSLog(@"The array contains %i pages.", [imageArray count]);
        //[theWebView loadData:pdfData MIMEType:@"application/pdf" textEncodingName:nil baseURL:nil];
        //theWebView.hidden = YES;
        //UIGraphicsBeginPDFContextToFile(@"temp_file.pdf", , <#NSDictionary *documentInfo#>)
        //CFDataRef myPDFData = (__bridge CFDataRef)pdfData;
        //CGDataProviderRef provider = CGDataProviderCreateWithCFData(myPDFData);
        //pdf = CGPDFDocumentCreateWithProvider(provider);
        //CFRelease(myPDFData);
        //currentPage = 1;
        //[self drawRect:self.view.bounds];
    }
}

-(void)asyncResponseDidFailWithError{
    NSLog(@"Error!");
}


#pragma mark - PDF Drawing Methods

-(void)drawRect:(CGRect)inRect{
    if(pdf){
        CGPDFPageRef page = CGPDFDocumentGetPage(pdf, currentPage);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        //CGContextSaveGState(ctx);
        //CGContextTranslateCTM(ctx, 0.0, self.view.bounds.size.height);
        //CGContextScaleCTM(ctx, 1.0, -1.0);
        //CGContextConcatCTM(ctx, CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, self.view.bounds, 0, true));
        CGContextDrawPDFPage(ctx, page);
        //CGContextRestoreGState(ctx);
    }
}

@end
