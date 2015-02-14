//
//  AppDelegate.h
//  SB AppPack
//
//  Created by Richard Hartmann on 10/19/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppPackNetworkManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// Object context variables
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

// Network Manager
@property (readonly, strong, nonatomic) AppPackNetworkManager *sharedNetworkManager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
