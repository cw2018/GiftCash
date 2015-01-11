//
//  ContactViewController.h
//  GiftCash
//
//  Created by 张雨红 on 15/1/9.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact+WithUniqueName.h"

@interface ContactViewController : UIViewController
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Contact *contact;
@end
