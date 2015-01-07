//
//  IncomeViewController.m
//  GiftCash
//
//  Created by 张雨红 on 15/1/7.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import "IncomeViewController.h"
#import <CoreData/CoreData.h>
#import "CommonUtils.h"
#import "Event.h"

@interface IncomeViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) NSArray *eventArray;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *eventPicker;
@end

@implementation IncomeViewController

- (NSArray *)eventArray
{
    if (!_eventArray) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)]];
        _eventArray = [self.context executeFetchRequest:fetchRequest error:nil];
    }
    return _eventArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.datePicker addTarget:self action:@selector(selectDate) forControlEvents:UIControlEventValueChanged];
    
    if (self.income) {
        NSInteger eventIndex = [self.eventArray indexOfObject:self.income.event];
        [self.eventPicker selectRow:eventIndex inComponent:0 animated:NO];
        self.eventLabel.text = self.income.event.name;
        self.datePicker.date = self.income.date;
        self.dateLabel.text = [CommonUtils fullStringFromDate:self.income.date];
    } else {
        Event *event = [self.eventArray firstObject];
        if (event) {
            [self.eventPicker selectRow:0 inComponent:0 animated:NO];
            self.eventLabel.text = event.name;
        } else {
            self.eventLabel.text = @"未选择";
        }
        self.datePicker.date = [NSDate date];
        self.dateLabel.text = [CommonUtils fullStringFromDate:[NSDate date]];
    }
}

- (void)selectDate
{
    self.dateLabel.text = [CommonUtils fullStringFromDate:self.datePicker.date];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segue
#define SAVE_INCOME_UNWIND_SEGUE @"Save Income Unwind Segue"
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:SAVE_INCOME_UNWIND_SEGUE]) {
        if (![self.eventArray count]) {
            [CommonUtils defaultAlertView:@"保存收礼事项" message:@"事由不能为空"];
            return NO;
        }
        return YES;
    }
    return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SAVE_INCOME_UNWIND_SEGUE]) {
        if (!self.income) {
            self.income = [NSEntityDescription insertNewObjectForEntityForName:@"Income" inManagedObjectContext:self.context];
        }
        self.income.date = self.datePicker.date;
        self.income.event = [self.eventArray objectAtIndex:[self.eventPicker selectedRowInComponent:0]];
    }
}

#pragma mark - PickerView DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.eventArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return ((Event *)[self.eventArray objectAtIndex:row]).name;
}

#pragma mark - PickerView Delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.eventLabel.text = ((Event *)[self.eventArray objectAtIndex:row]).name;
}
@end
