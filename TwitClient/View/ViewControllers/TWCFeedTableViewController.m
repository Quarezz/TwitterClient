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

@interface UIRefreshControl(ManualTrigger)

-(void) trigger;

@end

@implementation UIRefreshControl(ManualTrigger)

-(void) trigger
{
    UIScrollView *scrollView = (UIScrollView *)[self superview];
    if ([scrollView isKindOfClass:[UIScrollView class]])
    {
        [scrollView setContentOffset:CGPointMake(0, scrollView.contentOffset.y - self.frame.size.height)];
        [self beginRefreshing];
    }
}

@end

@interface TWCFeedTableViewController ()

@property (nonatomic, strong) TWCFeedViewModel *viewModel;

@property (nonatomic, strong) UIBarButtonItem *loginButton;
@property (nonatomic, strong) UIBarButtonItem *logoutButton;
@property (nonatomic, strong) UIBarButtonItem *postButton;

@end

@implementation TWCFeedTableViewController

#pragma mark - Overriden

-(id) initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style])
    {
        self.loginButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"feed.actions.login", nil) style:UIBarButtonItemStylePlain target:nil  action:nil];
        self.logoutButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"feed.actions.logout", nil) style:UIBarButtonItemStylePlain target:nil  action:nil];
        
        self.refreshControl = [UIRefreshControl new];
        
        [self.tableView registerNib:[UINib nibWithNibName:@"TweetPostCell" bundle:nil] forCellReuseIdentifier:@"TWCPostCell"];
        self.tableView.allowsSelection = NO;
    }
    return self;
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
    
    self.navigationItem.leftBarButtonItem = self.viewModel.user ? self.logoutButton : self.loginButton;
    
    // Commands
    
    self.refreshControl.rac_command = self.viewModel.refreshCommand;
    self.loginButton.rac_command = self.viewModel.loginCommand;
    self.logoutButton.rac_command = self.viewModel.logoutCommand;
    
    // Macro bindings
    
    RAC(self,navigationItem.title) = [RACObserve(self.viewModel, user.name) deliverOnMainThread];
    RAC(self,navigationItem.leftBarButtonItem.enabled) = [RACObserve(self.viewModel, connectionAvailable) deliverOnMainThread];
    
    // Observers
    
    @weakify(self)
    
    [[self rac_willDeallocSignal] subscribeCompleted:^{
        @strongify(self)
        [self.viewModel.connectionCheckBreakCommand execute:nil];
    }];
    
    [[RACObserve(self, viewModel.error) deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        
        if (self.viewModel.error)
        {
            [self showError:self.viewModel.error.localizedDescription];
        }
    }];

    [[RACObserve(self, viewModel.user) deliverOnMainThread] subscribeNext:^(id x) {
        @strongify(self)
        
        self.navigationItem.leftBarButtonItem = self.viewModel.user ? self.logoutButton : self.loginButton;
        self.tableView.userInteractionEnabled = self.viewModel.user ? YES : NO;
    } error:^(NSError *error) {
        @strongify(self)
        
        [self showError:error.localizedDescription];
    }];

    [[RACObserve(self.viewModel, feed) deliverOnMainThread] subscribeNext:^(id _) {
        @strongify(self)
        
        [self.tableView reloadData];
    } error:^(NSError *error) {
        @strongify(self)
        [self showError:error.localizedDescription];
    }];
}

#pragma mark - Private methods

-(void) showError: (NSString *) reason
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:reason preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"common.ok", nil) style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
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
