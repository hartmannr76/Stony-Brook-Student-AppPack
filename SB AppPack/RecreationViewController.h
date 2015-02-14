//
//  RecreationViewController.h
//  SB AppPack
//
//  Created by Richard Hartmann on 11/5/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppPackNetworkManager.h"

@interface RecreationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) AppPackNetworkManager *sharedNetorkManager;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@end
