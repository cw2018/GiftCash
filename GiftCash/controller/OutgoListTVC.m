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

@interface OutgoListTVC ()

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OutgoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Outgo List Cell"];
    Account *account = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    cell.dateLabel.text = account.date
    cell.contactLabel.text = account.contact.name;
    cell.eventLabel.text = account.event.name;
    cell.moneyLabel.text = [NSString stringWithFormat:@"%@", account.money];
    return cell;
}

@end
