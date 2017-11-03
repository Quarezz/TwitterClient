//
//  TWCApiClient.h
//  TwitClient
//
//  Created by Ruslan Nikolaev on 03/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWCTwitterFeedServiceInterface.h"

@class TWTRAPIClient;

@interface TWCApiClient : NSObject

-(void) fetchFeedForTwitterClient: (TWTRAPIClient *) twitterClient completion:(FeedCompletion)completion failure:(FeedFailure)failure;

@end
