//
//  NewInspectionsViewController.h
//  GUC
//
//  Created by Michael Brodeur on 4/8/13.
//  Copyright (c) 2013 SmashingBoxes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationHelper.h"
#import "MenuButtonHelper.h"

@interface NewInspectionsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,LocationHelperDelegate, MenuButtonHelperDelegate>

@end
