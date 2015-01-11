//
//  Event+WithUniqueName.h
//  GiftCash
//
//  Created by 张雨红 on 15/1/11.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import "Event.h"

@interface Event (WithUniqueName)
+ (Event *)eventWithUniqueName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;
@end
