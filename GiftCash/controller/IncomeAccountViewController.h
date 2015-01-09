//
//  IncomeAccountViewController.h
//  GiftCash
//
//  Created by 张雨红 on 15/1/9.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"
#import "Income.h"

@interface IncomeAccountViewController : UIViewController
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Account *account;
@property (strong, nonatomic) Income *income;
@end
