//
//  IncomeAccountListTVC.h
//  GiftCash
//
//  Created by 张雨红 on 15/1/9.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Income.h"

@interface IncomeAccountListTVC : CoreDataTableViewController
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Income *income;
@end
