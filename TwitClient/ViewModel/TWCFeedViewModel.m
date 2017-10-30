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

@property (nonatomic, strong) RACSignal *isLoggedInSignal;
@property (nonatomic, strong) RACSignal *loginSignal;
@property (nonatomic, strong) RACSignal *logoutSignal;
@property (nonatomic, strong) RACSignal *fetchSignal;

@end

@implementation TWCFeedViewModel

#pragma mark - Initialization

-(id) initWithSessionService:(id<TWCTwitterSessionServiceInterface>)sessionService feedService:(id<TWCTwitterFeedServiceInterface>)feedService
{
    if (self = [super init])
    {
        self.sessionService = sessionService;
        self.feedService = feedService;
        
        @weakify(self)
        self.loginSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            @strongify(self)
            [self.sessionService loginWithCompletion:^(TWCUser *user) {
                
                self.user = user;
                [subscriber sendNext:user];
            } failure:^(NSString *reason) {
                
                [subscriber sendError:[NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedDescriptionKey: reason}]];
            }];
            return nil;
        }];
        
        self.fetchSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           
            @strongify(self)
            [self.feedService fetchFeedWithCompletion:^(NSArray<TWCPostItem *> *posts) {
                
                self.feed = [posts mutableCopy];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            } failure:^(NSString *reason) {
                [subscriber sendError:nil];
            }];
            return nil;
        }];
        
        self.isLoggedInSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
           @strongify(self)
            TWCUser *user = self.sessionService.activeUser;
            if (user != nil)
            {
                self.user = user;
                [subscriber sendNext:@true];
            }
            else
            {
                [subscriber sendNext:@false];
            }
            [subscriber sendCompleted];
            return nil;
        }];
        
        self.logoutSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
           
            @strongify(self)
            [self.sessionService logout];
            self.user = nil;
            self.feed = nil;
            return nil;
        }];
        
        [[[RACObserve(self, active) ignore:@NO] take:1] subscribeNext:^(id _) {
             @strongify(self);
             [self.refreshCommand execute:nil];
         }];
        
    }
    return self;
}

#pragma mark - Commands

-(RACCommand *) loginCommand
{
    @weakify(self)
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self.loginSignal then:^RACSignal *{
            return self.fetchSignal;
        }];
    }];
}

-(RACCommand *) logoutCommand
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return self.logoutSignal;
    }];
}

-(RACCommand *) refreshCommand
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        return [RACSignal if:self.isLoggedInSignal
                 then:self.fetchSignal
                 else:[RACSignal concat:@[self.loginSignal, self.fetchSignal]]];
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
