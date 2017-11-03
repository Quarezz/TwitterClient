//
//  TWCApiClient.m
//  TwitClient
//
//  Created by Ruslan Nikolaev on 03/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import "TWCApiClient.h"
#import <TwitterKit/TWTRAPIClient.h>
#import "TWCPostItem.h"

static NSString *kFeedUrl = @"https://api.twitter.com/1.1/statuses/user_timeline.json";
static NSString *kPageLimit = @"20";

@implementation TWCApiClient

-(void) fetchFeedForTwitterClient:(TWTRAPIClient *)twitterClient completion:(FeedCompletion)completion failure:(FeedFailure)failure
{
    NSError *requestError = nil;
    NSURLRequest *request = [twitterClient URLRequestWithMethod:@"GET"
                                                                    URL:kFeedUrl
                                                             parameters:@{
                                                                          @"count": kPageLimit
                                                                          }
                                                                  error:&requestError];
    if (requestError != nil)
    {
        failure(requestError.localizedDescription);
        return;
    }
    
    [twitterClient sendTwitterRequest:request completion:^(NSURLResponse * _Nullable response, NSData * _Nullable data,
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
