//
//  TwitterFeedServiceTests.m
//  TwitClientTests
//
//  Created by Ruslan Nikolaev on 03/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TWCTwitterFeedService.h"
#import "TWCApiClient.h"
#import "TWCPostItem.h"

SPEC_BEGIN(TWCTwitterFeedServiceTests)

describe(@"When using FeedService", ^{
    
    TWCApiClient *apiClient = [TWCApiClient mock];
    
    __block TWCTwitterFeedService *service;
    
    context(@"Success fetch with no local storage", ^{
        
        beforeEach(^{
            
            [[apiClient should] receive:@selector(fetchFeedForTwitterClient:completion:failure:)];
            
            service = [[TWCTwitterFeedService alloc] initWithApiClient:apiClient storage:nil];
        });
        
        it(@"should return feed", ^{
            
            KWCaptureSpy *spy = [apiClient captureArgument:@selector(fetchFeedForTwitterClient:completion:failure:) atIndex:1];
            
            __block NSArray<TWCPostItem *> *expectedFeed;
            [service fetchFeedForClient:@"foo" fromCache:false withCompletion:^(NSArray<TWCPostItem *> *posts) {
                expectedFeed = posts;
            } failure:nil];
            
            [[expectedFeed shouldEventually] beNonNil];
            
            FeedCompletion completion = spy.argument;
            completion(@[]);
        });
        
        it(@"should not return error", ^{
            
            KWCaptureSpy *spy = [apiClient captureArgument:@selector(fetchFeedForTwitterClient:completion:failure:) atIndex:2];
            
            __block NSString *expedtedError;
            [service fetchFeedForClient:@"foo" fromCache:false withCompletion:nil failure:^(NSString *reason) {
                expedtedError = reason;
            }];
            
            [[expedtedError shouldNotEventually] beNonNil];
            
            FeedFailure failure = spy.argument;
            failure(@"");
        });
    });
    
    context(@"Fail fetch with no local storage", ^{
        
        beforeAll(^{
            
            [[apiClient should] receive:@selector(fetchFeedForTwitterClient:completion:failure:)];
            
            service = [[TWCTwitterFeedService alloc] initWithApiClient:apiClient storage:nil];
        });
        
        it(@"should return error", ^{
            
            KWCaptureSpy *spy = [apiClient captureArgument:@selector(fetchFeedForTwitterClient:completion:failure:) atIndex:2];
            
            __block NSString *expedtedError;
            [service fetchFeedForClient:@"foo" fromCache:false withCompletion:nil failure:^(NSString *reason) {
                expedtedError = reason;
            }];
            
            [[expedtedError shouldEventually] beNonNil];
            
            FeedFailure failure = spy.argument;
            failure(@"");
        });
        
        it(@"should not return feed", ^{
            
            KWCaptureSpy *spy = [apiClient captureArgument:@selector(fetchFeedForTwitterClient:completion:failure:) atIndex:1];
            
            __block NSArray<TWCPostItem *> *expectedFeed;
            [service fetchFeedForClient:@"foo" fromCache:false withCompletion:^(NSArray<TWCPostItem *> *posts) {
                expectedFeed = posts;
            } failure:nil];
            
            [[expectedFeed shouldNotEventually] beNonNil];
            
            FeedCompletion completion = spy.argument;
            completion(@[]);
        });
    });
});

SPEC_END
