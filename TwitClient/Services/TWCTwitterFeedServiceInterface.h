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

-(void) fetchFeedWithCompletion: (FeedCompletion) completion failure: (FeedFailure) failure;
-(void) loadMoreWithLastID: (NSString *) lastItemId completion: (FeedCompletion) completion failure: (FeedFailure) failure;

@end
