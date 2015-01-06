//
//  Event.h
//  GiftCash
//
//  Created by 张雨红 on 15/1/6.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account, Income;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *accounts;
@property (nonatomic, retain) NSSet *incomes;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addAccountsObject:(Account *)value;
- (void)removeAccountsObject:(Account *)value;
- (void)addAccounts:(NSSet *)values;
- (void)removeAccounts:(NSSet *)values;

- (void)addIncomesObject:(Income *)value;
- (void)removeIncomesObject:(Income *)value;
- (void)addIncomes:(NSSet *)values;
- (void)removeIncomes:(NSSet *)values;

@end
