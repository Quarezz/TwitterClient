//
//  TWCFeedTableViewController.m
//  TwitterClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import "TWCFeedTableViewController.h"
#import "TWCFeedViewModel.h"

@interface TWCFeedTableViewController ()

@property (nonatomic, strong) TWCFeedViewModel *viewModel;

@end

@implementation TWCFeedTableViewController

#pragma mark - Overriden

-(void) viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(refreshTriggered) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Public methods

-(void) bindModel:(TWCFeedViewModel *)viewModel
{
    self.viewModel = viewModel;
}

#pragma mark - Actions

-(void) refreshTriggered
{
    [self.viewModel fetchFeed];
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
