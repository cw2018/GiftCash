//
//  OutgoListTVC.m
//  GiftCash
//
//  Created by 张雨红 on 15/1/6.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import "OutgoListTVC.h"
#import "OutgoListTableViewCell.h"
#import "Account.h"
#import "Contact.h"
#import "Event.h"
#import "CommonUtils.h"
#import "OutgoAccountViewController.h"

@interface OutgoListTVC ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBBI;
@end

@implementation OutgoListTVC

- (void)performFetch {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Account"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"outgo = %@", @(1)];
    fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc]
                                              initWithFetchRequest:fetchRequest
                                              managedObjectContext:self.context
                                              sectionNameKeyPath:nil
                                              cacheName:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self performFetch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OutgoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Outgo List Cell"];
    Account *account = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.dateLabel.text = [CommonUtils mouthAndDayOfDate:account.date];
    cell.contactLabel.text = account.contact.name;
    cell.eventLabel.text = account.event.name;
    cell.moneyLabel.text = [NSString stringWithFormat:@"%@", account.money];
    return cell;
}

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[OutgoAccountViewController class]]) {
        OutgoAccountViewController *outgoAccountVC = segue.destinationViewController;
        if ([segue.identifier isEqualToString:@"Selection Outgo Account Segue"]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            outgoAccountVC.account = [self.fetchedResultsController objectAtIndexPath:indexPath];
        }
        outgoAccountVC.context = self.context;
    }
}

- (IBAction)saveOutgoAccountUnwindSegueAction:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[OutgoAccountViewController class]]) {
        NSError *error;
        if (![self.context save:&error]) {
            NSLog(@"Can't Save! %@ %@",error, [error localizedDescription]);
        }
    }
}

#pragma mark - Edit Action
- (IBAction)editTableView:(id)sender {
    self.tableView.editing = !self.tableView.editing;
    if (self.tableView.editing) {
        self.editBBI.title = @"完成";
    } else {
        self.editBBI.title = @"编辑";
    }
}

@end
