//
//  EventViewController.m
//  GiftCash
//
//  Created by 张雨红 on 15/1/11.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import "EventViewController.h"
#import "CommonUtils.h"

@interface EventViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.event) {
        self.nameTF.text = self.event.name;
        self.navigationItem.title = @"编辑事由";
    } else {
        self.navigationItem.title = @"添加事由";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismsKeyBoard:(id)sender {
    [self.nameTF resignFirstResponder];
}

#pragma mark - Segue
#define SAVE_EVENT_UNWIND_SEGUE @"Save Event Unwind Segue"
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:SAVE_EVENT_UNWIND_SEGUE]) {
        NSString *name = [self.nameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (!name.length) {
            [CommonUtils defaultAlertView:@"保存事由" message:@"名称不能为空"];
            return NO;
        }
        Event *existEvent = [Event eventWithUniqueName:name inManagedObjectContext:self.context];
        if (existEvent) {
            if (!self.event) {
                // add event
                [CommonUtils defaultAlertView:@"保存事由" message:@"事由名称不能重复"];
                return NO;
            } else if (self.event && self.event != existEvent) {
                // edit event
                [CommonUtils defaultAlertView:@"保存事由" message:@"事由名称不能重复"];
                return NO;
            }
        }
        return YES;
    }
    return [super shouldPerformSegueWithIdentifier:identifier sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SAVE_EVENT_UNWIND_SEGUE]) {
        if (!self.event) {
            self.event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.context];
        }
        self.event.name = [self.nameTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}
@end
