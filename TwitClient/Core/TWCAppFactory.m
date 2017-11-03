//
//  TWCAppFactory.m
//  TwitClient
//
//  Created by Ruslan Nikolaev on 03/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import "TWCAppFactory.h"
#import <TwitterKit/Twitter.h>
#import "TWCApiClient.h"
#import "TWCFeedTableViewController.h"
#import "TWCFeedViewModel.h"
#import "TWCTwitterFeedService.h"
#import "TWCTwitterSessionService.h"
#import "TWCPostsStorage.h"


@implementation TWCAppFactory

+(TWCFeedTableViewController *) createFeedModule
{
    TWCFeedTableViewController *vc = [[TWCFeedTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [vc bindModel:[[TWCFeedViewModel alloc] initWithSessionService:[[TWCTwitterSessionService alloc] initWithSDK:[Twitter sharedInstance]
                                                                                                 defaultsStorage:[NSUserDefaults standardUserDefaults]]
                                                           feedService:[[TWCTwitterFeedService alloc] initWithApiClient:[TWCApiClient new]
                                                                                                                storage:[[TWCPostsStorage alloc] initWithInMemoryStorage:NO]]]];
    return vc;
}

@end
