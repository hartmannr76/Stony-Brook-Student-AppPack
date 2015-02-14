//
//  AppPackNetworkManager.m
//  CoreDataDemo
//
//  Created by Richard Hartmann on 10/12/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import "AppPackNetworkManager.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "AccountsEntity.h"
#import "ScheduleEntity.h"

#import "XMLParser.h"

@implementation AppPackNetworker

@synthesize processCompleted, cachedData, queryData;

// custom initialization to set processCompleted to true
-(id)init
{
    if (self = [super init])  {
        self.processCompleted = YES;
    }
    return self;}

-(void)run
{
    [self setProcessCompleted:false];
    self.runnerCallback();
}

@end

@implementation AppPackNetworkManager
@synthesize directoryRunner, accountsRunner, recreationRunner, classesRunner, libraryRunner, managedObjectContext, directorySelectedRunner, directoryAddHoursRunner;

-(id)init
{
    if(managedObjectContext == nil)
    {
        managedObjectContext = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    [self setManagedObjectContext:managedObjectContext];
    
    directoryRunner = [[AppPackNetworker alloc] init];
    [directoryRunner setQueryData: [[NSMutableDictionary alloc] init]];
    directorySelectedRunner = [[AppPackNetworker alloc] init];
    [directorySelectedRunner setQueryData: [[NSMutableDictionary alloc] init]];
    accountsRunner = [[AppPackNetworker alloc] init];
    recreationRunner = [[AppPackNetworker alloc] init];
    classesRunner = [[AppPackNetworker alloc] init];
    libraryRunner = [[AppPackNetworker alloc] init];
    
    __weak AppPackNetworkManager *inSelf = self;
    
    // set directory run method
    [directoryRunner setNetworkRunner:^(void) {
        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@", @"http://localhost:8888/searchPeople.php?search=",inSelf.directoryRunner.queryData[@"search"]]];
        NSURLRequest *urlrequest = [[NSURLRequest alloc] initWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
         
            inSelf.directoryRunner.cachedData = responseObject;
         
            [inSelf.directoryRunner setProcessCompleted:YES];
            
            // this will only be not nil if we are in a view, this way it can change the refresh button upon completion of the task
            if(inSelf.directoryRunner.uponCompletion != nil)
            {
                inSelf.directoryRunner.uponCompletion();
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@",  operation.responseString);
            [inSelf.directoryRunner setProcessCompleted:true];
        }];
        
        [operation start];
         
        /*NSArray *tempArrayData = @[@"Person 1", @"Person 2", @"Person 3", @"Person 4"];
        NSArray *dataHolder = @[tempArrayData];
        NSArray *keys = @[@"people"];
        
        NSMutableDictionary *tempData = [[NSMutableDictionary alloc] initWithObjects:dataHolder forKeys:keys];
        
        inSelf.directoryRunner.cachedData = tempData;
        
        [inSelf.directoryRunner setProcessCompleted:YES];
        if(inSelf.directoryRunner.uponCompletion != nil)
        {
            inSelf.directoryRunner.uponCompletion();
        }*/
        
    }];
    
    [directorySelectedRunner setNetworkRunner:^(void) {
        NSArray* nameSeparated = [inSelf.directorySelectedRunner.queryData[@"search"] componentsSeparatedByString: @" "];
        
        NSString *uriBeforeEncode = [NSString stringWithFormat:@"%@%@ %@", @"http://localhost:8888/getSelectedPerson.php?search=",[nameSeparated objectAtIndex:0], [nameSeparated objectAtIndex:2]];
        
        NSURL *url = [NSURL URLWithString:[uriBeforeEncode stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        
        NSURLRequest *urlrequest = [[NSURLRequest alloc] initWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            inSelf.directorySelectedRunner.cachedData = responseObject;
            
            [inSelf.directorySelectedRunner setProcessCompleted:YES];
            
            // this will only be not nil if we are in a view, this way it can change the refresh button upon completion of the task
            if(inSelf.directorySelectedRunner.uponCompletion != nil)
            {
                inSelf.directorySelectedRunner.uponCompletion();
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@",  operation.responseString);
            [inSelf.directorySelectedRunner setProcessCompleted:true];
        }];
        
        [operation start];
         
        
        /********************** TEMP DATA **************************/
        /*
        NSArray *tempArrayData = @[@"something@aol.com", @"comp sci", @"123-456-7890"];
        NSArray *keys = @[@"email", @"department", @"phone"];
        
        NSMutableDictionary *tempData = [[NSMutableDictionary alloc] initWithObjects:tempArrayData forKeys:keys];
        
        inSelf.directorySelectedRunner.cachedData = tempData;
        
        [inSelf.directorySelectedRunner setProcessCompleted:YES];
        if(inSelf.directorySelectedRunner.uponCompletion != nil)
        {
            inSelf.directorySelectedRunner.uponCompletion();
        }
*/
        
    }];
    
    [directoryAddHoursRunner setNetworkRunner:^(void){
        NSString *uriBeforeEncode = [NSString stringWithFormat:@"%@", @"http://localhost:8888/getSelectedPerson.php"];
        
        NSURL *url = [NSURL URLWithString:[uriBeforeEncode stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        
        NSMutableURLRequest *urlrequest = [[NSURLRequest alloc] initWithURL:url];
        
        NSString* postData = [NSString stringWithFormat:@"professorName=%@&professorEmail=%@&recommendedDayOfWeek=%@&recommendedStartTime=%@&recommendedEndTime=%@", inSelf.directoryAddHoursRunner.queryData[@"name"], inSelf.directoryAddHoursRunner.queryData[@"email"], inSelf.directoryAddHoursRunner.queryData[@"dayOfWeek"], inSelf.directoryAddHoursRunner.queryData[@"start"], inSelf.directoryAddHoursRunner.queryData[@"end"]];
        [urlrequest setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            //inSelf.directorySelectedRunner.cachedData = responseObject;
            
            [inSelf.directorySelectedRunner setProcessCompleted:YES];
            
            // this will only be not nil if we are in a view, this way it can change the refresh button upon completion of the task
            if(inSelf.directorySelectedRunner.uponCompletion != nil)
            {
                inSelf.directorySelectedRunner.uponCompletion();
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@",  operation.responseString);
            [inSelf.directorySelectedRunner setProcessCompleted:true];
        }];
        
        [operation start];

    }];
    
    // set library run method
    /*[libraryRunner setNetworkRunner:^(void) {
        NSURL *url = [[NSURL alloc] initWithString:@"http://sbufind.library.stonybrook.edu/vufind/Search/Results?lookfor=long&type=AllFields&view=rss"];
        NSURLRequest *urlrequest = [[NSURLRequest alloc] initWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            //inSelf.recreationRunner.cachedData = (NSDictionary *)responseObject;
            // create and init NSXMLParser object
            NSXMLParser *nsXmlParser = [[NSXMLParser alloc] initWithData:responseObject];
            
            // create and init our delegate
            XMLParser *parser = [[XMLParser alloc] initXMLParser];
            
            // set delegate
            [nsXmlParser setDelegate:parser];
            
            // parsing...
            BOOL success = [nsXmlParser parse];
            
            // test the result
            if (success) {
                NSLog(@"No errors - user count : %i", [parser.books count]);
                // get array of users here
                //  NSMutableArray *users = [parser users];
            } else {
                NSLog(@"Error parsing document!");
            }
            
            [inSelf.libraryRunner setProcessCompleted:YES];
            
            // this will only be not nil if we are in a view, this way it can change the refresh button upon completion of the task
            if(inSelf.libraryRunner.uponCompletion != nil)
            {
                inSelf.libraryRunner.uponCompletion();
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@",  operation.responseString);
            [inSelf.accountsRunner setProcessCompleted:true];
        }];
        
        [operation start];
    }];*/
    
    // set accounts run method
    [accountsRunner setNetworkRunner:^(void) {
        // calling first external url
        NSURL *url = [[NSURL alloc] initWithString:@"http://localhost:8888/curl_test.php?sid=107603399&cdpass=sosh922"];
        NSURLRequest *urlrequest = [[NSURLRequest alloc] initWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
        
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *wallet =[responseObject objectForKey:@"wallet"];
            NSString *bookstore =[responseObject objectForKey:@"bookstore"];
            NSString *flex =[responseObject objectForKey:@"flex"];
            NSString *campus =[responseObject objectForKey:@"campus"];
            NSString *received =[responseObject objectForKey:@"received"];
            NSLog(@"%@", responseObject);
            NSError *saveError;
            
            // check to see if we have the existing row to update
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"AccountsEntity" inManagedObjectContext:inSelf.managedObjectContext];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entity];
            NSError *error;
            NSMutableArray *mutableFetchResults = [[inSelf.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
            
            // we have the row and we just need to update it
            if(mutableFetchResults.count > 0)
            {
                // found entity
                AccountsEntity* selectedEntity = (AccountsEntity *)[mutableFetchResults objectAtIndex:0];
                NSLog(@"Found value: %@", selectedEntity.received);
                NSLog(@"New value: %@", received);
                [selectedEntity setWolfieWallet: [[NSNumber alloc] initWithDouble: wallet == (id)[NSNull null] ? 0.0 : [wallet doubleValue]]];
                [selectedEntity setBookstorePoints: [[NSNumber alloc] initWithDouble: bookstore == (id)[NSNull null] ? 0.0 : [bookstore doubleValue]]];
                [selectedEntity setFlexPoints: [[NSNumber alloc] initWithDouble: flex == (id)[NSNull null] ? 0.0 : [flex doubleValue]]];
                [selectedEntity setMealPoints: [[NSNumber alloc] initWithDouble: campus == (id)[NSNull null] ? 0.0 : [campus doubleValue]]];
                [selectedEntity setReceived:received];
                if(![inSelf.managedObjectContext save:&saveError]){
                    //This is a serious error saying the record
                    //could not be saved. Advise the user to
                    //try again or restart the application.
                }
            }
            else    // we need to create the initial(only) row
            {
                NSLog(@"Inserting value: %@", received);
                AccountsEntity *event = (AccountsEntity *)[NSEntityDescription insertNewObjectForEntityForName:@"AccountsEntity" inManagedObjectContext:inSelf.managedObjectContext];
                [event setWolfieWallet: [[NSNumber alloc] initWithDouble: wallet == (id)[NSNull null] ? 0.0 : [wallet doubleValue]]];
                [event setBookstorePoints: [[NSNumber alloc] initWithDouble: bookstore == (id)[NSNull null] ? 0.0 : [bookstore doubleValue]]];
                [event setFlexPoints: [[NSNumber alloc] initWithDouble: flex == (id)[NSNull null] ? 0.0 : [flex doubleValue]]];
                [event setMealPoints: [[NSNumber alloc] initWithDouble: campus == (id)[NSNull null] ? 0.0 : [campus doubleValue]]];
                [event setReceived:received];
                if(![inSelf.managedObjectContext save:&saveError]){
                    //This is a serious error saying the record
                    //could not be saved. Advise the user to
                    //try again or restart the application.
                }
            }
            
            [inSelf.accountsRunner setProcessCompleted:true];
            
            // this will only be not nil if we are in a view, this way it can change the refresh button upon completion of the task
            if(inSelf.accountsRunner.uponCompletion != nil)
            {
                inSelf.accountsRunner.uponCompletion();
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@",  operation.responseString);
            [inSelf.accountsRunner setProcessCompleted:true];
        }];
        [operation start];
    }];
    
    // set recreation run method
    [recreationRunner setNetworkRunner:^(void) {
        NSURL *url = [[NSURL alloc] initWithString:@"http://localhost:8888/CI/api/newest"];
        NSURLRequest *urlrequest = [[NSURLRequest alloc] initWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            inSelf.recreationRunner.cachedData = (NSDictionary *)responseObject;
            [inSelf.recreationRunner setProcessCompleted:YES];
            
            // this will only be not nil if we are in a view, this way it can change the refresh button upon completion of the task
            if(inSelf.recreationRunner.uponCompletion != nil)
            {
                inSelf.recreationRunner.uponCompletion();
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@",  operation.responseString);
            [inSelf.accountsRunner setProcessCompleted:true];
        }];
        
        [operation start];
    }];
    
    // set classes run method
    [classesRunner setNetworkRunner:^(void) {
        // calling first external url
        NSURL *url = [[NSURL alloc] initWithString:@"http://localhost:8888/getSchedule.php?id=107603399&upass=sosh922"];
        NSURLRequest *urlrequest = [[NSURLRequest alloc] initWithURL:url];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlrequest];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *classes =[responseObject objectForKey:@"classes"];
            NSMutableDictionary *classesToStore = [[NSMutableDictionary alloc] init];
            
            // remove all objects in the current context on this refresh
            // check to see if we have the existing row to update
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"ScheduleEntity" inManagedObjectContext:inSelf.managedObjectContext];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entity];
            NSError *error;
            NSMutableArray *mutableFetchResults = [[inSelf.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
            NSError *saveError = nil;
            
            // if we have results, we need to delete them all
            if(mutableFetchResults.count > 0)
            {
                // found entity
                //ScheduleEntity* selectedEntity = (ScheduleEntity *)[mutableFetchResults objectAtIndex:0];
                for (NSManagedObject * class in mutableFetchResults) {
                    [inSelf.managedObjectContext deleteObject:class];
                }
                
                if(![inSelf.managedObjectContext save:&saveError]){
                    //This is a serious error saying the record
                    //could not be saved. Advise the user to
                    //try again or restart the application.
                }
            }
            
            // if we don't we can just go to the next step
            
            // add the fetched ones back in
            for(int i = 0; i < classes.count; i++)
            {
                NSDictionary *itemAtInArray = [classes objectAtIndex:i];
                NSDictionary *itemAtInClasses = [classesToStore objectForKey:[itemAtInArray objectForKey:@"name"]];
                if(itemAtInClasses != nil)
                {
                    // the class already exists and we need to expand on it
                    NSNumber *newDate = [itemAtInArray objectForKey:@"day"];
                    NSString *classDates = [itemAtInClasses objectForKey:@"day"];
                    if([newDate intValue] == 1)
                    {
                        classDates = [NSString stringWithFormat:@"%@, %@", classDates, @"Mon"];
                    }
                    else if([newDate intValue] == 2)
                    {
                        classDates = [NSString stringWithFormat:@"%@, %@", classDates, @"Tue"];
                    }
                    else if([newDate intValue] == 3)
                    {
                        classDates = [NSString stringWithFormat:@"%@, %@", classDates, @"Wed"];
                    }
                    else if([newDate intValue] == 4)
                    {
                        classDates = [NSString stringWithFormat:@"%@, %@", classDates, @"Thur"];
                    }
                    else if([newDate intValue] == 5)
                    {
                        classDates = [NSString stringWithFormat:@"%@, %@", classDates, @"Fri"];
                    }
                    
                    [itemAtInClasses setValue:classDates forKey:@"day"];
                }
                else
                {
                    NSMutableDictionary *classToAdd = [[NSMutableDictionary alloc] initWithCapacity:5];
                    NSString *received = [responseObject objectForKey:@"received"];
                    NSString *name = [itemAtInArray objectForKey:@"name"];
                    NSString *time = [itemAtInArray objectForKey:@"time"];
                    NSString *day = NULL;
                    //NSString *type = [itemAtInArray objectForKey:@"type"];
                    NSString *location = [itemAtInArray objectForKey:@"location"];
                    
                    // we dont have this in the list of items to add yet so we need to add it
                    NSNumber *newDate = [itemAtInArray objectForKey:@"day"];
                    if([newDate intValue] == 1)
                    {
                        day = [NSString stringWithFormat:@"%@", @"Mon"];
                    }
                    else if([newDate intValue] == 2)
                    {
                        day = [NSString stringWithFormat:@"%@", @"Tue"];
                    }
                    else if([newDate intValue] == 3)
                    {
                        day = [NSString stringWithFormat:@"%@", @"Wed"];
                    }
                    else if([newDate intValue] == 4)
                    {
                        day = [NSString stringWithFormat:@"%@", @"Thur"];
                    }
                    else
                    {
                        day = [NSString stringWithFormat:@"%@", @"Fri"];
                    }
                    
                    [classToAdd setObject:received forKey:@"received"];
                    [classToAdd setObject:name forKey:@"name"];
                    [classToAdd setObject:location forKey:@"location"];
                    [classToAdd setObject:time forKey:@"time"];
                    [classToAdd setObject:day forKey:@"day"];
                    
                    [classesToStore setObject:classToAdd forKey:name];
                }
            }
            
            // now that we have our full list of classes to actually store, we will want to store them
            for(NSString *classesName in classesToStore)
            {
                NSDictionary *class = [classesToStore objectForKey:classesName];
                ScheduleEntity *seClass = (ScheduleEntity *)[NSEntityDescription insertNewObjectForEntityForName:@"ScheduleEntity" inManagedObjectContext:inSelf.managedObjectContext];
                [seClass setClassDates:[class objectForKey:@"day"]];
                [seClass setClassLocation:[class objectForKey:@"location"]];
                [seClass setClassNameSection:[class objectForKey:@"name"]];
                [seClass setClassTimes:[class objectForKey:@"time"]];
                [seClass setReceived:[class objectForKey:@"received"]];
                if(![inSelf.managedObjectContext save:&saveError]){
                    //This is a serious error saying the record
                    //could not be saved. Advise the user to
                    //try again or restart the application.
                }
            }
            
            [inSelf.classesRunner setProcessCompleted:true];
            
            // this will only be not nil if we are in a view, this way it can change the refresh button upon completion of the task
            if(inSelf.classesRunner.uponCompletion != nil)
            {
                inSelf.classesRunner.uponCompletion();
            }

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@",  operation.responseString);
            [inSelf.accountsRunner setProcessCompleted:true];
        }];
        
        [operation start];
    }];
     
    return self;
}

-(void)engageAccountsRunner {
    [self.accountsRunner run];
}
@end
