//
//  TWCTwitterFeedServiceInterface.h
//  TwitClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

@class TWCPostItem;

typedef void (^FeedCompletion)(NSArray<TWCPostItem *> *posts);
typedef void (^FeedFailure)(NSString *reason);

@protocol TWCTwitterFeedServiceInterface

-(void) fetchFeedForClient: (NSString *) userId
                 fromCache: (BOOL) fromCache
            withCompletion: (FeedCompletion) completion
                   failure: (FeedFailure) failure;

@end
