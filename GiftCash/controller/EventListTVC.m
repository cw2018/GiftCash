//
//  EventListTVC.m
//  GiftCash
//
//  Created by 张雨红 on 15/1/11.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import "EventListTVC.h"
#import "Event.h"
#import "CommonUtils.h"
#import "EventViewController.h"

@interface EventListTVC ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBBI;
@end

@implementation EventListTVC
- (void)performFetch
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
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
- (IBAction)saveEventUnwindSegueAction:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[EventViewController class]]) {
        NSError *error;
        if (![self.context save:&error]) {
            NSLog(@"Can't Save! %@ %@",error, [error localizedDescription]);
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[EventViewController class]]) {
        EventViewController *eventVC = segue.destinationViewController;
        if ([segue.identifier isEqualToString:@"Selection Event Cell Segue"]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            eventVC.event = [self.fetchedResultsController objectAtIndexPath:indexPath];
        }
        eventVC.context = self.context;
    }
}

#pragma mark - TableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Event List Cell"];
    Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = event.name;
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
        if ([event.accounts count]) {
            [CommonUtils defaultAlertView:@"删除事由" message:@"不能删除,有与此事由相关的账单"];
        } else {
            [super tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
        }
    }
}

@end
