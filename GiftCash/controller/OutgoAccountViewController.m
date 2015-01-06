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
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
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
    
    self.datePicker.date = [NSDate date];
    
}

- (void)selectDate {
    
}

- (void)tapSectionHeader:(UITapGestureRecognizer *)gestureRecongizer
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < OutgoAccountTableViewSectionMoney) {
        OutgoAccountSectionHeaderView *oashView = self.sectionHeaderArray[section];
        switch (section) {
            case OutgoAccountTableViewSectionContact:
                oashView.attrLabel.text = @"收礼人";
                oashView.valueLabel.text = @"未选择";
                break;
            case OutgoAccountTableViewSectionEvent:
                oashView.attrLabel.text = @"事由";
                oashView.valueLabel.text = @"未选择";
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == OutgoAccountTableViewSectionDate) {
        return 216.0f;
    } else {
        return 162.f;
    }
}

@end
