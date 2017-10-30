//
//  TWCTwitterSessionServiceInterface.h
//  TwitClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

@class TWCUser;

typedef void (^LoginCompletion)(TWCUser *user);
typedef void (^LoginFailure)(NSString *reason);

@protocol TWCTwitterSessionServiceInterface

-(TWCUser *) activeUser;
-(void) logout;
-(void) loginWithCompletion: (LoginCompletion) completion failure: (LoginFailure) failure;

@end
