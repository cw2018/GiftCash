//
//  OutgoAccountViewController.h
//  GiftCash
//
//  Created by 张雨红 on 15/1/6.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Account.h"

@interface OutgoAccountViewController : UIViewController
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Account *account;
@end
