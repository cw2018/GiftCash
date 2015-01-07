//
//  OutgoAccountViewController.m
//  GiftCash
//
//  Created by 张雨红 on 15/1/6.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import "OutgoAccountViewController.h"
#import "OutgoAccountSectionHeaderView.h"
#import "OutgoAccountMoneyTableViewCell.h"
#import <CoreData/CoreData.h>
#import "Contact.h"
#import "Event.h"
#import "CommonUtils.h"

@interface OutgoAccountViewController () <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIPickerView *contactPicker;
@property (strong, nonatomic) UIPickerView *eventPicker;
@property (strong, nonatomic) UIDatePicker *datePicker;

@property (strong, nonatomic) NSArray *contactArray;
@property (strong, nonatomic) NSArray *eventArray;

@property (strong, nonatomic) Contact *selectedContact;
@property (strong, nonatomic) Event *selectedEvent;

@property (strong, nonatomic) NSMutableArray *sectionHeaderArray;
@property (strong, nonatomic) NSMutableArray *outgoAccountPickerCellArray;

@end

@implementation OutgoAccountViewController

typedef NS_ENUM(NSInteger, OutgoAccountTableViewSection) {
    OutgoAccountTableViewSectionContact,
    OutgoAccountTableViewSectionEvent,
    OutgoAccountTableViewSectionDate,
    OutgoAccountTableViewSectionMoney,
    OutgoAccountTableViewSectionMax
};

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contactPicker = [[UIPickerView alloc] init];
    self.contactPicker.delegate = self;
    self.contactPicker.dataSource = self;
    
    self.eventPicker = [[UIPickerView alloc] init];
    self.eventPicker.delegate = self;
    self.eventPicker.dataSource = self;
    
    self.datePicker = [[UIDatePicker alloc] init];
    self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CH"];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(selectDate) forControlEvents:UIControlEventValueChanged];
    
    NSFetchRequest *contactRequest = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
    contactRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)]];
    self.contactArray = [self.context executeFetchRequest:contactRequest error:nil];
    
    NSFetchRequest *eventRequest = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    eventRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)]];
    self.eventArray = [self.context executeFetchRequest:eventRequest error:nil];
    
    self.sectionHeaderArray = [[NSMutableArray alloc] init];
    self.outgoAccountPickerCellArray = [[NSMutableArray alloc] init];
    for (int section = 0; section < OutgoAccountTableViewSectionMoney; section++) {
        OutgoAccountSectionHeaderView *oashView = [[OutgoAccountSectionHeaderView alloc] init];
        oashView.section = section;
        oashView.open = NO;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSectionHeader:)];
        [oashView addGestureRecognizer:tapGesture];
        [self.sectionHeaderArray addObject:oashView];
        
        [self.outgoAccountPickerCellArray addObject:[[UITableViewCell alloc] init]];
    }
    [self.outgoAccountPickerCellArray[OutgoAccountTableViewSectionContact] addSubview:self.contactPicker];
    [self.outgoAccountPickerCellArray[OutgoAccountTableViewSectionEvent] addSubview:self.eventPicker];
    [self.outgoAccountPickerCellArray[OutgoAccountTableViewSectionDate] addSubview:self.datePicker];
    
    OutgoAccountMoneyTableViewCell *moneyCell = [self.tableView dequeueReusableCellWithIdentifier:@"Outgo Account Money Cell"];
    moneyCell.moneyTF.delegate = self;
    moneyCell.moneyTF.tag = 1;
    moneyCell.noteTV.delegate = self;
    moneyCell.noteTV.tag = 2;
    // Make the note TextView border look close to UITextField
    [moneyCell.noteTV.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.3] CGColor]];
    [moneyCell.noteTV.layer setBorderWidth:1.0];
    moneyCell.noteTV.layer.cornerRadius = 5;
    moneyCell.noteTV.clipsToBounds = YES;
    self.outgoAccountPickerCellArray[OutgoAccountTableViewSectionMoney] = moneyCell;
    
    
    if (self.account) {
        self.selectedContact = self.account.contact;
        [self.contactPicker selectRow:[self.contactArray indexOfObject:self.selectedContact] inComponent:0 animated:NO];
        self.selectedEvent = self.account.event;
        [self.eventPicker selectRow:[self.eventArray indexOfObject:self.selectedEvent] inComponent:0 animated:NO];
        self.datePicker.date = self.account.date;
        moneyCell.moneyTF.text = [NSString stringWithFormat:@"%@", self.account.money];
        moneyCell.noteTV.text = self.account.note;
        self.navigationItem.title = @"编辑送礼账单";
    } else {
        self.navigationItem.title = @"添加送礼账单";
        self.datePicker.date = [NSDate date];
    }
    
}

- (void)selectDate {
    OutgoAccountSectionHeaderView *oashView = self.sectionHeaderArray[OutgoAccountTableViewSectionDate];
    oashView.valueLabel.text = [CommonUtils fullStringFromDate:[self.datePicker date]];
}

