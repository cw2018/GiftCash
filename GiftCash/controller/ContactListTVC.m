//
//  ContactListTVC.m
//  GiftCash
//
//  Created by 张雨红 on 15/1/9.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import "ContactListTVC.h"
#import "Contact.h"
#import "ContactViewController.h"
#import "ContactAccountTVC.h"
#import "CommonUtils.h"

@interface ContactListTVC ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBBI;

@end

@implementation ContactListTVC
- (void)performFetch
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
}

- (IBAction)editTableView:(id)sender {
    self.tableView.editing = !self.tableView.editing;
    if (self.tableView.editing) {
        self.editBBI.title = @"完成";
    } else {
        self.editBBI.title = @"编辑";
    }
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

#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ContactViewController class]]) {
        ContactViewController *contactVC = segue.destinationViewController;
        if ([segue.identifier isEqualToString:@"Accessory Contact List Segue"]) {
            NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
            contactVC.contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
        }
        contactVC.context = self.context;
    } else if ([segue.destinationViewController isKindOfClass:[ContactAccountTVC class]]){
        ContactAccountTVC *contactTVC = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        contactTVC.contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
        contactTVC.context = self.context;
    }
}

- (IBAction)saveContactUnwindSegueAction:(UIStoryboardSegue *)segue
{
    if ([segue.sourceViewController isKindOfClass:[ContactViewController class]]) {
        NSError *error;
        if (![self.context save:&error]) {
            NSLog(@"Can't Save! %@ %@",error, [error localizedDescription]);
        }
    }
}

#pragma mark - TableView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Contact List Cell"];
    Contact *contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = contact.name;
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Contact *contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
        if ([contact.accounts count]) {
            [CommonUtils defaultAlertView:@"删除联系人" message:@"不能删除！有与此联系人相关的账单"];
        } else {
            [super tableView:tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
        }
    }
}

@end
