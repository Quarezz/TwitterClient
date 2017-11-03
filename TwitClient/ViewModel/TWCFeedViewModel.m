//
//  TWCFeedViewModel.m
//  TwitClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import "TWCFeedViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Reachability/Reachability.h>
#import "NSError+Convenience.h"
#import "TWCPostItem.h"
#import "TWCUser.h"

@interface TWCFeedViewModel()

@property (nonatomic, strong) id<TWCTwitterFeedServiceInterface> feedService;
@property (nonatomic, strong) id<TWCTwitterSessionServiceInterface> sessionService;

@property (nonatomic, strong) RACSignal *isLoggedInSignal;
@property (nonatomic, strong) RACSignal *loginSignal;
@property (nonatomic, strong) RACSignal *logoutSignal;
@property (nonatomic, strong) RACSignal *postSignal;
@property (nonatomic, strong) RACSignal *fetchSignal;
@property (nonatomic, strong) RACSignal *localFetchSignal;
@property (nonatomic, strong) RACSignal *reachUnsubSignal;

// I had to add this signal to fix issue with TwitterKit and internet connection
// For details see TWCTwitterSessionService:34
@property (nonatomic, strong) Reachability *reachability;

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
        self.loginSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            
            [self.sessionService loginWithCompletion:^(TWCUser *user) {
                
                self.user = user;
                [subscriber sendNext:user];
                [subscriber sendCompleted];
            } failure:^(NSString *reason) {
                
                [subscriber sendError:[NSError errorWithString:reason]];
            }];
            return nil;
        }] logAll];
        
        self.fetchSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            
            [self.feedService fetchFeedForClient: self.user.identifier fromCache: NO withCompletion:^(NSArray<TWCPostItem *> *posts) {
                
                self.feed = [posts mutableCopy];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            } failure:^(NSString *reason) {
                
                [subscriber sendError:[NSError errorWithString:reason]];
            }];
            return nil;
        }] logAll];
        
        self.localFetchSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            
            [self.feedService fetchFeedForClient: self.user.identifier fromCache: YES withCompletion:^(NSArray<TWCPostItem *> *posts) {
                
                self.feed = [posts mutableCopy];
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            } failure:^(NSString *reason) {
                
                [subscriber sendError:[NSError errorWithString:reason]];
            }];
            return nil;
        }] logAll];
        
        self.isLoggedInSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
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
        }] logAll];
        
        self.logoutSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            
            [self.sessionService logout];
            [self.feedService invalidateCache];
            self.user = nil;
            self.feed = nil;
            [subscriber sendCompleted];
            return nil;
        }] logAll];
        
        self.postSignal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            
            
        }] logAll];
        
        [[[RACObserve(self, active) ignore:@NO] take:1] subscribeNext:^(id _) {
            @strongify(self);

            if (self.feed == nil)
            {
                // show stored feed
                [[self localFetchCommand] execute:nil];
            }
         }];
        
        self.reachUnsubSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            
            [self.reachability stopNotifier];
            [subscriber sendCompleted];
            return nil;
        }];
        
        self.reachability = [Reachability reachabilityForInternetConnection];
        self.reachability.reachableBlock = ^(Reachability *reach) {
            @strongify(self)
            self.connectionAvailable = YES;
            [self.refreshCommand execute:nil];
        };
        self.reachability.unreachableBlock = ^(Reachability *reach) {
            @strongify(self)
            self.connectionAvailable = NO;
        };
        [self.reachability startNotifier];
        self.connectionAvailable = self.reachability.currentReachabilityStatus != NotReachable;
    }
    return self;
}

#pragma mark - Commands

-(RACCommand *) loginCommand
{
    @weakify(self)
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [[[self.loginSignal then:^RACSignal *{
            return self.fetchSignal;
        }] doError:^(NSError *error) {
            self.error = error;
        }] logAll];
    }];
}

-(RACCommand *) logoutCommand
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return self.logoutSignal;
    }];
}

-(RACCommand *) postCommand
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return self.postSignal;
    }];
}

-(RACCommand *) refreshCommand
{
    @weakify(self)
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [[[RACSignal
                  if:self.isLoggedInSignal
                  then:self.fetchSignal
                  else:[RACSignal concat:@[self.loginSignal, self.fetchSignal]]]
                 doError:^(NSError *error) {
                     self.error = error;
                 }] logAll];
    }];
}

-(RACCommand *) connectionCheckBreakCommand
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [self.reachUnsubSignal logAll];
    }];
}

#pragma mark - Private commands

-(RACCommand *) localFetchCommand
{
    @weakify(self)
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        
        return [[RACSignal
                 if:self.isLoggedInSignal
                 then:self.localFetchSignal
                 else:[RACSignal empty]] logAll];
    }];
}

@end
