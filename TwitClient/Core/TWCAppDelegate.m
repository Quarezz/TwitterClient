//
//  TWCAppDelegate.m
//  TwitterClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import "TWCAppDelegate.h"

#import "TWCFeedTableViewController.h"
#import "TWCFeedViewModel.h"
#import "TWCTwitterFeedService.h"

@implementation TWCAppDelegate

-(void) applicationDidFinishLaunching:(UIApplication *)application
{
    TWCFeedTableViewController *feedVc = [[TWCFeedTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [feedVc bindModel:[[TWCFeedViewModel alloc] initWithFeedService:[TWCTwitterFeedService new]]];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    window.rootViewController = feedVc;
    self.window = window;
    [self.window makeKeyAndVisible];
}

@end
