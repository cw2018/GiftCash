//
//  CommonUtils.h
//  GiftCash
//
//  Created by 张雨红 on 15/1/6.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtils : NSObject
+ (NSString *)mouthAndDayOfDate:(NSDate *)date;
+ (NSString *)fullStringFromDate:(NSDate *)date;
@end
