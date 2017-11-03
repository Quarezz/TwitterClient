//
//  TWCFeedViewModel.h
//  TwitClient
//
//  Created by Ruslan Nikolaev on 29/10/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWCTwitterFeedServiceInterface.h"
#import "TWCTwitterSessionServiceInterface.h"

@class RACSignal;
@class RACCommand;

@interface TWCFeedViewModel : NSObject

@property (nonatomic, strong) TWCUser *user;
@property (nonatomic, strong) NSMutableArray<TWCPostItem *> *feed;

@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) BOOL connectionAvailable;
@property (nonatomic, copy) NSError *error;

@property (nonatomic, strong, readonly) RACCommand *loginCommand;
@property (nonatomic, strong, readonly) RACCommand *logoutCommand;
@property (nonatomic, strong, readonly) RACCommand *refreshCommand;
@property (nonatomic, strong, readonly) RACCommand *connectionCheckBreakCommand;

-(id) initWithSessionService: (id<TWCTwitterSessionServiceInterface>) sessionService
                 feedService: (id<TWCTwitterFeedServiceInterface>) feedService;


@end
