//
//  IncomeListTVC.m
//  GiftCash
//
//  Created by 张雨红 on 15/1/7.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import "IncomeListTVC.h"
#import "IncomeListTableViewCell.h"
#import "Income.h"
#import "Event.h"
#import "CommonUtils.h"
#import "IncomeViewController.h"

@interface IncomeListTVC ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBBI;

@end

@implementation IncomeListTVC
- (void)performFetch
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Income"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
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

- (IBAction)editTableView:(id)sender {
    self.tableView.editing = !self.tableView.editing;
    if (self.tableView.editing) {
        self.editBBI.title = @"完成";
    } else {
        self.editBBI.title = @"编辑";
    }
}

#pragma mark - Segue
- (IBAction)saveIncomeUnwindSegueAction:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[IncomeViewController class]]) {
        NSError *error;
        if (![self.context save:&error]) {
            NSLog(@"Can't Save! %@ %@",error, [error localizedDescription]);
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[IncomeViewController class]]) {
        IncomeViewController *incomeVC = segue.destinationViewController;
        if ([segue.identifier isEqualToString:@"Accessory Income List Segue"]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            incomeVC.income = [self.fetchedResultsController objectAtIndexPath:indexPath];
        }
        incomeVC.context = self.context;
    }
}

#pragma mark - TableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    IncomeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Income List Cell"];
    Income *income = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.dateLabel.text = [CommonUtils fullStringFromDate:income.date];
    cell.eventLabel.text = income.event.name;
    cell.sumLabel.text = [NSString stringWithFormat:@"%@",[income.accounts valueForKeyPath:@"@sum.money"]];
    return cell;
}
@end
