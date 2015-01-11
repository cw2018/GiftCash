//
//  Event+WithUniqueName.m
//  GiftCash
//
//  Created by 张雨红 on 15/1/11.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import "Event+WithUniqueName.h"

@implementation Event (WithUniqueName)
+ (Event *)eventWithUniqueName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context
{
    Event *event;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    NSError *error;
    event = [[context executeFetchRequest:fetchRequest error:&error] lastObject];
    if (error) {
        NSLog(@"error, %@, %@", error, error.localizedDescription);
    }
    return event;
}
@end
