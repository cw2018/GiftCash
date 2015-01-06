//
//  OutgoAccountSectionHeaderView.m
//  GiftCash
//
//  Created by 张雨红 on 15/1/6.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import "OutgoAccountSectionHeaderView.h"

@implementation OutgoAccountSectionHeaderView

- (void)setup
{
    UIView *containerView = [[[UINib nibWithNibName:@"OutgoAccountSectionHeaderView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
    containerView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:containerView];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

@end
