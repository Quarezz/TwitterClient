//
//  TwitterSessionServiceTests.m
//  TwitClientTests
//
//  Created by Ruslan Nikolaev on 03/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import <TwitterKit/TwitterKit.h>
#import "TWCTwitterSessionService.h"
#import "TWCUser.h"
#import <Kiwi/Kiwi.h>


SPEC_BEGIN(TWCTwitterSessionServiceTests)

describe(@"When using SessionService", ^{
    
    Twitter *sdk = [Twitter mock];
    TWTRSessionStore *sessionStore = [TWTRSessionStore mock];
    TWTRSession *session = [TWTRSession mock];

    NSUserDefaults *defaults = [NSUserDefaults mock];
    __block TWCTwitterSessionService *service;
    
    context(@"empty session user", ^{
        
        beforeAll(^{
            
            [[sdk should] receive:@selector(sessionStore) andReturn:sessionStore];
            [[sessionStore should] receive:@selector(session) andReturn:nil];
            service = [[TWCTwitterSessionService alloc] initWithSDK:sdk defaultsStorage:nil];
        });
        
        it(@"should be nil", ^{
            [[service activeUser] shouldBeNil];
        });
    });
    
    context(@"active session user", ^{
        
        beforeEach(^{
            
            [[sdk should] receive:@selector(sessionStore) andReturn:sessionStore];
            [[sessionStore should] receive:@selector(session) andReturn:session];
            [[session should] receive:@selector(userID) andReturn:@"foo"];
            [[defaults should] receive:@selector(objectForKey:) andReturn:@"bar"];
            service = [[TWCTwitterSessionService alloc] initWithSDK:sdk defaultsStorage:defaults];
        });
        
        it(@"shouldn't be nil", ^{
            [[[service activeUser] shouldNot] beNil];
        });

        it(@"should have name and ID", ^{
            
            TWCUser *user = [service activeUser];
            [[user.identifier shouldNot] beNil];
            [[user.name shouldNot] beNil];
        });
    });
    
    context(@"after logout user", ^{
       
        beforeEach(^{
            
            [[sdk should] receive:@selector(sessionStore) andReturn:sessionStore withCount:2];
            
            [[sessionStore should] receive:@selector(session) andReturn:session];
            [[sessionStore should] receive:@selector(logOutUserID:)];
            [[session should] receive:@selector(userID) andReturn:nil];
            
            [[defaults should] receive:@selector(removeObjectForKey:)];
            [[defaults should] receive:@selector(synchronize)];
            
            service = [[TWCTwitterSessionService alloc] initWithSDK:sdk defaultsStorage:defaults];
        });
        
        it(@"should be nil", ^{
            
            [service logout];
            [[[service activeUser] should] beNil];
        });
    });
    
    context(@"after login success, completion", ^{
        
        beforeEach(^{
            
            [[sdk should] receive:@selector(logInWithCompletion:)];
            
            [[session should] receive:@selector(userID) andReturn:@"foo"];
            [[session should] receive:@selector(userName) andReturn:@"bar"];
            
            [[defaults should] receive:@selector(setObject:forKey:)];
            [[defaults should] receive:@selector(synchronize)];
            
            service = [[TWCTwitterSessionService alloc] initWithSDK:sdk defaultsStorage:defaults];
        });
        
        it(@"should return user", ^{
            
            KWCaptureSpy *spy = [sdk captureArgument:@selector(logInWithCompletion:) atIndex:0];
            
            __block TWCUser *expectUser;
            [service loginWithCompletion:^(TWCUser *user) {
                expectUser = user;
            } failure:nil];
            
            [[expectUser shouldEventually] beNonNil];
            
            TWTRLogInCompletion completion = spy.argument;
            completion(session, nil);
        });
    });
    
    context(@"after login failure, completion", ^{
        
        beforeEach(^{
            
            [[sdk should] receive:@selector(logInWithCompletion:)];
            
            service = [[TWCTwitterSessionService alloc] initWithSDK:sdk defaultsStorage:defaults];
        });
        
        it(@"should return error", ^{
            
            KWCaptureSpy *spy = [sdk captureArgument:@selector(logInWithCompletion:) atIndex:0];
            
            __block NSString *expectReason;
            [service loginWithCompletion: nil failure:^(NSString *reason) {
                expectReason = reason;
            }];
            
            [[expectReason shouldEventually] beNonNil];
            
            TWTRLogInCompletion completion = spy.argument;
            completion(nil, [NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"error"}]);
        });
    });
});

SPEC_END


