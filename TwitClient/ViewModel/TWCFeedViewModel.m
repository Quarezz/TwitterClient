//
//  TWCFeedViewModel.m
//  TwitClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import "TWCFeedViewModel.h"

@interface TWCFeedViewModel()

@property (nonatomic, strong) id<TWCTwitterFeedServiceInterface> feedService;

@end

@implementation TWCFeedViewModel

#pragma mark - Initialization

-(id) initWithFeedService:(id<TWCTwitterFeedServiceInterface>)service
{
    if (self = [super init])
    {
        self.feedService = service;
    }
    return self;
}

-(void) fetchFeed
{
    [self.feedService fetchFeedWithCompletion:^(int i) {
        
    }];
}

@end