- (void)tapSectionHeader:(UITapGestureRecognizer *)gestureRecongizer
{
    OutgoAccountSectionHeaderView *oashView = (OutgoAccountSectionHeaderView *)gestureRecongizer.view;
    for (OutgoAccountSectionHeaderView *tmpshView in self.sectionHeaderArray) {
        if (tmpshView.isOpen && tmpshView != oashView) {
            tmpshView.open = NO;
            break;
        }
    }
    oashView.open = !oashView.open;
    
    if (oashView.open) {
        if (oashView.section == OutgoAccountTableViewSectionContact && !self.selectedContact) {
            self.selectedContact = [self.contactArray firstObject];
        } else if (oashView.section == OutgoAccountTableViewSectionEvent && !self.selectedEvent) {
            self.selectedEvent = [self.eventArray firstObject];
        }
    }
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segue
#define SAVE_OUTGO_ACCOUNT_UNWIND_SEGUE @"Save Outgo Account Unwind Segue"
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:SAVE_OUTGO_ACCOUNT_UNWIND_SEGUE]) {
        OutgoAccountMoneyTableViewCell *moneyCell = self.outgoAccountPickerCellArray[OutgoAccountTableViewSectionMoney];
        if (!self.selectedContact) {
            [CommonUtils defaultAlertView:@"保存送礼账单" message:@"联系人不能为空"];
            return NO;
        } else if (!self.selectedEvent) {
            [CommonUtils defaultAlertView:@"保存送礼账单" message:@"事由不能为空"];
            return NO;
        } else if (!self.datePicker.date) {
            [CommonUtils defaultAlertView:@"保存送礼账单" message:@"日期不能为空"];
            return NO;
        } else if ([moneyCell.moneyTF.text doubleValue] <= 0) {
            [CommonUtils defaultAlertView:@"保存送礼账单" message:@"金额不能为空"];
            return NO;
        } else {
            return YES;
        }
    }
    return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SAVE_OUTGO_ACCOUNT_UNWIND_SEGUE]) {
        if (!self.account) {
            self.account = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:self.context];
        }
        self.account.contact = self.selectedContact;
        self.account.event = self.selectedEvent;
        self.account.date = self.datePicker.date;
        OutgoAccountMoneyTableViewCell *moneyCell = self.outgoAccountPickerCellArray[OutgoAccountTableViewSectionMoney];
        self.account.money = [NSNumber numberWithDouble:[moneyCell.moneyTF.text doubleValue]];
        self.account.note = moneyCell.noteTV.text;
    }
}

#pragma mark - Picker View DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.contactPicker) {
        return [self.contactArray count];
    } else if (pickerView == self.eventPicker) {
        return [self.eventArray count];
    } else {
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.contactPicker) {
        return ((Contact *)[self.contactArray objectAtIndex:row]).name;
    } else if (pickerView == self.eventPicker) {
        return ((Event *)[self.eventArray objectAtIndex:row]).name;
    } else {
        return nil;
    }
}

#pragma mark - Picker View Delegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == self.contactPicker) {
        OutgoAccountSectionHeaderView *oashView = self.sectionHeaderArray[OutgoAccountTableViewSectionContact];
        self.selectedContact = [self.contactArray objectAtIndex:row];
        oashView.valueLabel.text = self.selectedContact.name;
    } else if (pickerView == self.eventPicker) {
        OutgoAccountSectionHeaderView *oashView = self.sectionHeaderArray[OutgoAccountTableViewSectionEvent];
        self.selectedEvent = [self.eventArray objectAtIndex:row];
        oashView.valueLabel.text = self.selectedEvent.name;
    }
}

#pragma mark - Table View DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return OutgoAccountTableViewSectionMax;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < OutgoAccountTableViewSectionMoney) {
        return ((OutgoAccountSectionHeaderView *)self.sectionHeaderArray[section]).isOpen ? 1 : 0;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.outgoAccountPickerCellArray[indexPath.section];
}

#pragma mark - Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section < OutgoAccountTableViewSectionMoney) {
        return 38.0f;
    } else {
        return 0.1f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 216.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < OutgoAccountTableViewSectionMoney) {
        OutgoAccountSectionHeaderView *oashView = self.sectionHeaderArray[section];
        switch (section) {
            case OutgoAccountTableViewSectionContact:
                oashView.attrLabel.text = @"收礼人";
                oashView.valueLabel.text = self.selectedContact ? self.selectedContact.name : @"未选择";
                break;
            case OutgoAccountTableViewSectionEvent:
                oashView.attrLabel.text = @"事由";
                oashView.valueLabel.text = self.selectedEvent ? self.selectedEvent.name : @"未选择";
                break;
            case OutgoAccountTableViewSectionDate:
                oashView.attrLabel.text = @"日期";
                oashView.valueLabel.text = [CommonUtils fullStringFromDate:self.datePicker.date];
                break;
                
            default:
                break;
        }
        return oashView;
    } else {
        return nil;
    }
}

#pragma mark - Close All Section
- (void)closeAllSection
{
    for (OutgoAccountSectionHeaderView *oashView in self.sectionHeaderArray) {
        if (oashView.open) {
            oashView.open = NO;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:oashView.section] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

#pragma mark - TextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self closeAllSection];
}

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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UIResponder *nextResponder = [textField.superview viewWithTag:textField.tag + 1];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - TextView Delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self closeAllSection];
}
@end
