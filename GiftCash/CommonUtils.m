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

+ (NSString *)fullStringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    return [dateFormatter stringFromDate:date];
}

+ (void)defaultAlertView:(NSString *)title message:(NSString *)msg
{
    [[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
}
@end
