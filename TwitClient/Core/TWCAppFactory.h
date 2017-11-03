//
//  TWCAppFactory.h
//  TwitClient
//
//  Created by Ruslan Nikolaev on 03/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TWCFeedTableViewController;

@interface TWCAppFactory : NSObject

+(nonnull TWCFeedTableViewController *) createFeedModule;

@end
