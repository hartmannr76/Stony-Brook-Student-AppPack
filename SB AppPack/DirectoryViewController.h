//
//  DirectoryViewController.h
//  SB AppPack
//
//  Created by Richard Hartmann on 10/19/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppPackNetworkManager.h"

@interface DirectoryViewController : UIViewController<UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) AppPackNetworkManager *sharedNetorkManager;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *directorySearchBar;
@end
