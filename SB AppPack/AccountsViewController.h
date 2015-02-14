//
//  AccountsViewController.h
//  SB AppPack
//
//  Created by Richard Hartmann on 10/19/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppPackNetworkManager.h"
#import "CustomAccountCell.h"

@interface AccountsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) AppPackNetworkManager *sharedNetorkManager;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) CustomAccountCell *selectedCell;
@end
