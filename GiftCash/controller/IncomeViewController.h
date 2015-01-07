//
//  IncomeViewController.h
//  GiftCash
//
//  Created by 张雨红 on 15/1/7.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Income.h"

@interface IncomeViewController : UIViewController
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Income *income;
@end
