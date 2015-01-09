//
//  IncomeAccountViewController.m
//  GiftCash
//
//  Created by 张雨红 on 15/1/9.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import "IncomeAccountViewController.h"
#import "Contact.h"
#import "CommonUtils.h"
#import "IncomeAccountListTVC.h"

@interface IncomeAccountViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *contactPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) NSArray *contactArray;

@end

@implementation IncomeAccountViewController

- (NSArray *)contactArray
{
    if (!_contactArray) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
        _contactArray = [self.context executeFetchRequest:fetchRequest error:nil];
    }
    return _contactArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contactPicker.delegate = self;
    self.contactPicker.dataSource = self;
    [self.datePicker addTarget:self action:@selector(selectDate) forControlEvents:UIControlEventValueChanged];
    
    if (self.account) {
        self.navigationItem.title = @"编辑收礼账单";
        [self.contactPicker selectRow:[self.contactArray indexOfObject:self.account.contact] inComponent:0 animated:NO];
        self.contactLabel.text = self.account.contact.name;
        self.datePicker.date = self.account.date;
        self.dateLabel.text = [CommonUtils fullStringFromDate:self.account.date];
        self.moneyTF.text = [NSString stringWithFormat:@"%@", self.account.money];
    } else {
        self.navigationItem.title = @"添加收礼账单";
        if ([self.contactArray count]) {
            [self.contactPicker selectRow:0 inComponent:0 animated:NO];
            self.contactLabel.text = ((Contact *)[self.contactArray firstObject]).name;
        } else {
            self.contactLabel.text = @"未选择";
        }
        self.datePicker.date = [NSDate date];
        self.dateLabel.text = [CommonUtils fullStringFromDate:self.datePicker.date];
    }
    
    
}

- (void)selectDate {
    self.dateLabel.text = [CommonUtils fullStringFromDate:self.datePicker.date];
    [self.moneyTF resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)dismissKeyBoard:(id)sender {
    [self.moneyTF resignFirstResponder];
}

#pragma mark - Segue
#define SAVE_INCOME_ACCOUNT_UNWIND_SEGUE @"Save Income Account Unwind Segue"
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:SAVE_INCOME_ACCOUNT_UNWIND_SEGUE]) {
        if (!self.contactLabel.text) {
            [CommonUtils defaultAlertView:@"保存收礼账单" message:@"送礼人不能为空"];
            return NO;
        } else if (![self.moneyTF.text doubleValue]) {
            [CommonUtils defaultAlertView:@"保存收礼账单" message:@"金额不能为空"];
            return NO;
        }
        return YES;
    }
    return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[IncomeAccountListTVC class]]) {
        if (!self.account) {
            self.account = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:self.context];
            self.account.outgo = @(0);
            self.account.event = self.income.event;
            self.account.income = self.income;
        }
        self.account.contact = [self.contactArray objectAtIndex:[self.contactPicker selectedRowInComponent:0]];
        self.account.money = @([self.moneyTF.text doubleValue]);
        self.account.date = self.datePicker.date;
    }
}

#pragma mark - PickerView DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.contactArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Contact *contact = [self.contactArray objectAtIndex:row];
    return contact.name;
}

#pragma mark - PickerView Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    Contact *contact = [self.contactArray objectAtIndex:row];
    self.contactLabel.text = contact.name;
}

#pragma mark - TextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // double XXXX.XX
    if (![string length]) {
        return YES;
    }
    NSUInteger dotLocation = [textField.text rangeOfString:@"."].location;
    if (dotLocation == NSNotFound) {
        if ([string isEqualToString:@"."]) {
            return YES;
        }
    } else if ([[textField.text substringFromIndex:dotLocation] length] > 2) {
        return NO;
    }
    
    if ([string intValue] || [string isEqualToString:@"0"]) {
        return YES;
    }
    return NO;
}

@end
