//
//  ContactAccountTVC.h
//  GiftCash
//
//  Created by 张雨红 on 15/1/11.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "Contact.h"

@interface ContactAccountTVC : CoreDataTableViewController
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) Contact *contact;
@end
