//
//  RenderPDFViewController.h
//  GUC
//
//  Created by Michael Brodeur on 4/23/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Inspection.h"


@interface RenderPDFViewController : UIViewController <MFMailComposeViewControllerDelegate>

-(id)initWithInspection:(Inspection*)theInspection;

@end
