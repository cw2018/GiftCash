//
//  EventViewController.h
//  GiftCash
//
//  Created by 张雨红 on 15/1/11.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event+WithUniqueName.h"

@interface EventViewController : UIViewController
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Event *event;
@end
