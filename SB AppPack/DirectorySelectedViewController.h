//
//  DirectorySelectedViewController.h
//  SB AppPack
//
//  Created by Richard Hartmann on 11/29/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppPackNetworkManager.h"

@interface DirectorySelectedViewController : UIViewController
@property (strong, nonatomic) id detailItem;
@property (nonatomic, strong) AppPackNetworkManager *sharedNetorkManager;
@property (nonatomic, strong) NSString *selectedName;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITableView *officeHoursTable;
@end
