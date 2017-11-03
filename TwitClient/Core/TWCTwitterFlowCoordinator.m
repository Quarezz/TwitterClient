//
//  TWCTwitterFlowCoordinator.m
//  TwitClient
//
//  Created by Ruslan Nikolaev on 03/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import "TWCTwitterFlowCoordinator.h"
#import "TWCAppFactory.h"
#import "TWCFeedTableViewController.h"
#import <TwitterKit/TWTRComposerViewController.h>
#import <TwitterKit/TWTRComposer.h>

@interface TWCTwitterFlowCoordinator() <TWTRComposerViewControllerDelegate>

@property (nonatomic, weak) TWCFeedTableViewController *feedVc;

@end

@implementation TWCTwitterFlowCoordinator

#pragma mark - Initialization

-(id) init
{
    if (self = [super init])
    {
        
    }
    return self;
}

#pragma mark - Public methods

-(UIViewController *) initialViewController
{
    if (self.feedVc == nil)
    {
        self.feedVc = [TWCAppFactory createFeedModule];
        self.feedVc.coordinator = self;
    }
    return [[UINavigationController alloc] initWithRootViewController:self.feedVc];
}

-(void) navigateToComposerWithUserId:(NSString *)userId
{
    TWTRComposerViewController *composer = [[TWTRComposerViewController alloc] initWithUserID:userId];
    composer.delegate = self;
    [self.feedVc presentViewController:composer animated:YES completion:nil];
}

#pragma mark - TWTRComposerViewControllerDelegate

- (void)composerDidSucceed:(TWTRComposerViewController *)controller withTweet:(TWTRTweet *)tweet
{
    [self.feedVc updatePosts];
}

@end
