//
//  TwitterStorageTests.m
//  TwitClientTests
//
//  Created by Ruslan Nikolaev on 03/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TWCPostsStorage.h"
#import "TWCPostItem.h"

SPEC_BEGIN(TWCPostsStorageTests)

describe(@"When using PostsStorage", ^{
    
    __block TWCPostsStorage *storage;
    
    beforeEach(^{
        
        storage = [[TWCPostsStorage alloc] initWithInMemoryStorage:YES];
    });
    
    afterEach(^{
        
        [storage clearPosts];
    });
    
    context(@"Empty storage", ^{
        
        it(@"should return empty feed", ^{
            
            [[[storage fetchPosts] shouldNot] beNil];
            [[[storage fetchPosts] should] haveCountOf:0];
        });
    });
    
    context(@"Success storage of 2 elements", ^{
        
        beforeAll(^{
            TWCPostItem *item1 = [TWCPostItem new];
            item1.identifier = @"foo";
            TWCPostItem *item2 = [TWCPostItem new];
            item1.identifier = @"bar";
            [storage storePosts:@[item1, item2]];
        });
        
        it(@"should return feed of 2 elements", ^{
            
            [[[storage fetchPosts] shouldNot] beNil];
            [[[storage fetchPosts] should] haveCountOf:2];
        });
    });
    
    context(@"Clearing of stored elements", ^{
        
        beforeAll(^{
            TWCPostItem *item1 = [TWCPostItem new];
            item1.identifier = @"foo";
            TWCPostItem *item2 = [TWCPostItem new];
            item1.identifier = @"bar";
            [storage storePosts:@[item1, item2]];
            [storage clearPosts];
        });
        
        it(@"should return empty feed", ^{
            
            [[[storage fetchPosts] shouldNot] beNil];
            [[[storage fetchPosts] should] haveCountOf:0];
        });
    });
});

SPEC_END
