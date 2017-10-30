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

@implementation TWCTwitterSessionService

#pragma mark - TWCTwitterSessionServiceInterface

-(TWCUser *) activeUser
{
    NSString *userId = [[[Twitter sharedInstance] sessionStore] session].userID;
    if (userId != nil)
    {
        TWCUser *user = [[TWCUser alloc] init];
        user.name = userId;
        return user;
    }
    else
    {
        return nil;
    }
}

-(void) loginWithCompletion:(LoginCompletion)completion failure:(LoginFailure)failure
{
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession * _Nullable session, NSError * _Nullable error) {
        
        if (error != nil)
        {
            failure(error.localizedDescription);
            return;
        }
        
        TWCUser *user = [[TWCUser alloc] init];
        user.name = session.userName;
        completion(user);
    }];
}

-(void) logout
{
    [[[Twitter sharedInstance] sessionStore] logOutUserID:[[[Twitter sharedInstance] sessionStore] session].userID];
}

@end
