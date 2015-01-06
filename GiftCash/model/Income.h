//
//  Income.h
//  GiftCash
//
//  Created by 张雨红 on 15/1/6.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account, Event;

@interface Income : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *accounts;
@property (nonatomic, retain) Event *event;
@end

@interface Income (CoreDataGeneratedAccessors)

- (void)addAccountsObject:(Account *)value;
- (void)removeAccountsObject:(Account *)value;
- (void)addAccounts:(NSSet *)values;
- (void)removeAccounts:(NSSet *)values;

@end
