//
//  TWCTwitterSessionService.h
//  TwitClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWCTwitterSessionServiceInterface.h"

@class Twitter;

@interface TWCTwitterSessionService : NSObject <TWCTwitterSessionServiceInterface>

-(id) init  __unavailable;
+(id) new   __unavailable;

-(id) initWithSDK: (Twitter *) sdkInstance defaultsStorage: (NSUserDefaults *) storage;

@end
