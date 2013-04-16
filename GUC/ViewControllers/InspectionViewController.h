//
//  InspectionViewController.h
//  GUC
//
//  Created by Michael Brodeur on 4/8/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InspectionCellHeaderView.h"

@interface InspectionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, InspectionCellHeaderViewDelegate>

-(id)initWithTitle:(NSString*)title;

@end
