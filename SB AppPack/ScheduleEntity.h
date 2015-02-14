//
//  ScheduleEntity.h
//  SB AppPack
//
//  Created by Richard Hartmann on 11/3/13.
//  Copyright (c) 2013 Richard Hartmann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ScheduleEntity : NSManagedObject

@property (nonatomic, retain) NSString * classNameSection;
@property (nonatomic, retain) NSString * classLocation;
@property (nonatomic, retain) NSString * classTimes;
@property (nonatomic, retain) NSString * classDates;
@property (nonatomic, retain) NSString * received;

@end
