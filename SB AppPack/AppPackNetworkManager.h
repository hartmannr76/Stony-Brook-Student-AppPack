//
//  AppPackNetworkManager.h
//  CoreDataDemo
//
//  Created by Richard Hartmann on 10/12/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppPackNetworker : NSObject
@property (nonatomic, assign, getter = isProcessCompleted, setter = setProcessCompleted:) BOOL processCompleted;
@property (nonatomic, copy, setter = setNetworkRunner:) void (^runnerCallback)(void);
@property (nonatomic, copy, setter = setUponCompletion:) void (^uponCompletion)(void);
@property (nonatomic, copy, getter = getCachedData, setter = setCachedData:) NSDictionary *cachedData;
// some of the searches can be performed from items saved into the users settings data, however some will need to be on the fly search criteria provided through this field
@property (nonatomic, copy, getter = getQueryData, setter = setQueryData:) NSMutableDictionary *queryData;
-(void)run;
@end

@interface AppPackNetworkManager : NSObject
@property (nonatomic, strong) AppPackNetworker *directoryRunner;
@property (nonatomic, strong) AppPackNetworker *directorySelectedRunner;
@property (nonatomic, strong) AppPackNetworker *directoryAddHoursRunner;
@property (nonatomic, strong) AppPackNetworker *accountsRunner;
@property (nonatomic, strong) AppPackNetworker *libraryRunner;
@property (nonatomic, strong) AppPackNetworker *recreationRunner;
@property (nonatomic, strong) AppPackNetworker *classesRunner;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
-(void) engageAccountsRunner;
@end
