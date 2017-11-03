//
//  TWCTwitterFeedService.m
//  TwitClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import "TWCTwitterFeedService.h"
#import <TwitterKit/TwitterKit.h>
#import "TWCApiClient.h"
#import "TWCPostItem.h"

@interface TWCTwitterFeedService()

@property (nonatomic, strong) TWCApiClient *apiClient;
@property (nonatomic, strong) id<TWCPostsStorageInterface> storage;

@end

@implementation TWCTwitterFeedService

#pragma mark - Initialization

-(id) initWithApiClient:(TWCApiClient *)apiClient storage:(id<TWCPostsStorageInterface>)storage
{
    if (self = [super init])
    {
        self.apiClient = apiClient;
        self.storage = storage;
    }
    return self;
}

#pragma mark - TWCTwitterFeedServiceInterface

-(void) fetchFeedForClient:(NSString *)userId fromCache:(BOOL)fromCache withCompletion:(FeedCompletion)completion failure:(FeedFailure)failure
{
    if (fromCache)
    {
        completion([self.storage fetchPosts]);
    }
    else
    {
        __weak typeof(self) weakSelf = self;
        [self.apiClient fetchFeedForTwitterClient:[[TWTRAPIClient alloc] initWithUserID:userId] completion:^(NSArray<TWCPostItem *> *posts) {
            __strong typeof(self) strongSelf = weakSelf;
            
            [strongSelf.storage storePosts:posts];
            completion(posts);
        } failure:failure];
    }
}

-(void) invalidateCache
{
    [self.storage clearPosts];
}

@end
