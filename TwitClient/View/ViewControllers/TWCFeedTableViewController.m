//
//  TWCFeedTableViewController.m
//  TwitterClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import "TWCFeedTableViewController.h"
#import "TWCFeedViewModel.h"
#import "TWCPostCell.h"
#import "TWCUser.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface TWCFeedTableViewController ()

@property (nonatomic, strong) TWCFeedViewModel *viewModel;

@property (nonatomic, strong) UIBarButtonItem *loginButton;
@property (nonatomic, strong) UIBarButtonItem *logoutButton;
@property (nonatomic, strong) UIBarButtonItem *postButton;

@end

@implementation TWCFeedTableViewController

#pragma mark - Overriden

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    self.loginButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"feed.actions.login", nil) style:UIBarButtonItemStylePlain target:nil  action:nil];
    self.logoutButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"feed.actions.logout", nil) style:UIBarButtonItemStylePlain target:nil  action:nil];
    
    self.refreshControl = [UIRefreshControl new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetPostCell" bundle:nil] forCellReuseIdentifier:@"TWCPostCell"];
    self.tableView.allowsSelection = NO;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.viewModel.active = YES;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.viewModel.active = NO;
}

#pragma mark - Public methods

-(void) bindModel:(TWCFeedViewModel *)viewModel
{
    self.viewModel = viewModel;
    self.refreshControl.rac_command = self.viewModel.refreshCommand;
    self.loginButton.rac_command = self.viewModel.loginCommand;
    self.logoutButton.rac_command = self.viewModel.logoutCommand;
    
    RAC(self,navigationItem.title) = RACObserve(self.viewModel, user.name);
    
    @weakify(self)
    
    [RACObserve(self, viewModel.user) subscribeNext:^(id x) {
        @strongify(self)
        self.navigationItem.leftBarButtonItem = self.viewModel.user ? self.logoutButton : self.loginButton;
    }];
    
    [RACObserve(self.viewModel, feed) subscribeNext:^(id _) {
        @strongify(self)
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.feed.count;
}

-(CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140.f;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWCPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TWCPostCell"];
    [cell setData:self.viewModel.feed[indexPath.row]];
    return cell;
}

@end
