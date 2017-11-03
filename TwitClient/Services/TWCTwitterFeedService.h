//
//  TWCTwitterFeedService.h
//  TwitClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWCTwitterFeedServiceInterface.h"
#import "TWCPostsStorageInterface.h"
@class TWCApiClient;

@interface TWCTwitterFeedService : NSObject <TWCTwitterFeedServiceInterface>

-(id) init  __unavailable;
+(id) new   __unavailable;

-(id) initWithApiClient: (TWCApiClient *) apiClient storage: (id<TWCPostsStorageInterface>) storage;

@end
