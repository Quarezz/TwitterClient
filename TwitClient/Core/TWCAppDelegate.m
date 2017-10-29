//
//  TWCAppDelegate.m
//  TwitterClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import "TWCAppDelegate.h"
#import <TwitterKit/TwitterKit.h>
#import "TWCFeedTableViewController.h"
#import "TWCFeedViewModel.h"
#import "TWCTwitterFeedService.h"

@implementation TWCAppDelegate

-(void) applicationDidFinishLaunching:(UIApplication *)application
{
    [[Twitter sharedInstance] startWithConsumerKey:@"5AqiHOLPOMYXW9ZwEZyMFFvot"
                                    consumerSecret:@"yUOe8jcVTnN3QbPfZuC47Yw25Bw5JYiFP6vVzH8vtXM7DCUerS"];
    
    TWCFeedTableViewController *feedVc = [[TWCFeedTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [feedVc bindModel:[[TWCFeedViewModel alloc] initWithFeedService:[TWCTwitterFeedService new]]];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame: [UIScreen mainScreen].bounds];
    window.rootViewController = [[UINavigationController alloc] initWithRootViewController:feedVc];
    self.window = window;
    [self.window makeKeyAndVisible];
}

-(BOOL) application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [[Twitter sharedInstance] application:app openURL:url options:options];
}

@end
