//
//  TWCTwitterFeedService.m
//  TwitClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import "TWCTwitterFeedService.h"
#import <TwitterKit/TwitterKit.h>
#import "TWCPostItem.h"

static NSString *kFeedUrl = @"https://api.twitter.com/1.1/statuses/user_timeline.json";
static NSString *kPageLimit = @"20";

@implementation TWCTwitterFeedService

#pragma mark - Private methods

#pragma mark - TWCTwitterFeedServiceInterface

-(void) fetchFeedWithCompletion:(FeedCompletion)completion failure:(FeedFailure)failure
{
    __weak typeof(self) weakSelf = self;
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession * _Nullable session, NSError * _Nullable error) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error != nil)
        {
            failure(error.localizedDescription);
        }
        else
        {
            NSURLRequest *request = [[TWTRAPIClient clientWithCurrentUser] URLRequestWithMethod:@"GET"
                                                                                            URL:kFeedUrl
                                                                                     parameters:@{
                                                                                                  @"count": kPageLimit
                                                                                                  }
                                                                                          error:nil];
            [strongSelf sendTwitterRequest:request completion:completion failure:failure];
        }
    }];
}

-(void) loadMoreWithLastID:(NSString *) lastItemId completion:(FeedCompletion)completion failure:(FeedFailure)failure
{
    __weak typeof(self) weakSelf = self;
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession * _Nullable session, NSError * _Nullable error) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error != nil)
        {
            failure(error.localizedDescription);
        }
        else
        {
            NSURLRequest *request = [[TWTRAPIClient clientWithCurrentUser] URLRequestWithMethod:@"GET"
                                                                                            URL:kFeedUrl
                                                                                     parameters:@{
                                                                                                  @"count": kPageLimit,
                                                                                                  @"since_id": lastItemId
                                                                                                  }
                                                                                          error:nil];
            [strongSelf sendTwitterRequest:request completion:completion failure:failure];
        }
    }];
}

#pragma mark - Private metods

-(void) sendTwitterRequest: (NSURLRequest *) request completion:(FeedCompletion)completion failure:(FeedFailure)failure
{
    [[TWTRAPIClient clientWithCurrentUser] sendTwitterRequest:request completion:^(NSURLResponse * _Nullable response, NSData * _Nullable data,
                                                                                   NSError * _Nullable connectionError) {
        if (connectionError != nil)
        {
            failure(connectionError.localizedDescription);
            return;
        }
        
        NSError *parsingError = nil;
        NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
        if (parsingError != nil || [jsonData isKindOfClass:[NSArray class]] == NO)
        {
            failure(NSLocalizedString(@"web.parsing.error", nil));
            return;
        }
        NSLog(@"Received posts: %@", jsonData);
        
        NSMutableArray<TWCPostItem *> *feed = [NSMutableArray new];
        for (NSDictionary *item in jsonData)
        {
            TWCPostItem *post = [[TWCPostItem alloc] initWithDictionary:item];
            [feed addObject:post];
        }
        completion(feed);
    }];
}

@end
