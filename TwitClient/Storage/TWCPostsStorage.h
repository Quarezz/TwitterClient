//
//  TWCPostsStorage.h
//  TwitClient
//
//  Created by Ruslan Nikolaev on 03/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWCPostsStorageInterface.h"

@interface TWCPostsStorage : NSObject <TWCPostsStorageInterface>

-(id) init  __unavailable;
+(id) new   __unavailable;

-(id) initWithInMemoryStorage: (BOOL) inMemory;

@end
