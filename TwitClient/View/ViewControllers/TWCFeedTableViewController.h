//
//  TWCFeedTableViewController.h
//  TwitterClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TWCFeedViewModel;
@class TWCTwitterFlowCoordinator;

@interface TWCFeedTableViewController : UITableViewController

@property (nonatomic, strong) TWCTwitterFlowCoordinator *coordinator;

-(void) bindModel: (TWCFeedViewModel *) viewModel;
-(void) updatePosts;

@end
