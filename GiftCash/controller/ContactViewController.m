//
//  ContactViewController.m
//  GiftCash
//
//  Created by 张雨红 on 15/1/9.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import "ContactViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "ContactListTVC.h"
#import "CommonUtils.h"

@interface ContactViewController () <ABPeoplePickerNavigationControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.contact) {
        self.nameTF.text = self.contact.name;
        self.phoneTF.text = self.contact.phone;
        self.navigationItem.title = @"编辑联系人";
    } else {
        self.navigationItem.title = @"添加联系人";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)importFromAddressBook:(id)sender {
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)dismsKeyBoard:(id)sender {
    [self.nameTF resignFirstResponder];
    [self.phoneTF resignFirstResponder];
}

#pragma mark - Segue
#define SAVE_CONTACT_UNWIND_SEGUE @"Save Contact Unwind Segue"
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:SAVE_CONTACT_UNWIND_SEGUE]) {
        NSString *name = [self.nameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (!name.length) {
            [CommonUtils defaultAlertView:@"保存联系人" message:@"姓名不能为空"];
            return NO;
        }
        return YES;
    }
    return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SAVE_CONTACT_UNWIND_SEGUE]) {
        if (!self.contact) {
            self.contact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:self.context];
        }
        self.contact.name = [self.nameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        self.contact.phone = self.phoneTF.text;
        
    }
}

#pragma mark ABPeoplePickerNavigationController Delegate
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    NSString *firstName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSString *lastName = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    self.nameTF.text = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
    
    NSString *phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person, kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
        self.phoneTF.text = phone;
    }
}

#pragma mark - TextField Delegate
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


@end
