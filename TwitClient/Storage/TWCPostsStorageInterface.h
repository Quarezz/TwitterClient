//
//  TWCPostsStorageInterface.h
//  TwitClient
//
//  Created by Ruslan Nikolaev on 03/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

@class TWCPostItem;
@class NSArray;

@protocol TWCPostsStorageInterface

-(void) storePosts: (NSArray<TWCPostItem *> *) posts;
-(NSArray<TWCPostItem *> *) fetchPosts;
-(void) clearPosts;

@end
