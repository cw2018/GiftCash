//
//  CommonUtils.m
//  GiftCash
//
//  Created by 张雨红 on 15/1/6.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import "CommonUtils.h"
#import <UIKit/UIKit.h>

@implementation CommonUtils
+ (NSString *)mouthAndDayOfDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM-dd";
    return [dateFormatter stringFromDate:date];
}

+(NSString *)yearFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy";
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)fullStringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)beginDateOfYear:(NSInteger)year
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [NSString stringWithFormat:@"%04ld-01-01 00:00:00", year];
    return [dateFormatter dateFromString:dateString];
}

+ (NSDate *)endDateOfYear:(NSInteger)year
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString = [NSString stringWithFormat:@"%04ld-12-31 23:59:59", year];
    return [dateFormatter dateFromString:dateString];
}

+ (void)defaultAlertView:(NSString *)title message:(NSString *)msg
{
    [[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
}
@end
