//
//  YearSelector.m
//  GiftCash
//
//  Created by 张雨红 on 15/1/7.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import "YearSelector.h"

@implementation YearSelector

- (NSInteger)currentYear
{
    return [self.yearLabel.text integerValue];
}

- (void)setCurrentYear:(NSInteger)currentYear
{
    self.yearLabel.text = [NSString stringWithFormat:@"%ld", (long)currentYear];
}

- (void)setup
{
    UIView *containerView = [[[UINib nibWithNibName:@"YearSelector" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
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

- (IBAction)preYear:(id)sender {
    self.currentYear -= 1;
    [self.delegate preYearBtnClicked:sender];
}

- (IBAction)nextYear:(id)sender {
    self.currentYear += 1;
    [self.delegate nextYearBtnClicked:sender];
}


@end
