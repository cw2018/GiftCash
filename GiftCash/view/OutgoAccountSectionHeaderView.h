//
//  OutgoAccountSectionHeaderView.h
//  GiftCash
//
//  Created by 张雨红 on 15/1/6.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OutgoAccountSectionHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *attrLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@property (nonatomic) NSInteger section;
@property (nonatomic, getter=isOpen) BOOL open;
@end
