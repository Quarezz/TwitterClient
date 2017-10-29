//
//  TWCFeedViewModel.h
//  TwitClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWCTwitterFeedServiceInterface.h"

@interface TWCFeedViewModel : NSObject

-(id) initWithFeedService: (id<TWCTwitterFeedServiceInterface>) service;

-(void) fetchFeed;

@end
