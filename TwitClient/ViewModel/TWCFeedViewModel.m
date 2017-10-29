//
//  TWCFeedViewModel.m
//  TwitClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import "TWCFeedViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TWCPostItem.h"

@interface TWCFeedViewModel()

@property (nonatomic, strong) id<TWCTwitterFeedServiceInterface> feedService;
@property (nonatomic, strong) id<TWCTwitterSessionServiceInterface> sessionService;

@end

@implementation TWCFeedViewModel

#pragma mark - Initialization

-(id) initWithSessionService:(id<TWCTwitterSessionServiceInterface>)sessionService feedService:(id<TWCTwitterFeedServiceInterface>)feedService
{
    if (self = [super init])
    {
        self.sessionService = sessionService;
        self.feedService = feedService;
    }
    return self;
}

#pragma mark - Methods

-(void) fetchUser
{
    TWCUser *activeUser = [self.sessionService activeUser];
    if (activeUser != nil)
    {
        
    }
    else
    {
        [self.sessionService loginWithCompletion:^(TWCUser *user) {
            
        } failure:^(NSString *reason) {
            
        }];
    }
}

#pragma mark - Commands

-(RACCommand *) refreshCommand
{
    __weak typeof(self) weakSelf = self;
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [self.feedService fetchFeedWithCompletion:^(NSArray<TWCPostItem *> *posts) {
                
                __strong typeof(weakSelf) strongSelf = weakSelf;
                strongSelf.feed = [posts mutableCopy];
                
                [subscriber sendNext:posts];
                [subscriber sendCompleted];
            } failure:^(NSString *reason) {
                [subscriber sendError:nil];
            }];
            return nil;
        }];
    }];
}

-(RACCommand *) loadMoreCommand
{
    __weak typeof(self) weakSelf = self;
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [self.feedService loadMoreWithLastID: weakSelf.feed.lastObject.identifier completion:^(NSArray<TWCPostItem *> *posts) {
                
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf.feed addObjectsFromArray:posts];
                
                [subscriber sendNext:posts];
                [subscriber sendCompleted];
            } failure:^(NSString *reason) {
                [subscriber sendError:nil];
            }];
            return nil;
        }];
    }];
}


@end
