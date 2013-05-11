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
#import "NSData+HexString.h"
#import "CustomLoadingView.h"

#define kInspectionPropertyList @"guc_inspection.plist"

@interface PastInspectionsSummaryViewController()

@property(nonatomic)NSString *inspectionID;
@property(nonatomic)NSString *stationName;
@property(nonatomic)NSString *inspectionDate;
@property(nonatomic)IBOutlet UIWebView *theWebView;
@property(nonatomic)CustomLoadingView *customLoadingView;

@end


@implementation PastInspectionsSummaryViewController

@synthesize inspectionID;
@synthesize stationName;
@synthesize inspectionDate;
@synthesize theWebView;
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
    self.navigationItem.title = @"PDF";
    
    customLoadingView = [[CustomLoadingView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) andTitle:@"Loading..."];
    [self.view addSubview:customLoadingView];
    [customLoadingView beginLoading];
    
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
        //NSLog(@"Objects returned are:\n%@", theObjects);
        NSDictionary *dataDictionary = [theObjects objectAtIndex:0];
        NSString *dataString = [dataDictionary objectForKey:@"data"];
        NSData *pdfData = [[NSData alloc]initWithHexString:dataString];
        //NSLog(@"Data condensed is: %@", pdfData);
        [theWebView loadData:pdfData MIMEType:@"application/pdf" textEncodingName:nil baseURL:nil];
        // Above method loads a blurry PDF. Below is for rebuilding the document from scratch.
        // [self recreatePDFFromData:pdfData];
        [customLoadingView stopLoading];
    }
}

-(void)asyncResponseDidFailWithError{
    NSLog(@"Error!");
}


/*#pragma mark - PDF Rendering Methods  // --UN-COMMENT TO USE--

-(void)recreatePDFFromData:(NSData*)pdfData{
    CFDataRef myPDFData = (__bridge CFDataRef)pdfData;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(myPDFData);
    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithProvider(provider);
    NSInteger numberOfPages = CGPDFDocumentGetNumberOfPages(pdf);
    NSMutableArray *imageArray = [[NSMutableArray alloc]init];
    for(int i = 1; i < numberOfPages+1; i++){
        UIImage *anImage = [self imageFromPDF:pdf withPageNumber:i withScale:15.0];
        
        [imageArray addObject:anImage];
    }
    NSLog(@"Array contains %i images.", [imageArray count]);
    [self drawPDFFromImageArray:imageArray];
    NSString *filePath = [self inspectionPropertyList];
    NSData *pdfFileData;
    if(filePath){
        pdfFileData = [[NSData alloc]initWithContentsOfFile:filePath];
        [theWebView loadData:pdfFileData MIMEType:@"application/pdf" textEncodingName:nil baseURL:nil];
    }
    CFRelease(myPDFData);
}

-(UIImage*)imageFromPDF:(CGPDFDocumentRef)pdf withPageNumber:(NSUInteger)pageNumber withScale:(CGFloat)scale
{
	if(pageNumber > 0 && pageNumber < CGPDFDocumentGetNumberOfPages(pdf)+1)
	{
		CGPDFPageRef pdfPage = CGPDFDocumentGetPage(pdf,pageNumber);
		CGRect tmpRect = CGPDFPageGetBoxRect(pdfPage,kCGPDFMediaBox);
		CGRect rect = CGRectMake(tmpRect.origin.x,tmpRect.origin.y,tmpRect.size.width*scale,tmpRect.size.height*scale);
		UIGraphicsBeginImageContext(rect.size);
		CGContextRef context = UIGraphicsGetCurrentContext();
		CGContextTranslateCTM(context,0,rect.size.height);
		CGContextScaleCTM(context,scale,-scale);
		CGContextDrawPDFPage(context,pdfPage);
		UIImage* pdfImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		return pdfImage;
	}
	return nil;
}

-(void)drawPDFFromImageArray:(NSArray*)imageArray{
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile([self inspectionPropertyList], CGRectZero, nil);
    
    for(int i = 0; i < 5; i++){
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
        
        [[imageArray objectAtIndex:i] drawInRect:CGRectMake(0, 0, 612, 792)];
    }
    
    // End and save the PDF.
    UIGraphicsEndPDFContext();
}*/

@end
