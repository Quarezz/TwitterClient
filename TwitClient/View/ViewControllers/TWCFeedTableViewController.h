//
//  TWCFeedTableViewController.h
//  TwitterClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TWCFeedViewModel;

@interface TWCFeedTableViewController : UITableViewController

-(void) bindModel: (TWCFeedViewModel *) viewModel;

@end
