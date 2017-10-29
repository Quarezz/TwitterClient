//
//  TWCTwitterFeedServiceInterface.h
//  TwitClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

typedef void (^FeedResult)(int i);

@protocol TWCTwitterFeedServiceInterface

-(void) fetchFeedWithCompletion: (FeedResult) completion;

@end
