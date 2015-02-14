//
//  AccountsEntity.h
//  SB AppPack
//
//  Created by Richard Hartmann on 10/20/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AccountsEntity : NSManagedObject

@property (nonatomic, retain) NSNumber * bookstorePoints;
@property (nonatomic, retain) NSNumber * wolfieWallet;
@property (nonatomic, retain) NSNumber * flexPoints;
@property (nonatomic, retain) NSNumber * mealPoints;
@property (nonatomic, retain) NSString * received;

@end
