//
//  TWCFeedTableViewController.m
//  TwitterClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import "TWCFeedTableViewController.h"
#import "TWCFeedViewModel.h"
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
    
    self.loginButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"feed.actions.login", nil) style:UIBarButtonItemStylePlain target:self  action:@selector(loginTapped)];
    
    self.refreshControl = [UIRefreshControl new];
}

#pragma mark - Public methods

-(void) bindModel:(TWCFeedViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    __weak typeof(self) weakSelf = self;
    
    self.refreshControl.rac_command = self.viewModel.refreshCommand;
    [RACObserve(self.viewModel, feed) subscribeNext:^(id _) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.tableView reloadData];
    }];
}

#pragma mark - Actions

-(void) loginTapped
{
    
}

-(void) logoutTapped
{
    
}

-(void) postTapped
{
    
}

#pragma mark - Table view data source

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

@end
