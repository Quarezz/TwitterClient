//
//  TWCPostItemTests.m
//  TwitClientTests
//
//  Created by Ruslan Nikolaev on 03/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "TWCPostItem.h"

SPEC_BEGIN(TWCPostItemTests)

describe(@"When using PostItem", ^{
    
    __block NSDictionary *validDict = @{
                                        @"id": @12345,
                                        @"text": @"foo",
                                        @"created_at": @"Tue Oct 24 09:58:18 +0000 2017",
                                        @"favorited": @5,
                                        @"user": @{
                                                @"name": @"john",
                                                @"screen_name": @"black"
                                                }
                                        };
    __block NSDictionary *invalidDict =  @{};
    
    __block TWCPostItem *item;
    
    context(@"After parsing valid dict", ^{
       
        beforeAll(^{
            item = [[TWCPostItem alloc] initWithDictionary:validDict];
        });
        
        it(@"should have valid fields", ^{
            [[item.identifier shouldNot] beNil];
            [[item.text shouldNot] beNil];
            [[item.date shouldNot] beNil];
            [[item.authorName shouldNot] beNil];
            [[item.authorScreenName shouldNot] beNil];
        });
    });
   
    context(@"After parsing invalid dict", ^{
        
        beforeAll(^{
            item = [[TWCPostItem alloc] initWithDictionary:invalidDict];
        });
        
        it(@"should have invalid fields", ^{
            [[item.identifier should] beNil];
            [[item.text should] beNil];
            [[item.date should] beNil];
            [[item.authorName should] beNil];
            [[item.authorScreenName should] beNil];
        });
    });
});

SPEC_END
