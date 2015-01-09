//
//  IncomeAccountListTVC.m
//  GiftCash
//
//  Created by 张雨红 on 15/1/9.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import "IncomeAccountListTVC.h"
#import "IncomeAccountListTableViewCell.h"
#import "Contact.h"
#import "Account.h"
#import "CommonUtils.h"
#import "Event.h"
#import "IncomeAccountViewController.h"

@interface IncomeAccountListTVC ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addBBI;
@property (strong, nonatomic) UIBarButtonItem *editBBI;
@end

@implementation IncomeAccountListTVC

- (void)performFetch
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Account"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"outgo = %@ && income = %@", @(0), self.income];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"contact.name" ascending:YES selector:@selector(localizedStandardCompare:)]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@ (%@)", self.income.event.name, [CommonUtils fullStringFromDate:self.income.date]];
    self.editBBI = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editTableView)];
    self.navigationItem.rightBarButtonItems = @[self.addBBI, self.editBBI];
    
    [self performFetch];
}

- (void)editTableView
{
    self.tableView.editing = !self.tableView.editing;
    if (self.tableView.editing) {
        self.editBBI.title = @"完成";
    } else {
        self.editBBI.title = @"编辑";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segue
- (IBAction)saveIncomeAccountUnwindSegueAction:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[IncomeAccountViewController class]]) {
        NSError *error;
        if (![self.context save:&error]) {
            NSLog(@"Can't Save! %@ %@",error, [error localizedDescription]);
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[IncomeAccountViewController class]]) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.income.event.name style:UIBarButtonItemStylePlain target:nil action:nil];
        IncomeAccountViewController *iaVC = segue.destinationViewController;
        if ([segue.identifier isEqualToString:@"Selection Income Account Segue"]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            iaVC.account = [self.fetchedResultsController objectAtIndexPath:indexPath];
        }
        iaVC.income = self.income;
        iaVC.context = self.context;
    }
}

#pragma mark - TableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IncomeAccountListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Income Account List Cell"];
    Account *account = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.contactLabel.text = account.contact.name;
    cell.moneyLabel.text = [NSString stringWithFormat:@"%@", account.money];
    cell.dateLabel.text = [CommonUtils fullStringFromDate:account.date];
    return cell;
}

@end
