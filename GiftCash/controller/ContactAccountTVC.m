//
//  ContactAccountTVC.m
//  GiftCash
//
//  Created by 张雨红 on 15/1/11.
//  Copyright (c) 2015年 Eva. All rights reserved.
//

#import "ContactAccountTVC.h"
#import "ContactAccountTableViewCell.h"
#import "Account.h"
#import "Event.h"
#import "CommonUtils.h"

@interface ContactAccountTVC ()

@end

@implementation ContactAccountTVC
- (void)performFetch
{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Account"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"contact = %@", self.contact];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.contact) {
        self.navigationItem.title = self.contact.name;
    }
    
    [self performFetch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TabeView DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Contact Account Cell"];
    Account *account = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.typeLabel.text = [account.outgo intValue] ? @"送礼" : @"收礼";
    cell.dateLabel.text = [CommonUtils fullStringFromDate:account.date];
    cell.eventLabel.text = account.event.name;
    cell.moneyLabel.text = [NSString stringWithFormat:@"%@", account.money];
    return cell;
}

@end
