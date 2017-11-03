//
//  TWCTwitterSessionService.m
//  TwitClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import "TWCTwitterSessionService.h"
#import <TwitterKit/TwitterKit.h>
#import "TWCUser.h"

static NSString *kUserNameField = @"twitclient.username";

@interface TWCTwitterSessionService()

@property (nonatomic, strong) Twitter *sdkInstance;
@property (nonatomic, strong) NSUserDefaults *defaultsStorage;

@end

@implementation TWCTwitterSessionService

#pragma mark - Initialization

-(id) initWithSDK:(Twitter *)sdkInstance defaultsStorage:(NSUserDefaults *)storage
{
    if (self = [super init])
    {
        self.sdkInstance = sdkInstance;
        self.defaultsStorage = storage;
    }
    return self;
}

#pragma mark - TWCTwitterSessionServiceInterface

-(TWCUser *) activeUser
{
    NSString *userId = [[self.sdkInstance sessionStore] session].userID;
    if (userId != nil)
    {
        TWCUser *user = [[TWCUser alloc] init];
        user.identifier = userId;
        user.name = [self.defaultsStorage objectForKey:kUserNameField];
        return user;
    }
    else
    {
        return nil;
    }
}

-(void) loginWithCompletion:(LoginCompletion)completion failure:(LoginFailure)failure
{
    // Unable to handle case with SFSafariViewController tapped 'Done' (inside vc itself).
    // Looks like SDK just ignores delegate method and doesn't throw callback
    // For the sake of sanity I'll just leave this AS IS cause this is just a test task
    // Otherwise would be implementing custom login form with REST requests
    // Also this call doesn't give callback when there is no internet
    // why it had to be twitter(((((
    
    __weak typeof(self) weakSelf = self;
    [self.sdkInstance logInWithMethods:TWTRLoginMethodWebBasedForceLogin completion:^(TWTRSession * _Nullable session, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (error != nil)
        {
            failure(error.localizedDescription);
            return;
        }
        
        TWCUser *user = [[TWCUser alloc] init];
        user.identifier = session.userID;
        user.name = session.userName;
        
        [strongSelf.defaultsStorage setObject:user.name forKey:kUserNameField];
        [strongSelf.defaultsStorage synchronize];
        
        completion(user);
    }];
}

-(void) logout
{
    [self.defaultsStorage removeObjectForKey:kUserNameField];
    [self.defaultsStorage synchronize];
    
    [[self.sdkInstance sessionStore] logOutUserID:[[[Twitter sharedInstance] sessionStore] session].userID];
}

@end
