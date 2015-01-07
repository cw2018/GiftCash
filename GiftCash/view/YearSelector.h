//
//  YearSelector.h
//  GiftCash
//
//  Created by 张雨红 on 15/1/7.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YearSelectorDelegate
- (void)nextYearBtnClicked:(id)sender;
- (void)preYearBtnClicked:(id)sender;
@end

@interface YearSelector : UIView
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UIButton *preBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (nonatomic) NSInteger currentYear;
@property (weak, nonatomic) id <YearSelectorDelegate> delegate;
@end
