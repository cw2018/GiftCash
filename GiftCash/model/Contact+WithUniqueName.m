//
//  Contact+WithUniqueName.m
//  GiftCash
//
//  Created by 张雨红 on 15/1/11.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import "Contact+WithUniqueName.h"

@implementation Contact (WithUniqueName)
+ (Contact *)contactWithUniqueName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    Contact *contact;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSError *error;
    contact = [[context executeFetchRequest:fetchRequest error:&error] lastObject];
    if (error) {
        NSLog(@"error, %@, %@", error, error.localizedDescription);
    }
    return contact;
}
@end
