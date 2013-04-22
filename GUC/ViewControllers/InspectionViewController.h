//
//  InspectionViewController.h
//  GUC
//
//  Created by Michael Brodeur on 4/8/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InspectionCellHeaderView.h"
#import "AsyncRequest.h"

@interface InspectionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, InspectionCellHeaderViewDelegate, AsyncResponseDelegate>

-(id)initWithStation:(NSString*)station;

@end
