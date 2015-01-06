//
//  Account.h
//  GiftCash
//
//  Created by 张雨红 on 15/1/6.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Contact, Event, Income;

@interface Account : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * money;
@property (nonatomic, retain) NSNumber * outgo;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) Contact *contact;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) Income *income;

@end
